using Amazon.Lambda.APIGatewayEvents;
using Amazon.Lambda.Core;
using System.Text.Json;

[assembly: LambdaSerializer(typeof(Amazon.Lambda.Serialization.SystemTextJson.DefaultLambdaJsonSerializer))]

namespace AdjustmentsLambda;

public class Function
{
    public Task<APIGatewayProxyResponse> FunctionHandler(
        APIGatewayProxyRequest request,
        ILambdaContext context)
    {
        var requestId = GetRequestId(request, context);

        /// TODO: Create a validation for new HEADER KEY
        
        if (string.IsNullOrWhiteSpace(request.Body))
        {
            return Task.FromResult(BadRequest("Body is required", requestId));
        }

        CreateAdjustmentRequest? body;

        try
        {   
            /// TODO: UPDATE THIS TO HANDLE ANOTHER MODEL
            /// 
            body = JsonSerializer.Deserialize<CreateAdjustmentRequest>(
                request.Body,
                new JsonSerializerOptions { PropertyNameCaseInsensitive = true }
            );
        }
        catch
        {
            return Task.FromResult(BadRequest("Invalid JSON", requestId));
        }

        if (body is null)
        {
            return Task.FromResult(BadRequest("Invalid payload", requestId));
        }
        
        /// TODO: CHANGE THIS TO FOLLOW THE NEW MODEL 
        /// 
        if (string.IsNullOrWhiteSpace(body.StoreId) ||
            string.IsNullOrWhiteSpace(body.Sku))
        {
            return Task.FromResult(BadRequest("storeId and sku are required", requestId));
        }

        Console.WriteLine(JsonSerializer.Serialize(new
        {
            requestId,
            storeId = body.StoreId,
            sku = body.Sku,
            deltaQty = body.DeltaQty
        }));

        // {success: true}
        return Task.FromResult(Json(201, new { success = true }, requestId));
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

    /// TODO: CREATE ANOTHER BAD REQUEST HELPER TYPE
    /// 
    /// 
    // private static APIGatewayProxyResponse UserAccesDenied(
    //     string message,
    //     string requestId)
    // {
    //     return Json(400, new ApiError("----", message), requestId);
    // }

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


// Basic Models

/// TODO: UPDATE THIS MODEL WITH YOUR OWN MODEL
public record CreateAdjustmentRequest(
    string StoreId,
    int DeltaQty,
    string? Reason,
    string? PhotoKey
)
{
    // TODO: FIX THIS MODEL TO MATCH THE POST BODY
    //
    public string? Sku { get; internal set; }
}


public record ApiError(string Code, string Message);
