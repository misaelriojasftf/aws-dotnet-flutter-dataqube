using Amazon.SecretsManager;
using Amazon.SecretsManager.Model;
using MySqlConnector;
using System.Text.Json;

namespace AdjustmentsLambda.Data;

public class RdsConnectionFactory
{
    private readonly DbConfig? _config;
    private readonly string _secretId;

    public RdsConnectionFactory()
        : this(null, DbConfig.GetSecretIdFromEnvironment())
    {
    }

    public RdsConnectionFactory(DbConfig config)
    {
        _config = config;
        _secretId = string.Empty;
    }

    private RdsConnectionFactory(DbConfig? config, string secretId)
    {
        _config = config;
        _secretId = secretId;
    }

    public async Task<MySqlConnection> CreateAsync()
    {
        var config = _config ?? await DbConfig.FromSecretsManagerAsync(_secretId);

        var connectionString = new MySqlConnectionStringBuilder
        {
            Server = config.Host,
            Database = config.Database,
            UserID = config.Username,
            Password = config.Password,
            Port = config.Port,
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

    public static string GetSecretIdFromEnvironment()
    {
        return GetRequired("DB_SECRET_ID");
    }

    public static async Task<DbConfig> FromSecretsManagerAsync(string secretId, CancellationToken cancellationToken = default)
    {
        if (string.IsNullOrWhiteSpace(secretId))
        {
            throw new InvalidOperationException("Missing required secret id for database configuration.");
        }

        using var client = new AmazonSecretsManagerClient();
        var response = await client.GetSecretValueAsync(new GetSecretValueRequest
        {
            SecretId = secretId
        }, cancellationToken);

        if (string.IsNullOrWhiteSpace(response.SecretString))
        {
            throw new InvalidOperationException($"Secret '{secretId}' has no SecretString value.");
        }

        var secret = JsonSerializer.Deserialize<SecretPayload>(
            response.SecretString,
            new JsonSerializerOptions { PropertyNameCaseInsensitive = true });

        if (secret is null ||
            string.IsNullOrWhiteSpace(secret.Host) ||
            string.IsNullOrWhiteSpace(secret.Database) ||
            string.IsNullOrWhiteSpace(secret.Username) ||
            string.IsNullOrWhiteSpace(secret.Password))
        {
            throw new InvalidOperationException($"Secret '{secretId}' is missing required fields.");
        }

        var port = secret.Port ?? 3306u;
        return new DbConfig(secret.Host, secret.Database, secret.Username, secret.Password, port);
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

public sealed record SecretPayload(
    string Host,
    string Database,
    string Username,
    string Password,
    uint? Port);
