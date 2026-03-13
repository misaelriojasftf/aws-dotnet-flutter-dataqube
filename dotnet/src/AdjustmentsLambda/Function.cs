using Amazon.Lambda.APIGatewayEvents;
using Amazon.Lambda.Core;
using Amazon.CloudWatch;
using AdjustmentsLambda.Data;
using AdjustmentsLambda.Handlers;
using AdjustmentsLambda.Logging;
using AdjustmentsLambda.Metrics;
using Serilog;
using System.Text.Json;

[assembly: LambdaSerializer(typeof(Amazon.Lambda.Serialization.SystemTextJson.DefaultLambdaJsonSerializer))]

namespace AdjustmentsLambda;
// TODO: Modify Function and create with your own logic the error events
public class Function
{
    private static readonly ILogger Logger = LogFactory.CreateLogger();
    private static readonly ICloudWatchMetrics CloudWatchMetrics = new CloudWatchMetrics(
        new AmazonCloudWatchClient(),
        Logger,
        Environment.GetEnvironmentVariable("METRICS_NAMESPACE") ?? "StockOps");
    private static readonly RdsConnectionFactory RdsConnectionFactory = new();
    private static readonly StockAdjustmentHandler StockAdjustmentHandler =
        new(Logger, CloudWatchMetrics, RdsConnectionFactory);
    private static readonly StockAdjustmentsQueryHandler StockAdjustmentsQueryHandler =
        new(Logger, RdsConnectionFactory);

    public async Task<APIGatewayHttpApiV2ProxyResponse> FunctionHandler(
        APIGatewayHttpApiV2ProxyRequest request,
        ILambdaContext context)
    {
        var requestId = GetRequestId(request, context);
        var httpMethod = request.RequestContext?.Http?.Method ?? string.Empty;
        var path = NormalizePath(request);
        var rawPath = request.RawPath ?? string.Empty;
        var stage = request.RequestContext?.Stage ?? Environment.GetEnvironmentVariable("STAGE") ?? string.Empty;

        Logger
            .ForContext("RequestId", requestId)
            .ForContext("HttpMethod", httpMethod)
            .ForContext("RawPath", rawPath)
            .ForContext("NormalizedPath", path)
            .ForContext("Stage", stage)
            .ForContext("HasPathParams", request.PathParameters is not null && request.PathParameters.Count > 0)
            .ForContext("HasQueryParams", request.QueryStringParameters is not null && request.QueryStringParameters.Count > 0)
            .Information("Incoming request");

        if (IsGetAdjustmentsRequest(request, httpMethod, path, out var storeId, out var limit))
        {
            Logger
                .ForContext("RequestId", requestId)
                .ForContext("Route", "GET /stores/{storeId}/adjustments")
                .ForContext("StoreId", storeId)
                .ForContext("Limit", limit)
                .Information("Route matched");

            if (string.IsNullOrWhiteSpace(storeId))
            {
                await CloudWatchMetrics.RecordValidationFailedAsync();
                Logger
                    .ForContext("RequestId", requestId)
                    .Warning("Request validation failed: storeId is required");
                return BadRequest("storeId is required", requestId);
            }

            try
            {
                var list = await StockAdjustmentsQueryHandler.GetAdjustmentsAsync(storeId, limit, requestId);
                return Json(200, list, requestId);
            }
            catch (Exception ex)
            {
                Logger
                    .ForContext("RequestId", requestId)
                    .ForContext("StoreId", storeId)
                    .Error(ex, "Unhandled error while reading stock adjustments");

                await CloudWatchMetrics.RecordSystemErrorAsync();
                return Json(500, new ApiError("SYSTEM_ERROR", "Unexpected server error"), requestId);
            }
        }

        if (!IsPostAdjustmentsRequest(httpMethod, path))
        {
            Logger
                .ForContext("RequestId", requestId)
                .ForContext("Route", "POST /adjustments")
                .ForContext("HttpMethod", httpMethod)
                .ForContext("NormalizedPath", path)
                .Information("Route not matched");
            return NotFound("Route not found", requestId);
        }

        Logger
            .ForContext("RequestId", requestId)
            .ForContext("Route", "POST /adjustments")
            .Information("Route matched");

        if (string.IsNullOrWhiteSpace(request.Body))
        {
            await CloudWatchMetrics.RecordValidationFailedAsync();
            Logger
                .ForContext("RequestId", requestId)
                .Warning("Request validation failed: body is required");
            return BadRequest("Body is required", requestId);
        }

        CreateAdjustmentRequest? body;

        try
        {
            body = JsonSerializer.Deserialize<CreateAdjustmentRequest>(
                request.Body,
                new JsonSerializerOptions { PropertyNameCaseInsensitive = true }
            );
        }
        catch
        {
            await CloudWatchMetrics.RecordValidationFailedAsync();
            Logger
                .ForContext("RequestId", requestId)
                .Warning("Request validation failed: invalid JSON body");
            return BadRequest("Invalid JSON", requestId);
        }

        if (body is null)
        {
            await CloudWatchMetrics.RecordValidationFailedAsync();
            Logger
                .ForContext("RequestId", requestId)
                .Warning("Request validation failed: invalid payload");
            return BadRequest("Invalid payload", requestId);
        }

        try
        {
            var result = await StockAdjustmentHandler.HandleAsync(body, requestId);

            return Json(result.StatusCode, result.Body, requestId);
        }
        catch (Exception ex)
        {
            Logger
                .ForContext("RequestId", requestId)
                .ForContext("StoreId", body.StoreId)
                .ForContext("Sku", body.Sku)
                .ForContext("DeltaQty", body.DeltaQty)
                .Error(ex, "Unhandled error while processing stock adjustment");

            await CloudWatchMetrics.RecordSystemErrorAsync();
            return Json(500, new ApiError("SYSTEM_ERROR", "Unexpected server error"), requestId);
        }
    }

