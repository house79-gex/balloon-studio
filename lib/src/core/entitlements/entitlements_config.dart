/// Entitlement tier for the application
enum EntitlementTier {
  free,
  pro,
}

/// Entitlements configuration defining feature limits and capabilities
class EntitlementsConfig {
  final EntitlementTier tier;
  
  // Project limits
  final int? maxProjects;
  final int? maxElementsPerProject;
  
  // Templates
  final int baseTemplates;
  
  // Pricing features
  final bool hasBrandPricing;
  final bool hasColorPricing;
  final bool hasSizePricing;
  
  // BOM and Quote features
  final bool bomVisible;
  final bool hasBasicQuote;
  final bool hasAdvancedQuote;
  
  // PDF Export features
  final bool hasSimplifiedPdf;
  final bool hasProfessionalPdf;
  
  // Image Export
  final bool canExportImage;
  
  // AI features
  final bool aiOnlineEnabled;
  final int? aiRequestsPerDay;
  
  // License limits
  final int? maxDevices;
  
  const EntitlementsConfig({
    required this.tier,
    this.maxProjects,
    this.maxElementsPerProject,
    this.baseTemplates = 8,
    this.hasBrandPricing = false,
    this.hasColorPricing = false,
    this.hasSizePricing = true,
    this.bomVisible = true,
    this.hasBasicQuote = true,
    this.hasAdvancedQuote = false,
    this.hasSimplifiedPdf = false,
    this.hasProfessionalPdf = false,
    this.canExportImage = false,
    this.aiOnlineEnabled = false,
    this.aiRequestsPerDay,
    this.maxDevices,
  });
  
  /// Free tier entitlements
  static const EntitlementsConfig free = EntitlementsConfig(
    tier: EntitlementTier.free,
    maxProjects: 5,
    maxElementsPerProject: 10,
    baseTemplates: 8,
    hasBrandPricing: false,
    hasColorPricing: false,
    hasSizePricing: true,
    bomVisible: true,
    hasBasicQuote: true,
    hasAdvancedQuote: false,
    hasSimplifiedPdf: true,
    hasProfessionalPdf: false,
    canExportImage: false,
    aiOnlineEnabled: false,
  );
  
  /// Pro tier entitlements
  static const EntitlementsConfig pro = EntitlementsConfig(
    tier: EntitlementTier.pro,
    maxProjects: null, // unlimited
    maxElementsPerProject: null, // unlimited
    baseTemplates: 8,
    hasBrandPricing: true,
    hasColorPricing: true,
    hasSizePricing: true,
    bomVisible: true,
    hasBasicQuote: true,
    hasAdvancedQuote: true,
    hasSimplifiedPdf: true,
    hasProfessionalPdf: true,
    canExportImage: true,
    aiOnlineEnabled: true,
    aiRequestsPerDay: 10,
    maxDevices: 2, // perpetual license max 2 devices
  );
  
  bool get hasUnlimitedProjects => maxProjects == null;
  bool get hasUnlimitedElements => maxElementsPerProject == null;
  
  bool canCreateProject(int currentProjectCount) {
    if (maxProjects == null) return true;
    return currentProjectCount < maxProjects!;
  }
  
  bool canAddElement(int currentElementCount) {
    if (maxElementsPerProject == null) return true;
    return currentElementCount < maxElementsPerProject!;
  }
}
