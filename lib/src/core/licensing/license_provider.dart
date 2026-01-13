import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:balloon_design_studio/src/core/licensing/license_model.dart';
import 'package:balloon_design_studio/src/core/licensing/license_verification_service.dart';

/// Provider for license verification service
final licenseVerificationServiceProvider = Provider<LicenseVerificationService>((ref) {
  return LicenseVerificationService();
});

/// Provider for device ID (would be generated/stored on first run)
final deviceIdProvider = FutureProvider<String>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  String? deviceId = prefs.getString('device_id');
  
  if (deviceId == null) {
    // Generate a new device ID (simplified - in production use a better method)
    deviceId = DateTime.now().millisecondsSinceEpoch.toString();
    await prefs.setString('device_id', deviceId);
  }
  
  return deviceId;
});

/// Provider for stored license token
final storedLicenseTokenProvider = FutureProvider<String?>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('license_token');
});

/// Provider for current license information
final licenseProvider = FutureProvider<LicenseInfo?>((ref) async {
  final tokenString = await ref.watch(storedLicenseTokenProvider.future);
  
  if (tokenString == null) {
    return null;
  }
  
  final deviceId = await ref.watch(deviceIdProvider.future);
  final verificationService = ref.watch(licenseVerificationServiceProvider);
  
  return await verificationService.validateLicense(tokenString, deviceId);
});

/// Notifier for managing license state
class LicenseNotifier extends StateNotifier<AsyncValue<LicenseInfo?>> {
  final LicenseVerificationService _verificationService;
  final String _deviceId;
  
  LicenseNotifier(this._verificationService, this._deviceId) 
      : super(const AsyncValue.loading());
  
  /// Activate a license with a token
  Future<bool> activateLicense(String tokenString) async {
    state = const AsyncValue.loading();
    
    try {
      final licenseInfo = await _verificationService.validateLicense(
        tokenString,
        _deviceId,
      );
      
      if (licenseInfo != null && licenseInfo.isValid) {
        // Store the license token
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('license_token', tokenString);
        
        state = AsyncValue.data(licenseInfo);
        return true;
      } else {
        state = const AsyncValue.data(null);
        return false;
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return false;
    }
  }
  
  /// Deactivate the current license
  Future<void> deactivateLicense() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('license_token');
    state = const AsyncValue.data(null);
  }
  
  /// Load the current license
  Future<void> loadLicense() async {
    state = const AsyncValue.loading();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final tokenString = prefs.getString('license_token');
      
      if (tokenString == null) {
        state = const AsyncValue.data(null);
        return;
      }
      
      final licenseInfo = await _verificationService.validateLicense(
        tokenString,
        _deviceId,
      );
      
      state = AsyncValue.data(licenseInfo);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
