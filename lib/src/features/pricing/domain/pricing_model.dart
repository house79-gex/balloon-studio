import 'package:isar/isar.dart';

part 'pricing_model.g.dart';

/// Pricing entry - listino prezzi
@collection
class PricingEntry {
  Id id = Isar.autoIncrement;
  
  // Brand (only for Pro)
  String? brand;
  
  // Color (only for Pro)
  String? color;
  
  // Size (available for all)
  @Index()
  late String size;
  
  late double unitPrice;
  
  late DateTime createdAt;
  late DateTime updatedAt;
  
  PricingEntry();
}

/// Pricing service interface
abstract class PricingService {
  /// Get price for item based on specifications
  /// Free tier: only size-based pricing
  /// Pro tier: brand + color + size pricing
  Future<double> getPrice({
    String? brand,
    String? color,
    required String size,
    required bool isProUser,
  });
  
  /// Add or update pricing entry
  Future<void> upsertPricing(PricingEntry entry);
  
  /// Get all pricing entries
  Future<List<PricingEntry>> getAllPricing();
}
