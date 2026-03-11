using MySqlConnector;

namespace AdjustmentsLambda.Data;

public class RdsConnectionFactory
{
    private readonly DbConfig _config;

    public RdsConnectionFactory()
        : this(DbConfig.FromEnvironment())
    {
    }

    public RdsConnectionFactory(DbConfig config)
    {
        _config = config;
    }

    public async Task<MySqlConnection> CreateAsync()
    {
        var connectionString = new MySqlConnectionStringBuilder
        {
            Server = _config.Host,
            Database = _config.Database,
            UserID = _config.Username,
            Password = _config.Password,
            Port = _config.Port,
            SslMode = MySqlSslMode.Required
        }.ConnectionString;

        var connection = new MySqlConnection(connectionString);
        await connection.OpenAsync();
        return connection;
    }
}

public record DbConfig(
    string Host,
    string Database,
    string Username,
    string Password,
    uint Port)
{
    public static DbConfig FromEnvironment()
    {
        var host = GetRequired("DB_HOST");
        var database = GetRequired("DB_NAME");
        var username = GetRequired("DB_USER");
        var password = GetRequired("DB_PASSWORD");
        var portRaw = Environment.GetEnvironmentVariable("DB_PORT");
        var port = 3306u;
        if (!string.IsNullOrWhiteSpace(portRaw) &&
            uint.TryParse(portRaw, out var parsedPort))
        {
            port = parsedPort;
        }

        return new DbConfig(host, database, username, password, port);
    }

    private static string GetRequired(string name)
    {
        var value = Environment.GetEnvironmentVariable(name);
        if (string.IsNullOrWhiteSpace(value))
        {
            throw new InvalidOperationException($"Missing required environment variable: {name}");
        }

        return value;
    }
}
