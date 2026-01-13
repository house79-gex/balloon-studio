import 'package:flutter_test/flutter_test.dart';
import 'package:balloon_design_studio/src/features/templates/domain/template_model.dart';
import 'package:balloon_design_studio/src/features/templates/domain/template_registry.dart';

void main() {
  group('TemplateRegistry', () {
    test('getAllTemplates returns 8 templates', () {
      final templates = TemplateRegistry.getAllTemplates();
      
      expect(templates.length, 8);
    });
    
    test('classicBalloonArch template has correct structure', () {
      final template = TemplateRegistry.classicBalloonArch;
      
      expect(template.id, 'classic_balloon_arch');
      expect(template.name, 'Classic Balloon Arch');
      expect(template.description, isNotEmpty);
      expect(template.isProOnly, false);
      expect(template.elements.length, 5);
    });
    
    test('classicBalloonArch has correct balloon quantities', () {
      final template = TemplateRegistry.classicBalloonArch;
      
      // Check main arch balloons
      final mainBalloons = template.elements[0];
      expect(mainBalloons.type, 'balloon');
      expect(mainBalloons.quantity, 50);
      expect(mainBalloons.specifications['size'], '11 inch');
      
      // Check accent balloons
      final accentBalloons = template.elements[1];
      expect(accentBalloons.type, 'balloon');
      expect(accentBalloons.quantity, 25);
      expect(accentBalloons.specifications['size'], '9 inch');
      
      // Check highlight balloons
      final highlightBalloons = template.elements[2];
      expect(highlightBalloons.type, 'balloon');
      expect(highlightBalloons.quantity, 15);
      expect(highlightBalloons.specifications['size'], '5 inch');
    });
    
    test('classicBalloonArch has accessories', () {
      final template = TemplateRegistry.classicBalloonArch;
      
      // Check base weights
      final weights = template.elements[3];
      expect(weights.type, 'accessory');
      expect(weights.quantity, 2);
      expect(weights.specifications['item'], 'Balloon Weight');
      
      // Check arch frame
      final frame = template.elements[4];
      expect(frame.type, 'accessory');
      expect(frame.quantity, 1);
      expect(frame.specifications['item'], 'Arch Frame');
    });
    
    test('getTemplateById returns correct template', () {
      final template = TemplateRegistry.getTemplateById('classic_balloon_arch');
      
      expect(template, isNotNull);
      expect(template!.id, 'classic_balloon_arch');
    });
    
    test('getTemplateById returns null for invalid id', () {
      final template = TemplateRegistry.getTemplateById('nonexistent');
      
      expect(template, isNull);
    });
    
    test('getFreeTemplates returns all non-Pro templates', () {
      final freeTemplates = TemplateRegistry.getFreeTemplates();
      
      expect(freeTemplates.length, 8);
      for (final template in freeTemplates) {
        expect(template.isProOnly, false);
      }
    });
    
    test('getAllTemplateIds returns 8 ids', () {
      final ids = TemplateRegistry.getAllTemplateIds();
      
      expect(ids.length, 8);
      expect(ids, contains('classic_balloon_arch'));
    });
    
    test('all templates have valid structure', () {
      final templates = TemplateRegistry.getAllTemplates();
      
      for (final template in templates) {
        expect(template.id, isNotEmpty);
        expect(template.name, isNotEmpty);
        expect(template.description, isNotEmpty);
        expect(template.thumbnailUrl, isNotEmpty);
      }
    });
  });
}
