import 'package:flutter/foundation.dart';

import '../repositories/lambda_repository.dart';

class HomeViewModel extends ChangeNotifier {
  final LambdaRepository _lambdaRepository;

  HomeViewModel(this._lambdaRepository);

  /// variables
  String _message = 'Tap the button to call Lambda';
  bool _isLoading = false;

  /// TODO: create new loading2 annd message2 variables
  /// create getters and implement in UI 
  /// 
  // String _message2 = '';
  // bool _isLoading2 = false;


  /// getters
  String get message => _message;
  bool get isLoading => _isLoading;

  /// methods | events
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

  /// Implement new call 
  Future<void> callLambda2() async {
    // _isLoading = true;
    // notifyListeners();

    // try {
    //   final result = await _lambdaRepository.getLambdaMessage2();
    //   _message2 = result.message;
    // } catch (error) {
    //   _message2 = 'Lambda call failed: $error';
    // } finally {
    //   _isLoading2 = false;
    //   notifyListeners();
    // }
  }
}
