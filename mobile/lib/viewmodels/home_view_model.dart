import 'package:flutter/foundation.dart';

import '../models/create_stock_adjustment_request.dart';
import '../models/stock_adjustment.dart';
import '../repositories/lambda_repository.dart';

class HomeViewModel extends ChangeNotifier {
  final LambdaRepository _lambdaRepository;

  HomeViewModel(this._lambdaRepository);

  static const int _defaultLimit = 20;

  List<StockAdjustment> _adjustments = const [];
  String _selectedStoreId = 'store-3';
  String? _searchError;
  String? _creationError;
  bool _isSearching = false;
  bool _isCreating = false;

  List<StockAdjustment> get adjustments => _adjustments;
  String get selectedStoreId => _selectedStoreId;
  String? get searchError => _searchError;
  String? get creationError => _creationError;
  bool get isSearching => _isSearching;
  bool get isCreating => _isCreating;

  Future<void> searchAdjustments(
    String storeId, {
    bool showLoader = true,
  }) async {
    final trimmedStoreId = storeId.trim();
    if (trimmedStoreId.isEmpty) {
      _isSearching = false;
      _searchError = 'Enter a store ID to search.';
      _adjustments = const [];
      notifyListeners();
      return;
    }

    _selectedStoreId = trimmedStoreId;
    _searchError = null;
    _creationError = null;

    if (showLoader) {
      _isSearching = true;
      notifyListeners();
    }

    try {
      _adjustments = await _lambdaRepository.getAdjustmentsByStore(
        storeId: trimmedStoreId,
        limit: _defaultLimit,
      );
    } catch (error) {
      _adjustments = const [];
      _searchError = 'Could not load adjustments: $error';
    } finally {
      _isSearching = false;
      notifyListeners();
    }
  }

  Future<bool> createAdjustment(CreateStockAdjustmentRequest request) async {
    _creationError = null;
    _isCreating = true;
    notifyListeners();

    try {
      await _lambdaRepository.createAdjustment(request);
      await searchAdjustments(request.storeId, showLoader: false);
      return true;
    } catch (error) {
      _creationError = 'Could not create adjustment: $error';
      notifyListeners();
      return false;
    } finally {
      _isCreating = false;
      notifyListeners();
    }
  }
}
