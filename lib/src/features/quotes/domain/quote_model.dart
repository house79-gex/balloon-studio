import 'package:balloon_design_studio/src/features/bom/domain/bom_model.dart';

/// Quote/Preventivo type
enum QuoteType {
  basic,      // Free tier: acconto/saldo
  advanced,   // Pro tier: advanced features
}

/// Quote model
class Quote {
  final int projectId;
  final String projectName;
  final QuoteType type;
  
  // Client information
  final String? clientName;
  final String? clientEmail;
  
  // Items
  final BillOfMaterials bom;
  
  // Pricing
  final double subtotal;
  final double taxRate;
  final double taxAmount;
  final double total;
  
  // Payment terms (basic)
  final double? depositAmount;
  final double? balanceAmount;
  
  // Advanced features (Pro only)
  final String? notes;
  final DateTime? validUntil;
  final List<String>? paymentTerms;
  
  final DateTime createdAt;
  
  const Quote({
    required this.projectId,
    required this.projectName,
    required this.type,
    this.clientName,
    this.clientEmail,
    required this.bom,
    required this.subtotal,
    this.taxRate = 0.0,
    this.taxAmount = 0.0,
    required this.total,
    this.depositAmount,
    this.balanceAmount,
    this.notes,
    this.validUntil,
    this.paymentTerms,
    required this.createdAt,
  });
  
  /// Create a basic quote (Free tier)
  factory Quote.basic({
    required int projectId,
    required String projectName,
    required BillOfMaterials bom,
    required double subtotal,
    required double depositPercent,
    String? clientName,
    String? clientEmail,
  }) {
    final depositAmount = subtotal * (depositPercent / 100);
    final balanceAmount = subtotal - depositAmount;
    
    return Quote(
      projectId: projectId,
      projectName: projectName,
      type: QuoteType.basic,
      clientName: clientName,
      clientEmail: clientEmail,
      bom: bom,
      subtotal: subtotal,
      total: subtotal,
      depositAmount: depositAmount,
      balanceAmount: balanceAmount,
      createdAt: DateTime.now(),
    );
  }
  
  /// Create an advanced quote (Pro tier)
  factory Quote.advanced({
    required int projectId,
    required String projectName,
    required BillOfMaterials bom,
    required double subtotal,
    double taxRate = 0.0,
    required double depositPercent,
    String? clientName,
    String? clientEmail,
    String? notes,
    DateTime? validUntil,
    List<String>? paymentTerms,
  }) {
    final depositAmount = subtotal * (depositPercent / 100);
    final balanceAmount = subtotal - depositAmount;
    final taxAmount = subtotal * (taxRate / 100);
    final total = subtotal + taxAmount;
    
    return Quote(
      projectId: projectId,
      projectName: projectName,
      type: QuoteType.advanced,
      clientName: clientName,
      clientEmail: clientEmail,
      bom: bom,
      subtotal: subtotal,
      taxRate: taxRate,
      taxAmount: taxAmount,
      total: total,
      depositAmount: depositAmount,
      balanceAmount: balanceAmount,
      notes: notes,
      validUntil: validUntil,
      paymentTerms: paymentTerms,
      createdAt: DateTime.now(),
    );
  }
}
