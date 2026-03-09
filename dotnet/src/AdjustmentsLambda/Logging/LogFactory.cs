using Serilog;
using Serilog.Formatting.Compact;
using System.Threading;

namespace AdjustmentsLambda.Logging;

public static class LogFactory
{
    private static int _initialized;

    public static ILogger CreateLogger()
    {
        if (Interlocked.Exchange(ref _initialized, 1) == 0)
        {
            Log.Logger = new LoggerConfiguration()
                .MinimumLevel.Information()
                .Enrich.WithProperty("Service", "AdjustmentsLambda")
                .WriteTo.Console(new RenderedCompactJsonFormatter())
                .CreateLogger();
        }

        return Log.Logger;
    }
}
