import 'package:flutter_test/flutter_test.dart';
import 'package:balloon_design_studio/src/core/entitlements/entitlements_config.dart';

void main() {
  group('EntitlementsConfig', () {
    test('Free tier has correct limits', () {
      const config = EntitlementsConfig.free;
      
      expect(config.tier, EntitlementTier.free);
      expect(config.maxProjects, 5);
      expect(config.maxElementsPerProject, 10);
      expect(config.baseTemplates, 8);
      expect(config.hasSimplifiedPdf, true);
      expect(config.hasProfessionalPdf, false);
      expect(config.canExportImage, false);
      expect(config.aiOnlineEnabled, false);
    });
    
    test('Pro tier has unlimited projects and elements', () {
      const config = EntitlementsConfig.pro;
      
      expect(config.tier, EntitlementTier.pro);
      expect(config.maxProjects, null);
      expect(config.maxElementsPerProject, null);
      expect(config.hasSimplifiedPdf, true);
      expect(config.hasProfessionalPdf, true);
      expect(config.canExportImage, true);
      expect(config.aiOnlineEnabled, true);
      expect(config.aiRequestsPerDay, 10);
      expect(config.maxDevices, 2);
    });
    
    test('canCreateProject works correctly for Free tier', () {
      const config = EntitlementsConfig.free;
      
      expect(config.canCreateProject(0), true);
      expect(config.canCreateProject(4), true);
      expect(config.canCreateProject(5), false);
    });
    
    test('canCreateProject always returns true for Pro tier', () {
      const config = EntitlementsConfig.pro;
      
      expect(config.canCreateProject(0), true);
      expect(config.canCreateProject(100), true);
      expect(config.canCreateProject(1000), true);
    });
    
    test('canAddElement works correctly for Free tier', () {
      const config = EntitlementsConfig.free;
      
      expect(config.canAddElement(0), true);
      expect(config.canAddElement(9), true);
      expect(config.canAddElement(10), false);
    });
    
    test('canAddElement always returns true for Pro tier', () {
      const config = EntitlementsConfig.pro;
      
      expect(config.canAddElement(0), true);
      expect(config.canAddElement(100), true);
      expect(config.canAddElement(1000), true);
    });
  });
}
