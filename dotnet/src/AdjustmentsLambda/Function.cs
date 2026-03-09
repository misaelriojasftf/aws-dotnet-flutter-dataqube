using Amazon.Lambda.APIGatewayEvents;
using Amazon.Lambda.Core;
using Amazon.CloudWatch;
using AdjustmentsLambda.Handlers;
using AdjustmentsLambda.Logging;
using AdjustmentsLambda.Metrics;
using Serilog;
using System.Text.Json;

[assembly: LambdaSerializer(typeof(Amazon.Lambda.Serialization.SystemTextJson.DefaultLambdaJsonSerializer))]

namespace AdjustmentsLambda;

public class Function
{
    private static readonly ILogger Logger = LogFactory.CreateLogger();
    private static readonly ICloudWatchMetrics CloudWatchMetrics = new CloudWatchMetrics(
        new AmazonCloudWatchClient(),
        Logger,
        Environment.GetEnvironmentVariable("METRICS_NAMESPACE") ?? "StockOps");
    private static readonly StockAdjustmentHandler StockAdjustmentHandler = new(Logger, CloudWatchMetrics);

    public async Task<APIGatewayProxyResponse> FunctionHandler(
        APIGatewayProxyRequest request,
        ILambdaContext context)
    {
        var requestId = GetRequestId(request, context);

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
        APIGatewayProxyRequest request,
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

    private static APIGatewayProxyResponse BadRequest(
        string message,
        string requestId)
    {
        return Json(400, new ApiError("VALIDATION", message), requestId);
    }

    /// Json Response Helper

    private static APIGatewayProxyResponse Json(
        int statusCode,
        object body,
        string requestId)
    {
        return new APIGatewayProxyResponse
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


public record CreateAdjustmentRequest(
    string StoreId,
    string Sku,
    int DeltaQty,
    string? Reason);

public record ApiError(string Code, string Message);

public record StockAdjustmentResult(int StatusCode, object Body);
