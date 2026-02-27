import 'package:amplify_flutter/amplify_flutter.dart';

import '../aws_constants.dart';

class LambdaService {
  Future<String> invokeHelloLambda() async {
    final response = await Amplify.API.get(
      AwsConstants.lambdaPath,
      apiName: AwsConstants.lambdaApiName,
    ).response;

    return response.decodeBody();
  }
}
