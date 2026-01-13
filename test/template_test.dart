import 'package:flutter_test/flutter_test.dart';
import 'package:balloon_design_studio/src/features/templates/domain/template_model.dart';

void main() {
  group('BaseTemplates', () {
    test('has at least one template', () {
      expect(BaseTemplates.templates.length, greaterThanOrEqualTo(1));
    });
    
    test('Classic Balloon Arch template is correctly defined', () {
      final classicArch = BaseTemplates.templates.firstWhere(
        (t) => t.id == 'classic_arch_001',
      );
      
      expect(classicArch.id, 'classic_arch_001');
      expect(classicArch.name, 'Classic Balloon Arch');
      expect(classicArch.description, isNotEmpty);
      expect(classicArch.elements.length, 4);
      expect(classicArch.isProOnly, false);
    });
    
    test('Classic Balloon Arch has correct element quantities', () {
      final classicArch = BaseTemplates.templates.firstWhere(
        (t) => t.id == 'classic_arch_001',
      );
      
      // Check total balloon count
      final totalBalloons = classicArch.elements.fold<int>(
        0,
        (sum, element) => sum + element.quantity,
      );
      
      expect(totalBalloons, 210); // 80 + 60 + 40 + 30
    });
    
    test('Classic Balloon Arch elements have required specifications', () {
      final classicArch = BaseTemplates.templates.firstWhere(
        (t) => t.id == 'classic_arch_001',
      );
      
      for (final element in classicArch.elements) {
        expect(element.type, isNotEmpty);
        expect(element.quantity, greaterThan(0));
        expect(element.specifications, isNotEmpty);
        expect(element.specifications['color'], isNotNull);
        expect(element.specifications['size'], isNotNull);
        expect(element.specifications['brand'], isNotNull);
      }
    });
    
    test('Template elements have valid positions', () {
      final classicArch = BaseTemplates.templates.firstWhere(
        (t) => t.id == 'classic_arch_001',
      );
      
      for (final element in classicArch.elements) {
        expect(element.positionX, greaterThanOrEqualTo(0.0));
        expect(element.positionY, greaterThanOrEqualTo(0.0));
      }
    });
  });
  
  group('TemplateElement', () {
    test('can be created with valid data', () {
      const element = TemplateElement(
        type: 'balloon_11inch',
        quantity: 10,
        specifications: {
          'color': 'white',
          'size': '11inch',
        },
        positionX: 0.5,
        positionY: 0.5,
      );
      
      expect(element.type, 'balloon_11inch');
      expect(element.quantity, 10);
      expect(element.specifications['color'], 'white');
      expect(element.positionX, 0.5);
      expect(element.positionY, 0.5);
    });
  });
}
