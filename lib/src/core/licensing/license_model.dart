/// License token format: BLS1
/// Structure: BLS1.<base64_encoded_data>.<base64_encoded_signature>
class LicenseToken {
  final String version;
  final String data;
  final String signature;
  
  const LicenseToken({
    required this.version,
    required this.data,
    required this.signature,
  });
  
  /// Parse a license token string
  static LicenseToken? parse(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;
      if (parts[0] != 'BLS1') return null;
      
      return LicenseToken(
        version: parts[0],
        data: parts[1],
        signature: parts[2],
      );
    } catch (e) {
      return null;
    }
  }
  
  /// Convert to token string
  String toTokenString() {
    return '$version.$data.$signature';
  }
  
  @override
  String toString() => toTokenString();
}

/// License information extracted from token
class LicenseInfo {
  final String email;
  final DateTime issuedAt;
  final DateTime? expiresAt;
  final int maxDevices;
  final String deviceId;
  final bool isValid;
  
  const LicenseInfo({
    required this.email,
    required this.issuedAt,
    this.expiresAt,
    required this.maxDevices,
    required this.deviceId,
    required this.isValid,
  });
  
  bool get isPerpetual => expiresAt == null;
  
  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }
}
