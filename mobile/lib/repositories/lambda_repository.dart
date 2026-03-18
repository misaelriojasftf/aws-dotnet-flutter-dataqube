import '../models/create_stock_adjustment_request.dart';
import '../models/lambda_response.dart';
import '../models/stock_adjustment.dart';
import '../services/lambda_service.dart';

class LambdaRepository {
  final LambdaService _lambdaService;

  const LambdaRepository(this._lambdaService);

  Future<LambdaResponse> getLambdaMessage() async {
    final rawBody = await _lambdaService.invokeHelloLambda();
    return LambdaResponse.fromRaw(rawBody);
  }

  Future<List<StockAdjustment>> getAdjustmentsByStore({
    required String storeId,
    int limit = 20,
  }) async {
    final rawBody = await _lambdaService.getAdjustmentsByStore(
      storeId: storeId,
      limit: limit,
    );
    return StockAdjustment.listFromRaw(rawBody);
  }

  Future<void> createAdjustment(CreateStockAdjustmentRequest request) {
    return _lambdaService.createAdjustment(request);
  }
}
