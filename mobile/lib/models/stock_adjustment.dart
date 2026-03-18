import 'dart:convert';

class StockAdjustment {
  final int id;
  final String storeId;
  final String sku;
  final int deltaQty;
  final String? reason;
  final DateTime? createdAt;

  const StockAdjustment({
    required this.id,
    required this.storeId,
    required this.sku,
    required this.deltaQty,
    required this.reason,
    required this.createdAt,
  });

  factory StockAdjustment.fromJson(Map<String, dynamic> json) {
    return StockAdjustment(
      id: (json['id'] as num?)?.toInt() ?? 0,
      storeId: json['storeId'] as String? ?? '',
      sku: json['sku'] as String? ?? '',
      deltaQty: (json['deltaQty'] as num?)?.toInt() ?? 0,
      reason: json['reason'] as String?,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? ''),
    );
  }

  static List<StockAdjustment> listFromRaw(String rawBody) {
    final decoded = jsonDecode(rawBody);
    if (decoded is! List) {
      return const [];
    }

    return decoded
        .whereType<Map>()
        .map((item) => StockAdjustment.fromJson(Map<String, dynamic>.from(item)))
        .toList(growable: false);
  }
}
