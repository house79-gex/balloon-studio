import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:balloon_design_studio/src/core/entitlements/entitlements_config.dart';
import 'package:balloon_design_studio/src/core/licensing/license_provider.dart';

/// Provider for current entitlements based on license status
final entitlementsProvider = Provider<EntitlementsConfig>((ref) {
  final license = ref.watch(licenseProvider);
  
  return license.when(
    data: (licenseInfo) {
      if (licenseInfo != null && licenseInfo.isValid) {
        return EntitlementsConfig.pro;
      }
      return EntitlementsConfig.free;
    },
    loading: () => EntitlementsConfig.free,
    error: (_, __) => EntitlementsConfig.free,
  );
});

/// Provider to check if user can create a new project
final canCreateProjectProvider = Provider.family<bool, int>((ref, currentCount) {
  final entitlements = ref.watch(entitlementsProvider);
  return entitlements.canCreateProject(currentCount);
});

/// Provider to check if user can add a new element
final canAddElementProvider = Provider.family<bool, int>((ref, currentCount) {
  final entitlements = ref.watch(entitlementsProvider);
  return entitlements.canAddElement(currentCount);
});
