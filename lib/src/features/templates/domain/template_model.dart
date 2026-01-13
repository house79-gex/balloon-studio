/// Design template
class DesignTemplate {
  final String id;
  final String name;
  final String description;
  final String thumbnailUrl;
  final List<TemplateElement> elements;
  final bool isProOnly;
  
  const DesignTemplate({
    required this.id,
    required this.name,
    required this.description,
    required this.thumbnailUrl,
    required this.elements,
    this.isProOnly = false,
  });
}

/// Element in a template
class TemplateElement {
  final String type;
  final int quantity;
  final Map<String, dynamic> specifications;
  final double positionX;
  final double positionY;
  
  const TemplateElement({
    required this.type,
    required this.quantity,
    required this.specifications,
    required this.positionX,
    required this.positionY,
  });
}

/// Base templates available in Free tier
class BaseTemplates {
  static const List<DesignTemplate> templates = [
    // 8 base templates would be defined here
  ];
}
