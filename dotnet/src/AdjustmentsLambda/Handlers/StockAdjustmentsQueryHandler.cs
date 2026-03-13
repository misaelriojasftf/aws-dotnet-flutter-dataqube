using AdjustmentsLambda.Data;
using MySqlConnector;
using Serilog;

namespace AdjustmentsLambda.Handlers;

public class StockAdjustmentsQueryHandler
{
    private readonly ILogger _logger;
    private readonly RdsConnectionFactory _connectionFactory;

    public StockAdjustmentsQueryHandler(ILogger logger, RdsConnectionFactory connectionFactory)
    {
        _logger = logger;
        _connectionFactory = connectionFactory;
    }

    // TODO: add query to filter by sku
    public async Task<IReadOnlyList<object>> GetAdjustmentsAsync(
        string storeId,
        int limit,
        string requestId)
    {
        using var connection = await _connectionFactory.CreateAsync();
        var sql = @"SELECT id, store_id, sku, delta_qty, reason, created_at
FROM stock_adjustments
WHERE store_id = @storeId
ORDER BY created_at DESC
LIMIT @limit";
        using var cmd = new MySqlCommand(sql, connection);
        cmd.Parameters.AddWithValue("@storeId", storeId);
        cmd.Parameters.AddWithValue("@limit", limit);

        using var reader = await cmd.ExecuteReaderAsync();
        var list = new List<object>();
        while (await reader.ReadAsync())
        {
            list.Add(new
            {
                id = reader["id"],
                storeId = reader["store_id"],
                sku = reader["sku"],
                deltaQty = reader["delta_qty"],
                reason = reader["reason"],
                createdAt = reader["created_at"]
            });
        }

        _logger
            .ForContext("RequestId", requestId)
            .ForContext("StoreId", storeId)
            .ForContext("Limit", limit)
            .Information("Stock adjustments loaded from RDS");

        return list;
    }
}
