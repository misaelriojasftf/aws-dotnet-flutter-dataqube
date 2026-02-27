import '../models/lambda_response.dart';
import '../services/lambda_service.dart';

class LambdaRepository {
  final LambdaService _lambdaService;

  const LambdaRepository(this._lambdaService);

  Future<LambdaResponse> getLambdaMessage() async {
    final rawBody = await _lambdaService.invokeHelloLambda();
    return LambdaResponse.fromRaw(rawBody);
  }

  /// TODO: Add one more method 
  /// 
}
