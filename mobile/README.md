# DataQube Mobile

Flutter mobile client for the stock adjustments demo.

## What Was Added

The mobile app was updated to consume the two .NET-backed REST endpoints exposed through API Gateway:

- `GET /stores/{storeId}/adjustments?limit=20`
- `POST /adjustments`

These endpoints are currently wired in the Flutter app through Amplify REST API configuration and a small `provider`-based flow.

## Endpoints

### Get adjustments by store

Fetches the latest stock adjustments for a store.

```bash
curl -s "https://at5tdtdik0.execute-api.us-east-2.amazonaws.com/stores/store-3/adjustments?limit=20"
```

Path pattern:

```text
GET /stores/{storeId}/adjustments?limit=20
```

### Create adjustment

Creates a new stock adjustment entry.

```bash
curl -s -X POST "https://at5tdtdik0.execute-api.us-east-2.amazonaws.com/adjustments" \
  -H "Content-Type: application/json" \
  -d '{"storeId":"store-3","sku":"SKU-1990","deltaQty":101,"reason":"new"}'
```

Path pattern:

```text
POST /adjustments
```

Expected request body:

```json
{
  "storeId": "store-3",
  "sku": "SKU-1990",
  "deltaQty": 101,
  "reason": "new"
}
```

## Flutter Additions

The mobile code now includes:

- Amplify REST configuration pointing to the deployed API Gateway domain
- Service methods for loading adjustments and creating adjustments
- Repository methods that map raw API responses into Flutter models
- `provider`-managed state for search, create, loading, and error handling
- A search input to load adjustments by store ID
- A list view showing the returned adjustments
- A floating action button with an add icon
- A bottom sheet form for creating a new adjustment
- Seamless loading indicators in the search UI and in the create button

## Project Structure

The implementation follows the existing project structure:

- [lib/services/lambda_service.dart](/Users/misa/Documents/GitHub/aws-dotnet-flutter-dataqube/mobile/lib/services/lambda_service.dart)
- [lib/repositories/lambda_repository.dart](/Users/misa/Documents/GitHub/aws-dotnet-flutter-dataqube/mobile/lib/repositories/lambda_repository.dart)
- [lib/viewmodels/home_view_model.dart](/Users/misa/Documents/GitHub/aws-dotnet-flutter-dataqube/mobile/lib/viewmodels/home_view_model.dart)
- [lib/views/home_view.dart](/Users/misa/Documents/GitHub/aws-dotnet-flutter-dataqube/mobile/lib/views/home_view.dart)
- [lib/models/stock_adjustment.dart](/Users/misa/Documents/GitHub/aws-dotnet-flutter-dataqube/mobile/lib/models/stock_adjustment.dart)
- [lib/models/create_stock_adjustment_request.dart](/Users/misa/Documents/GitHub/aws-dotnet-flutter-dataqube/mobile/lib/models/create_stock_adjustment_request.dart)
- [lib/aws_constants.dart](/Users/misa/Documents/GitHub/aws-dotnet-flutter-dataqube/mobile/lib/aws_constants.dart)

## Hardcoded API Domain

Right now the API domain is hardcoded in:

- [lib/aws_constants.dart](/Users/misa/Documents/GitHub/aws-dotnet-flutter-dataqube/mobile/lib/aws_constants.dart)

Current configured endpoint:

```text
https://at5tdtdik0.execute-api.us-east-2.amazonaws.com
```

## TODO

- Remove the hardcoded API domain from `lib/aws_constants.dart`
- Let users configure their own API Gateway endpoint and AWS region
- Replace the current embedded Amplify REST config with project-specific values

## Running The App

1. Install Flutter dependencies.
2. Update the API domain and region if you are using your own backend.
3. Run the Flutter app on your simulator or device.

## Notes

- The app keeps using `provider` as requested.
- Searching is intentionally simple and is done through a store ID input.
- Creation is handled from a floating action button that opens a bottom sheet.
