# .NET Observability Lab — Serilog + AWS CloudWatch

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

### 4. Run API

```
dotnet run
```

---

## Testing the Endpoint

### Endpoint

```
POST /stock/adjust
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