using AdjustmentsLambda.Data;
using AdjustmentsLambda.Metrics;
using MySqlConnector;
using Serilog;

namespace AdjustmentsLambda.Handlers;

public class StockAdjustmentHandler
{
    private readonly ILogger _logger;
    private readonly ICloudWatchMetrics _cloudWatchMetrics;
    private readonly RdsConnectionFactory _connectionFactory;

    public StockAdjustmentHandler(
        ILogger logger,
        ICloudWatchMetrics cloudWatchMetrics,
        RdsConnectionFactory connectionFactory)
    {
        _logger = logger;
        _cloudWatchMetrics = cloudWatchMetrics;
        _connectionFactory = connectionFactory;
    }

    // TODO: Modify Function and create with your own logic the error events
    public async Task<StockAdjustmentResult> HandleAsync(CreateAdjustmentRequest body, string requestId)
    {
        if (string.IsNullOrWhiteSpace(body.StoreId) || string.IsNullOrWhiteSpace(body.Sku))
        {
            await _cloudWatchMetrics.RecordValidationFailedAsync();
            
            // TODO: Update params with your own model
            _logger
                .ForContext("RequestId", requestId)
                .ForContext("StoreId", body.StoreId)
                .ForContext("Sku", body.Sku)
                .ForContext("DeltaQty", body.DeltaQty)
                .ForContext("Reason", body.Reason)
                .Warning("Request validation failed: storeId and sku are required");

            return new StockAdjustmentResult(400, new ApiError("VALIDATION", "storeId and sku are required"));
        }

        using var connection = await _connectionFactory.CreateAsync();
        var insertSql = @"INSERT INTO stock_adjustments (store_id, sku, delta_qty, reason, created_at)
VALUES (@storeId, @sku, @deltaQty, @reason, UTC_TIMESTAMP())";
        using var cmd = new MySqlCommand(insertSql, connection);
        cmd.Parameters.AddWithValue("@storeId", body.StoreId);
        cmd.Parameters.AddWithValue("@sku", body.Sku);
        cmd.Parameters.AddWithValue("@deltaQty", body.DeltaQty);
        cmd.Parameters.AddWithValue("@reason", body.Reason);
        await cmd.ExecuteNonQueryAsync();

        _logger
            .ForContext("RequestId", requestId)
            .ForContext("StoreId", body.StoreId)
            .ForContext("Sku", body.Sku)
            .ForContext("DeltaQty", body.DeltaQty)
            .ForContext("Reason", body.Reason)
            .Information("Stock adjustment inserted into RDS");

        await _cloudWatchMetrics.RecordAdjustmentCreatedAsync();

        return new StockAdjustmentResult(201, new { success = true });
    }
}
