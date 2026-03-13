# .NET Observability Lab — Serilog + AWS CloudWatch

## Session 17 — .NET + RDS (MySQL) (simplified, no VPC)

### Learning Objectives
1. Connect Lambda to RDS in a VPC.
2. Connect to MySQL using environment variables.
3. Implement `GET /stores/{storeId}/adjustments`.

### Theory (20 min)
- For a simplified lab, use a public RDS endpoint and keep Lambda outside a VPC.
- Credentials are stored in AWS Secrets Manager and injected via secret id.

### Demo (20 min)
1. Create table `stock_adjustments`.
2. Insert from Lambda.
3. Read list by store.

Table DDL:
```sql
CREATE TABLE IF NOT EXISTS stock_adjustments (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  store_id VARCHAR(64) NOT NULL,
  sku VARCHAR(64) NOT NULL,
  delta_qty INT NOT NULL,
  reason VARCHAR(255) NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);
```

### Guided Lab (90 min)

#### Checkpoint 1: Environment variables (20 min)
Create the secret in AWS Secrets Manager:
```
aws secretsmanager create-secret \
  --name rds/stockops1 \
  --secret-string '{
    "username": "admin",
    "password": "StrongPassword123!",
    "host": "db-stockops.ch46cgika5uh.us-east-2.rds.amazonaws.com",
    "database": "stockops",
    "port": 3306
  }'
```

Set this environment variable in Lambda:
```
DB_SECRET_ID=rds/stockops1
```

#### Checkpoint 2: MySQL connection in .NET (40 min)
Packages:
```
dotnet add package MySqlConnector
dotnet add package AWSSDK.SecretsManager
```

Connection factory:
```
public class RdsConnectionFactory
{
    public async Task<MySqlConnection> CreateAsync()
    {
        var config = await DbConfig.FromSecretsManagerAsync(
            Environment.GetEnvironmentVariable("DB_SECRET_ID"));
        var cs = new MySqlConnectionStringBuilder
        {
            Server = config.Host,
            Database = config.Database,
            UserID = config.Username,
            Password = config.Password,
            Port = config.Port,
            SslMode = MySqlSslMode.Required
        }.ConnectionString;
        var conn = new MySqlConnection(cs);
        await conn.OpenAsync();
        return conn;
    }
}
```

#### Checkpoint 3: Endpoint `GET /stores/{storeId}/adjustments` (30 min)
```
GET /stores/{storeId}/adjustments?limit=20
```

### Real Exercise (30 min)
TODO for students:
- Add index `(store_id, created_at)` if it does not exist.
- Implement pagination with `created_at < lastSeen`.

### Session Checklist
- DB environment variables configured.
- Lambda connects to RDS (public endpoint).
- `GET /stores/{storeId}/adjustments` works.

## Overview
This project demonstrates how to implement **structured logging** and **custom metrics** in a .NET Web API using:

- Serilog for structured JSON logging
- AWS CloudWatch Logs for centralized log storage
- AWS CloudWatch Metrics for operational monitoring
- CloudWatch Alarms for proactive incident detection

This lab helps developers build production-grade observability practices.

---

## Learning Objectives

By completing this lab, you will learn how to:

1. Implement structured JSON logging
2. Emit custom metrics per business operation
3. Monitor application health without manually inspecting logs
4. Prepare basic alarms for error conditions

---

## Architecture

Client → .NET API → Serilog → CloudWatch Logs  
                      ↘ Custom Metrics → CloudWatch Metrics → Alarms

---

## Prerequisites

- .NET 8 SDK
- AWS Account
- AWS CLI configured
- RDS MySQL instance (public for lab)
- IAM permissions:
  - CloudWatch Logs write access
  - CloudWatch Metrics write access

---

## NuGet Packages

Install required packages:

```
dotnet add package Serilog
dotnet add package Serilog.Formatting.Compact
dotnet add package AWSSDK.CloudWatch
dotnet add package AWSSDK.CloudWatchLogs
dotnet add package AWSSDK.SecretsManager
dotnet add package MySqlConnector
```

---

## Structured Logging

Structured logging records events as JSON objects instead of plain text.

### Benefits

- Filter logs by fields
- Faster debugging
- Better monitoring
- Easier analytics

### Log Fields

Logs include:

- RequestId
- StoreId
- Sku
- DeltaQty
- Reason

### Example Log

```json
{
  "RequestId": "abc-123",
  "StoreId": "store-77",
  "Sku": "SKU-1",
  "Delta": 5,
  "Reason": "Stock replenishment"
}
```

---

## Custom Metrics

Metrics provide numerical monitoring of business operations.

### Namespace

```
StockOps
```

### Metrics

#### Successful Requests (HTTP 201)

Metric Name: **AdjustmentsCreated**  
Unit: Count

#### Validation Failures (HTTP 400)

Metric Name: **AdjustmentsValidationFailed**  
Unit: Count

#### System Errors (Exceptions)

Metric Name: **AdjustmentsSystemError**  
Unit: Count

---

## Project Structure

```
/Logging
   LogFactory.cs

/Metrics
   CloudWatchMetrics.cs

/Handlers
   StockAdjustmentHandler.cs
```

---

## Running the Project

### 1. Clone repository

```
git clone <repo-url>
cd project
```

### 2. Configure AWS Credentials

```
aws configure
```

### 3. Build project

```
dotnet build
```

### 4. Deploy with SAM (Lambda + API)

```
sam build
sam deploy --guided \
  --parameter-overrides \
    Stage=stg \
    DbSecretId=rds/stockops1
```

### 5. Run API locally (optional)

```
dotnet run
```

---

## Testing the Endpoint

### Endpoint

```
POST /adjustments
```

### Example Request

```json
{
  "storeId": "store-1",
  "sku": "SKU-99",
  "deltaQty": 10,
  "reason": "Restock"
}
```

### Example cURL (replace `<domain>`)

```
curl -s -X POST "https://<domain>/adjustments" \
  -H "Content-Type: application/json" \
  -d '{"storeId":"store-1","sku":"SKU-99","deltaQty":10,"reason":"Restock"}'
```

```
curl -s "https://<domain>/stores/store-1/adjustments?limit=20"
```

### Endpoint

```
GET /stores/{storeId}/adjustments?limit=20
```

### Example Response
```json
[
  {
    "id": 1,
    "storeId": "store-1",
    "sku": "SKU-99",
    "deltaQty": 10,
    "reason": "Restock",
    "createdAt": "2026-03-11T08:45:00Z"
  }
]
```

---

## Verifying Logs

1. Open AWS Console
2. Go to CloudWatch
3. Select Log Groups
4. Open application log group
5. Filter logs using:

```
fields RequestId, StoreId, Sku
| sort @timestamp desc
```

---

## Verifying Metrics

1. Open CloudWatch
2. Go to Metrics
3. Select namespace **StockOps**
4. View metrics:
   - AdjustmentsCreated
   - AdjustmentsValidationFailed
   - AdjustmentsSystemError

---

## Creating Alarms

1. Open CloudWatch → Alarms
2. Create Alarm
3. Select metric **AdjustmentsSystemError**
4. Set threshold (example: > 5 errors in 5 minutes)
5. Configure notifications (SNS/email)

---

## Observability Best Practices

- Always use structured logs
- Include correlation IDs
- Emit metrics for business events
- Monitor error rates
- Create alerts for abnormal behavior
- Avoid logging sensitive data
- Use dashboards for visualization

---

## Commit Message

```
feat: add structured logging and custom metrics with CloudWatch
```

---

## License

Educational use only.
