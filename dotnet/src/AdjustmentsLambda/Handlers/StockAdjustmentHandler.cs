using Serilog;

namespace AdjustmentsLambda.Handlers;

using AdjustmentsLambda.Metrics;

public class StockAdjustmentHandler
{
    private readonly ILogger _logger;
    private readonly ICloudWatchMetrics _cloudWatchMetrics;

    public StockAdjustmentHandler(ILogger logger, ICloudWatchMetrics cloudWatchMetrics)
    {
        _logger = logger;
        _cloudWatchMetrics = cloudWatchMetrics;
    }

    public async Task<StockAdjustmentResult> HandleAsync(CreateAdjustmentRequest body, string requestId)
    {
        if (string.IsNullOrWhiteSpace(body.StoreId) || string.IsNullOrWhiteSpace(body.Sku))
        {
            await _cloudWatchMetrics.RecordValidationFailedAsync();
            _logger
                .ForContext("RequestId", requestId)
                .ForContext("StoreId", body.StoreId)
                .ForContext("Sku", body.Sku)
                .ForContext("DeltaQty", body.DeltaQty)
                .ForContext("Reason", body.Reason)
                .Warning("Request validation failed: storeId and sku are required");

            return new StockAdjustmentResult(400, new ApiError("VALIDATION", "storeId and sku are required"));
        }

        _logger
            .ForContext("RequestId", requestId)
            .ForContext("StoreId", body.StoreId)
            .ForContext("Sku", body.Sku)
            .ForContext("DeltaQty", body.DeltaQty)
            .ForContext("Reason", body.Reason)
            .Information("Stock adjustment accepted");

        await _cloudWatchMetrics.RecordAdjustmentCreatedAsync();

        return new StockAdjustmentResult(201, new { success = true });
    }
}
