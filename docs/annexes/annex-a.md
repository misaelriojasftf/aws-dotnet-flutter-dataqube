# Anexo A: Comandos comunes

## Flutter

```bash
flutter create stockops_app
flutter pub get
flutter run
flutter test
flutter build apk --release
flutter pub run build_runner build --delete-conflicting-outputs
```

## .NET / C#

```bash
dotnet new lambda.CustomRuntime
dotnet restore
dotnet build
dotnet test
dotnet publish -c Release -o ./publish
dotnet lambda package -o function.zip
```

## AWS CLI - DynamoDB

```bash
aws dynamodb create-table \
  --table-name MyTable \
  --attribute-definitions AttributeName=id,AttributeType=S \
  --key-schema AttributeName=id,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST

aws dynamodb scan \
  --table-name MyTable

aws dynamodb query \
  --table-name MyTable \
  --key-condition-expression "id = :id" \
  --expression-attribute-values '{":id":{"S":"123"}}'
```

## AWS CLI - Lambda

```bash
aws lambda create-function \
  --function-name myfunction \
  --runtime dotnet8 \
  --role arn:aws:iam::ACCOUNT_ID:role/lambda-role \
  --handler StockOps::Handler::FunctionHandler \
  --zip-file fileb://function.zip

aws lambda invoke \
  --function-name myfunction \
  output.json

aws logs tail \
  /aws/lambda/myfunction \
  --follow
```

## AWS CLI - API Gateway

```bash
aws apigateway create-rest-api \
  --name MyAPI

aws apigateway create-resource \
  --rest-api-id API_ID \
  --parent-id PARENT_ID \
  --path-part resource

aws apigateway create-deployment \
  --rest-api-id API_ID \
  --stage-name dev
```

## AWS CLI - SecretsManager

```bash
aws secretsmanager create-secret \                                                      
  --name rds/stockops/app \
  --secret-string '{
  "username": "admin",
  "password": "StrongPassword123!",
  "host": "db-stockops.ch46cgika5uh.us-east-2.rds.amazonaws.com",
  "database": "stockops",
  "port": 3306
  }'
```

## AWS SAM

For Build
```bash
sam build

```

For Guided Deploy
```bash
sam deploy --guided
```

When template already exists
```bash
sam deploy
```


## Git commits

```bash
git add .
git commit -m "feat: add new feature"
git commit -m "fix: resolve bug"
git commit -m "docs: update README"
git push origin main
```
