using Amazon.CloudWatch;
using Amazon.CloudWatch.Model;
using Serilog;

namespace AdjustmentsLambda.Metrics;

public interface ICloudWatchMetrics
{
    Task RecordAdjustmentCreatedAsync();
    Task RecordValidationFailedAsync();
    Task RecordSystemErrorAsync();

    // TODO: Create new event for metrics

}

public class CloudWatchMetrics : ICloudWatchMetrics
{
    private readonly IAmazonCloudWatch _cloudWatchClient;
    private readonly ILogger _logger;
    private readonly string _namespace;

    public CloudWatchMetrics(
        IAmazonCloudWatch cloudWatchClient,
        ILogger logger,
        string metricsNamespace)
    {
        _cloudWatchClient = cloudWatchClient;
        _logger = logger;
        _namespace = metricsNamespace;
    }

    public Task RecordAdjustmentCreatedAsync() =>
        PutCountMetricAsync("AdjustmentsCreated");

    public Task RecordValidationFailedAsync() =>
        PutCountMetricAsync("AdjustmentsValidationFailed");

    public Task RecordSystemErrorAsync() =>
        PutCountMetricAsync("AdjustmentsSystemError");

    // TODO: Implement new event for metics 

    private async Task PutCountMetricAsync(string metricName)
    {
        try
        {
            await _cloudWatchClient.PutMetricDataAsync(new PutMetricDataRequest
            {
                Namespace = _namespace,
                MetricData =
                [
                    new MetricDatum
                    {
                        MetricName = metricName,
                        Unit = StandardUnit.Count,
                        Value = 1,
                        Timestamp = DateTime.UtcNow
                    }
                ]
            });
        }
        catch (Exception ex)
        {
            _logger
                .ForContext("MetricNamespace", _namespace)
                .ForContext("MetricName", metricName)
                .Warning(ex, "Failed to publish custom CloudWatch metric");
        }
    }
}
