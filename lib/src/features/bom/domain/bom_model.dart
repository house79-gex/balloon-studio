/// Bill of Materials for a project
class BillOfMaterials {
  final int projectId;
  final String projectName;
  final List<BOMItem> items;
  final double totalCost;
  final DateTime generatedAt;
  
  const BillOfMaterials({
    required this.projectId,
    required this.projectName,
    required this.items,
    required this.totalCost,
    required this.generatedAt,
  });
}

/// Individual item in BOM
class BOMItem {
  final String name;
  final String? brand;
  final String? color;
  final String? size;
  final int quantity;
  final double unitPrice;
  final double totalPrice;
  
  const BOMItem({
    required this.name,
    this.brand,
    this.color,
    this.size,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
  });
}