    /// Request ID Extraction Helper
    private static string GetRequestId(
        APIGatewayHttpApiV2ProxyRequest request,
        ILambdaContext context)
    {
        if (request.Headers is null)
        {
            return context.AwsRequestId;
        }

        if (TryGetHeaderValue(request.Headers, "X-Request-ID", out var requestId) &&
            !string.IsNullOrWhiteSpace(requestId))
        {
            return requestId;
        }

        return context.AwsRequestId;
    }

    /// Get Value from Headers Helper
    private static bool TryGetHeaderValue(
        IDictionary<string, string> headers, 
        string headerName,
        out string value)
    {
        if (headers.TryGetValue(headerName, out value!))
        {
            return true;
        }

        foreach (var entry in headers)
        {
            if (string.Equals(entry.Key, headerName, StringComparison.OrdinalIgnoreCase))
            {
                value = entry.Value;
                return true;
            }
        }

        value = string.Empty;
        return false;
    }

    /// Bad Request Helper

    private static APIGatewayHttpApiV2ProxyResponse BadRequest(
        string message,
        string requestId)
    {
        return Json(400, new ApiError("VALIDATION", message), requestId);
    }

    private static APIGatewayHttpApiV2ProxyResponse NotFound(
        string message,
        string requestId)
    {
        return Json(404, new ApiError("NOT_FOUND", message), requestId);
    }

    private static bool IsPostAdjustmentsRequest(string httpMethod, string path)
    {
        var matched = httpMethod.Equals("POST", StringComparison.OrdinalIgnoreCase) &&
                      path.EndsWith("/adjustments", StringComparison.OrdinalIgnoreCase);
        if (!matched)
        {
            Logger
                .ForContext("HttpMethod", httpMethod)
                .ForContext("NormalizedPath", path)
                .Debug("POST /adjustments not matched");
        }
        return matched;
    }

