import 'dart:convert';
import 'package:cryptography/cryptography.dart';
import 'package:balloon_design_studio/src/core/licensing/license_model.dart';

/// Service for verifying license tokens using Ed25519 signatures
class LicenseVerificationService {
  // Public key for verification (this would be the actual public key in production)
  // This is a placeholder - in production, this should be hardcoded or securely stored
  static const String _publicKeyBase64 = 'PLACEHOLDER_PUBLIC_KEY';
  
  final Ed25519 _algorithm = Ed25519();
  
  /// Verify a license token
  Future<bool> verifyToken(LicenseToken token) async {
    try {
      // Parse the data and signature
      final dataBytes = base64Decode(token.data);
      final signatureBytes = base64Decode(token.signature);
      
      // Create signature object
      final signature = Signature(
        signatureBytes,
        publicKey: SimplePublicKey(
          base64Decode(_publicKeyBase64),
          type: KeyPairType.ed25519,
        ),
      );
      
      // Verify signature
      final isValid = await _algorithm.verify(
        dataBytes,
        signature: signature,
      );
      
      return isValid;
    } catch (e) {
      return false;
    }
  }
  
  /// Extract license information from verified token
  LicenseInfo? extractLicenseInfo(LicenseToken token, String deviceId) {
    try {
      final dataBytes = base64Decode(token.data);
      final dataString = utf8.decode(dataBytes);
      final data = json.decode(dataString) as Map<String, dynamic>;
      
      return LicenseInfo(
        email: data['email'] as String,
        issuedAt: DateTime.parse(data['issued_at'] as String),
        expiresAt: data['expires_at'] != null 
            ? DateTime.parse(data['expires_at'] as String) 
            : null,
        maxDevices: data['max_devices'] as int? ?? 2,
        deviceId: deviceId,
        isValid: true,
      );
    } catch (e) {
      return null;
    }
  }
  
  /// Validate a license token and extract information
  Future<LicenseInfo?> validateLicense(String tokenString, String deviceId) async {
    final token = LicenseToken.parse(tokenString);
    if (token == null) return null;
    
    final isValid = await verifyToken(token);
    if (!isValid) return null;
    
    final info = extractLicenseInfo(token, deviceId);
    if (info == null) return null;
    
    // Check if license is expired
    if (info.isExpired) {
      return LicenseInfo(
        email: info.email,
        issuedAt: info.issuedAt,
        expiresAt: info.expiresAt,
        maxDevices: info.maxDevices,
        deviceId: deviceId,
        isValid: false,
      );
    }
    
    return info;
  }
}
