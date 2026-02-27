import 'package:flutter/foundation.dart';

import '../repositories/lambda_repository.dart';

class HomeViewModel extends ChangeNotifier {
  final LambdaRepository _lambdaRepository;

  HomeViewModel(this._lambdaRepository);

  String _message = 'Tap the button to call Lambda';
  bool _isLoading = false;

  String get message => _message;
  bool get isLoading => _isLoading;

  Future<void> callLambda() async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _lambdaRepository.getLambdaMessage();
      _message = result.message;
    } catch (error) {
      _message = 'Lambda call failed: $error';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
