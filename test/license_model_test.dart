import 'package:flutter_test/flutter_test.dart';
import 'package:balloon_design_studio/src/core/licensing/license_model.dart';

void main() {
  group('LicenseToken', () {
    test('parse valid token', () {
      const tokenString = 'BLS1.dGVzdGRhdGE=.c2lnbmF0dXJl';
      final token = LicenseToken.parse(tokenString);
      
      expect(token, isNotNull);
      expect(token!.version, 'BLS1');
      expect(token.data, 'dGVzdGRhdGE=');
      expect(token.signature, 'c2lnbmF0dXJl');
    });
    
    test('parse invalid token returns null', () {
      const tokenString = 'INVALID.token';
      final token = LicenseToken.parse(tokenString);
      
      expect(token, isNull);
    });
    
    test('parse token with wrong version returns null', () {
      const tokenString = 'BLS2.dGVzdGRhdGE=.c2lnbmF0dXJl';
      final token = LicenseToken.parse(tokenString);
      
      expect(token, isNull);
    });
    
    test('toTokenString reconstructs original token', () {
      const tokenString = 'BLS1.dGVzdGRhdGE=.c2lnbmF0dXJl';
      final token = LicenseToken.parse(tokenString);
      
      expect(token!.toTokenString(), tokenString);
    });
  });
  
  group('LicenseInfo', () {
    test('isPerpetual returns true when expiresAt is null', () {
      final info = LicenseInfo(
        email: 'test@example.com',
        issuedAt: DateTime.now(),
        expiresAt: null,
        maxDevices: 2,
        deviceId: 'device123',
        isValid: true,
      );
      
      expect(info.isPerpetual, true);
      expect(info.isExpired, false);
    });
    
    test('isExpired returns true for expired license', () {
      final info = LicenseInfo(
        email: 'test@example.com',
        issuedAt: DateTime.now().subtract(const Duration(days: 365)),
        expiresAt: DateTime.now().subtract(const Duration(days: 1)),
        maxDevices: 2,
        deviceId: 'device123',
        isValid: true,
      );
      
      expect(info.isPerpetual, false);
      expect(info.isExpired, true);
    });
    
    test('isExpired returns false for valid license', () {
      final info = LicenseInfo(
        email: 'test@example.com',
        issuedAt: DateTime.now(),
        expiresAt: DateTime.now().add(const Duration(days: 365)),
        maxDevices: 2,
        deviceId: 'device123',
        isValid: true,
      );
      
      expect(info.isPerpetual, false);
      expect(info.isExpired, false);
    });
  });
}
