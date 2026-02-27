import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

import '../aws_constants.dart';

class AmplifyService {
  bool _isConfigured = false;

  Future<void> configure() async {
    if (_isConfigured) {
      return;
    }

    try {
      await Amplify.addPlugin(AmplifyAPI());
      await Amplify.configure(AwsConstants.amplifyConfig);
      _isConfigured = true;
    } on AmplifyAlreadyConfiguredException {
      _isConfigured = true;
    }
  }
}