    private static bool IsGetAdjustmentsRequest(
        APIGatewayHttpApiV2ProxyRequest request,
        string httpMethod,
        string path,
        out string storeId,
        out int limit)
    {
        storeId = string.Empty;
        limit = 20;

        if (!httpMethod.Equals("GET", StringComparison.OrdinalIgnoreCase))
        {
            Logger
                .ForContext("HttpMethod", httpMethod)
                .ForContext("NormalizedPath", path)
                .Debug("GET /stores/{storeId}/adjustments not matched: method");
            return false;
        }

        if (request.PathParameters is not null &&
            request.PathParameters.TryGetValue("storeId", out var fromPath) &&
            !string.IsNullOrWhiteSpace(fromPath))
        {
            storeId = fromPath;
        }
        else
        {
            var prefix = "/stores/";
            var suffix = "/adjustments";
            if (path.StartsWith(prefix, StringComparison.OrdinalIgnoreCase) &&
                path.EndsWith(suffix, StringComparison.OrdinalIgnoreCase))
            {
                var start = prefix.Length;
                var length = path.Length - prefix.Length - suffix.Length;
                if (length > 0)
                {
                    storeId = path.Substring(start, length);
                }
            }
        }

        if (string.IsNullOrWhiteSpace(storeId))
        {
            Logger
                .ForContext("HttpMethod", httpMethod)
                .ForContext("NormalizedPath", path)
                .ForContext("RawPath", request.RawPath ?? string.Empty)
                .ForContext("HasPathParams", request.PathParameters is not null && request.PathParameters.Count > 0)
                .Debug("GET /stores/{storeId}/adjustments not matched: storeId missing");
        }

        if (request.QueryStringParameters is not null &&
            request.QueryStringParameters.TryGetValue("limit", out var rawLimit) &&
            int.TryParse(rawLimit, out var parsedLimit) &&
            parsedLimit > 0)
        {
            limit = parsedLimit;
        }

        return !string.IsNullOrWhiteSpace(storeId);
    }

    private static string NormalizePath(APIGatewayHttpApiV2ProxyRequest request)
    {
        var path = request.RawPath ?? string.Empty;
        var stage = request.RequestContext?.Stage;
        if (string.IsNullOrWhiteSpace(stage))
        {
            stage = Environment.GetEnvironmentVariable("STAGE");
        }

        if (!string.IsNullOrWhiteSpace(stage))
        {
            var prefix = "/" + stage.Trim('/');
            if (path.StartsWith(prefix + "/", StringComparison.OrdinalIgnoreCase) ||
                string.Equals(path, prefix, StringComparison.OrdinalIgnoreCase))
            {
                var trimmed = path.Substring(prefix.Length);
                if (string.IsNullOrEmpty(trimmed))
                {
                    trimmed = "/";
                }
                return TrimTrailingSlash(trimmed);
            }
        }

        return TrimTrailingSlash(path);
    }

    private static string TrimTrailingSlash(string path)
    {
        if (path.Length > 1 && path.EndsWith("/", StringComparison.Ordinal))
        {
            return path.TrimEnd('/');
        }

        return path;
    }
    /// Json Response Helper

    private static APIGatewayHttpApiV2ProxyResponse Json(
        int statusCode,
        object body,
        string requestId)
    {
        return new APIGatewayHttpApiV2ProxyResponse
        {
            StatusCode = statusCode,
            Body = JsonSerializer.Serialize(body),
            Headers = new Dictionary<string, string>
            {
                ["Content-Type"] = "application/json",
                ["X-Request-ID"] = requestId
            }
        };
    }
}


// TODO: Modify Model and create with your own parameters
public record CreateAdjustmentRequest(
    string StoreId,
    string Sku,
    int DeltaQty,
    string? Reason);

public record ApiError(string Code, string Message);

public record StockAdjustmentResult(int StatusCode, object Body);
