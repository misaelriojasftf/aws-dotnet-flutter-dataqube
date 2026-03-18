import 'package:amplify_flutter/amplify_flutter.dart';

import '../aws_constants.dart';
import '../models/create_stock_adjustment_request.dart';

class LambdaService {
  Future<String> invokeHelloLambda() async {
    final response = await Amplify.API.get(
      AwsConstants.lambdaPath,
      apiName: AwsConstants.lambdaApiName,
    ).response;

    return response.decodeBody();
  }

  Future<String> getAdjustmentsByStore({
    required String storeId,
    int limit = 20,
  }) async {
    final response = await Amplify.API.get(
      AwsConstants.adjustmentsByStorePath(storeId),
      apiName: AwsConstants.lambdaApiName,
      queryParameters: {
        'limit': '$limit',
      },
    ).response;

    return response.decodeBody();
  }

  Future<void> createAdjustment(CreateStockAdjustmentRequest request) async {
    final response = await Amplify.API.post(
      AwsConstants.adjustmentsPath,
      apiName: AwsConstants.lambdaApiName,
      body: HttpPayload.json(request.toJson()),
    ).response;

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Create adjustment failed (${response.statusCode})');
    }
  }
}
