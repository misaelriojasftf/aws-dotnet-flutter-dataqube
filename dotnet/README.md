# Adjustments Lambda (.NET 8)

This folder contains an AWS Lambda function in C# (.NET 8) integrated with API Gateway HTTP API.

## Implemented behavior

- Route: `POST /adjustments`
- Validation:
  - body required
  - valid JSON required
  - `storeId` required
  - `sku` required
- Validation errors return `400` with:

```json
{
  "code": "VALIDATION",
  "message": "error message"
}
```

- Success returns `201` with:

```json
{
  "success": true
}
```

- `X-Request-ID` handling:
  - Uses request header `X-Request-ID` when present
  - Falls back to `context.AwsRequestId`
  - Always returns `X-Request-ID` in response headers
- Structured JSON log written to CloudWatch:

```json
{
  "requestId": "...",
  "storeId": "...",
  "sku": "...",
  "deltaQty": 0
}
```

## Project structure

- `src/AdjustmentsLambda/AdjustmentsLambda.csproj`
- `src/AdjustmentsLambda/Function.cs`
- `template.yaml` (SAM template)

## Prerequisites

1. AWS CLI configured (`aws configure`)
2. SAM CLI installed
3. .NET 8 SDK installed

## Deploy step-by-step

1. Go to the project folder:

```bash
cd /Users/misa/Documents/GitHub/aws-dotnet-flutter-dataqube/dotnet
```

2. Build the Lambda:

```bash
sam build
```

3. Deploy (guided first time):

```bash
sam deploy --guided
```

Use these values when prompted:
- Stack Name: `adjustments-lambda-stack`
- AWS Region: your target region (example `us-east-1`)
- Confirm changes before deploy: `Y` or `N` (your preference)
- Allow SAM CLI IAM role creation: `Y`
- Save arguments to `samconfig.toml`: `Y`

4. Get endpoint URL:

```bash
aws cloudformation describe-stacks \
  --stack-name adjustments-lambda-stack \
  --query "Stacks[0].Outputs[?OutputKey=='HttpApiUrl'].OutputValue" \
  --output text
```

5. Test success request:

```bash
curl -i -X POST "<HTTP_API_URL>" \
  -H "Content-Type: application/json" \
  -H "X-Request-ID: req-123" \
  -d '{
    "storeId": "S1",
    "sku": "SKU123",
    "deltaQty": 5,
    "reason": "Stock correction",
    "photoKey": null
  }'
```

Expected response:
- status `201`
- body `{"success":true}`
- header `X-Request-ID: req-123`

6. Test validation error (missing `sku`):

```bash
curl -i -X POST "<HTTP_API_URL>" \
  -H "Content-Type: application/json" \
  -d '{"storeId": "S1", "deltaQty": 5}'
```

Expected response:
- status `400`
- body like `{"code":"VALIDATION","message":"storeId and sku are required"}`

## CloudWatch logs

To tail logs:

```bash
sam logs -n AdjustmentsFunction --stack-name adjustments-lambda-stack --tail
```
