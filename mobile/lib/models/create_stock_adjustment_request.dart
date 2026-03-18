class CreateStockAdjustmentRequest {
  final String storeId;
  final String sku;
  final int deltaQty;
  final String reason;

  const CreateStockAdjustmentRequest({
    required this.storeId,
    required this.sku,
    required this.deltaQty,
    required this.reason,
  });

  Map<String, Object> toJson() {
    return {
      'storeId': storeId,
      'sku': sku,
      'deltaQty': deltaQty,
      'reason': reason,
    };
  }
}
