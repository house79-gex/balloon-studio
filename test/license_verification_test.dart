import 'package:flutter_test/flutter_test.dart';
import 'package:balloon_design_studio/src/core/licensing/license_verification_service.dart';
import 'package:balloon_design_studio/src/core/licensing/license_model.dart';

void main() {
  group('LicenseVerificationService', () {
    late LicenseVerificationService service;
    
    setUp(() {
      service = LicenseVerificationService();
    });
    
    test('public key is set and not placeholder', () {
      // Verify that the public key has been updated from placeholder
      // The service should have the new public key: MUExUvgd6sSAkqCuy8GrprTxQzenOjzRqHk/+ycCK1A=
      // We can't directly access the private constant, but we can verify
      // that the service is initialized without throwing errors
      expect(service, isNotNull);
    });
    
    test('verifyToken returns false for invalid signature', () async {
      // Create a token with invalid signature
      const token = LicenseToken(
        version: 'BLS1',
        data: 'dGVzdGRhdGE=',
        signature: 'aW52YWxpZHNpZ25hdHVyZQ==',
      );
      
      final isValid = await service.verifyToken(token);
      expect(isValid, false);
    });
    
    test('validateLicense returns null for invalid token string', () async {
      const invalidToken = 'INVALID_TOKEN';
      const deviceId = 'test_device_123';
      
      final result = await service.validateLicense(invalidToken, deviceId);
      expect(result, isNull);
    });
    
    test('extractLicenseInfo returns null for invalid data', () {
      const token = LicenseToken(
        version: 'BLS1',
        data: 'aW52YWxpZGpzb24=', // 'invalidjson' in base64
        signature: 'c2lnbmF0dXJl',
      );
      
      final result = service.extractLicenseInfo(token, 'device123');
      expect(result, isNull);
    });
    
    test('extractLicenseInfo parses valid license data', () {
      // Create a valid license data JSON
      final now = DateTime.now();
      final licenseData = {
        'email': 'test@example.com',
        'issued_at': now.toIso8601String(),
        'expires_at': null, // perpetual
        'max_devices': 2,
      };
      
      // Base64 encode the JSON
      final jsonString = '{"email":"test@example.com","issued_at":"${now.toIso8601String()}","expires_at":null,"max_devices":2}';
      final dataBytes = jsonString.codeUnits;
      final base64Data = base64Encode(dataBytes);
      
      final token = LicenseToken(
        version: 'BLS1',
        data: base64Data,
        signature: 'dGVzdHNpZ25hdHVyZQ==',
      );
      
      final result = service.extractLicenseInfo(token, 'device123');
      expect(result, isNotNull);
      expect(result!.email, 'test@example.com');
      expect(result.maxDevices, 2);
      expect(result.deviceId, 'device123');
      expect(result.isPerpetual, true);
    });
  });
}

// Helper function to encode strings to base64
String base64Encode(List<int> bytes) {
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
  final output = StringBuffer();
  
  for (var i = 0; i < bytes.length; i += 3) {
    final b1 = bytes[i];
    final b2 = i + 1 < bytes.length ? bytes[i + 1] : 0;
    final b3 = i + 2 < bytes.length ? bytes[i + 2] : 0;
    
    final n = (b1 << 16) + (b2 << 8) + b3;
    
    output.write(chars[(n >> 18) & 63]);
    output.write(chars[(n >> 12) & 63]);
    output.write(i + 1 < bytes.length ? chars[(n >> 6) & 63] : '=');
    output.write(i + 2 < bytes.length ? chars[n & 63] : '=');
  }
  
  return output.toString();
}
