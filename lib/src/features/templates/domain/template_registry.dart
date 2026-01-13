import 'package:balloon_design_studio/src/features/templates/domain/template_model.dart';

/// Registry of available design templates
class TemplateRegistry {
  /// Get all available templates
  static List<DesignTemplate> getAllTemplates() {
    return [
      classicBalloonArch,
      _stubTemplate('organic_wall', 'Organic Wall'),
      _stubTemplate('column_set', 'Column Set'),
      _stubTemplate('centerpiece', 'Centerpiece'),
      _stubTemplate('garland', 'Garland'),
      _stubTemplate('bouquet', 'Bouquet'),
      _stubTemplate('entrance_display', 'Entrance Display'),
      _stubTemplate('backdrop', 'Backdrop'),
    ];
  }

  /// Sample concrete template: Classic Balloon Arch
  static const DesignTemplate classicBalloonArch = DesignTemplate(
    id: 'classic_balloon_arch',
    name: 'Classic Balloon Arch',
    description:
        'Traditional balloon arch perfect for entrances, stages, and photo backdrops. '
        'Features evenly spaced balloons in a graceful arc formation.',
    thumbnailUrl: 'placeholder://classic_arch',
    isProOnly: false,
    elements: [
      // Main arch balloons - large
      TemplateElement(
        type: 'balloon',
        quantity: 50,
        specifications: {
          'size': '11 inch',
          'color': 'Primary Color',
          'finish': 'Standard',
          'arrangement': 'arch_main',
        },
        positionX: 0.5,
        positionY: 0.5,
      ),
      // Accent balloons - medium
      TemplateElement(
        type: 'balloon',
        quantity: 25,
        specifications: {
          'size': '9 inch',
          'color': 'Accent Color',
          'finish': 'Standard',
          'arrangement': 'arch_accent',
        },
        positionX: 0.5,
        positionY: 0.5,
      ),
      // Highlight balloons - small
      TemplateElement(
        type: 'balloon',
        quantity: 15,
        specifications: {
          'size': '5 inch',
          'color': 'Highlight Color',
          'finish': 'Metallic',
          'arrangement': 'arch_highlight',
        },
        positionX: 0.5,
        positionY: 0.5,
      ),
      // Base weights
      TemplateElement(
        type: 'accessory',
        quantity: 2,
        specifications: {
          'item': 'Balloon Weight',
          'weight': '5 lbs',
          'color': 'Black',
        },
        positionX: 0.2,
        positionY: 0.9,
      ),
      // Arch frame
      TemplateElement(
        type: 'accessory',
        quantity: 1,
        specifications: {
          'item': 'Arch Frame',
          'height': '8 ft',
          'width': '6 ft',
          'material': 'PVC',
        },
        positionX: 0.5,
        positionY: 0.8,
      ),
    ],
  );

  /// Create a stub template
  static DesignTemplate _stubTemplate(String id, String name) {
    return DesignTemplate(
      id: id,
      name: name,
      description: 'Template coming soon - $name design',
      thumbnailUrl: 'placeholder://$id',
      elements: const [],
      isProOnly: false,
    );
  }

  /// Get template by ID
  static DesignTemplate? getTemplateById(String id) {
    try {
      return getAllTemplates().firstWhere((template) => template.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get free tier templates (non-Pro only)
  static List<DesignTemplate> getFreeTemplates() {
    return getAllTemplates().where((t) => !t.isProOnly).toList();
  }

  /// Get all template IDs
  static List<String> getAllTemplateIds() {
    return getAllTemplates().map((t) => t.id).toList();
  }
}
