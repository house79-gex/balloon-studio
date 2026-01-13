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
    // Template 1: Classic Balloon Arch (Concrete Example)
    DesignTemplate(
      id: 'classic_arch_001',
      name: 'Classic Balloon Arch',
      description: 'A traditional balloon arch design perfect for entrances and photo backdrops. Features a balanced color gradient with standard 11-inch balloons.',
      thumbnailUrl: 'placeholder://classic_arch',
      elements: [
        TemplateElement(
          type: 'balloon_11inch',
          quantity: 80,
          specifications: {
            'color': 'white',
            'size': '11inch',
            'brand': 'Qualatex',
            'finish': 'standard',
          },
          positionX: 0.0,
          positionY: 0.0,
        ),
        TemplateElement(
          type: 'balloon_11inch',
          quantity: 60,
          specifications: {
            'color': 'gold',
            'size': '11inch',
            'brand': 'Qualatex',
            'finish': 'chrome',
          },
          positionX: 0.2,
          positionY: 0.1,
        ),
        TemplateElement(
          type: 'balloon_11inch',
          quantity: 40,
          specifications: {
            'color': 'rose_gold',
            'size': '11inch',
            'brand': 'Qualatex',
            'finish': 'chrome',
          },
          positionX: 0.4,
          positionY: 0.2,
        ),
        TemplateElement(
          type: 'balloon_5inch',
          quantity: 30,
          specifications: {
            'color': 'ivory',
            'size': '5inch',
            'brand': 'Qualatex',
            'finish': 'standard',
          },
          positionX: 0.3,
          positionY: 0.15,
        ),
      ],
    ),
    // NOTE: Remaining 7 templates (Organic Garland, Column Design, Centerpiece,
    // Wall Installation, Ceiling Installation, Number/Letter Display, Bouquet
    // Arrangement) are to be implemented as full template definitions in the future.
    // The templates list currently contains only 1 concrete implementation.
  ];
}
