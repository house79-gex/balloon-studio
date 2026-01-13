# Licensing System Documentation

## Overview

The Balloon Design Studio uses a token-based licensing system with Ed25519 signature verification to enforce Free vs Pro tier entitlements.

## License Token Format

License tokens use the **BLS1** format:

```
BLS1.<base64_encoded_data>.<base64_encoded_signature>
```

### Components

1. **Version**: `BLS1` - Protocol version identifier
2. **Data**: Base64-encoded JSON payload containing license information
3. **Signature**: Ed25519 signature of the data, base64-encoded

### Data Payload

The decoded data contains:

```json
{
  "email": "user@example.com",
  "issued_at": "2026-01-13T18:00:00Z",
  "expires_at": null,  // null for perpetual licenses
  "max_devices": 2
}
```

## Entitlements

### Free Tier

- **Projects**: Maximum 5
- **Elements per Project**: Maximum 10
- **Templates**: 8 base templates
- **Pricing**: Size-based only
- **BOM**: Visible
- **Quotes**: Basic (deposit/balance)
- **PDF Export**: Simplified only
- **Image Export**: Not available
- **AI**: Disabled

### Pro Tier (Perpetual License)

- **Projects**: Unlimited
- **Elements per Project**: Unlimited
- **Templates**: 8+ templates
- **Pricing**: Brand + Color + Size
- **BOM**: Visible with advanced features
- **Quotes**: Advanced (custom terms, tax, etc.)
- **PDF Export**: Both Simplified and Professional
- **Image Export**: PNG/JPEG export enabled
- **AI**: Online assistance with fair use (10 requests/day/device)
- **Device Limit**: Maximum 2 devices

## Implementation

### License Verification Flow

1. **Token Storage**: License token stored in SharedPreferences
2. **Verification**: Ed25519 signature verification on app startup
3. **Validation**: Check expiration date (if present)
4. **Entitlements**: Load appropriate entitlements based on license status

### Code Structure

```
lib/src/core/
├── licensing/
│   ├── license_model.dart              # License data models
│   ├── license_verification_service.dart  # Ed25519 verification
│   └── license_provider.dart           # Riverpod providers
└── entitlements/
    ├── entitlements_config.dart        # Free vs Pro configuration
    └── entitlements_provider.dart      # Riverpod providers
```

## Security Considerations

### Public Key

The Ed25519 public key for verification is embedded in the app:

```dart
static const String _publicKeyBase64 = 'MUExUvgd6sSAkqCuy8GrprTxQzenOjzRqHk/+ycCK1A=';
```

This is the production public key used for verifying license token signatures.

### Token Generation

License tokens should be generated on a secure server:

1. Generate Ed25519 key pair (one-time)
2. Create license data payload
3. Sign payload with private key
4. Encode as BLS1 token
5. Distribute token to customer

### Device ID

Device IDs are generated on first app launch and stored locally. This is used to track the number of devices using a Pro license.

**Note**: In production, consider using platform-specific device identifiers or a more robust device fingerprinting system.

## Usage Examples

### Activating a License

```dart
final licenseNotifier = ref.read(licenseNotifierProvider.notifier);
final success = await licenseNotifier.activateLicense(tokenString);

if (success) {
  // License activated successfully
} else {
  // Invalid or expired license
}
```

### Checking Entitlements

```dart
final entitlements = ref.watch(entitlementsProvider);

if (entitlements.tier == EntitlementTier.pro) {
  // User has Pro features
} else {
  // User has Free features
}
```

### Feature Gating

```dart
final canCreate = ref.watch(canCreateProjectProvider(currentProjectCount));

if (canCreate) {
  // Allow project creation
} else {
  // Show upgrade prompt
}
```

## AI Fair Use

Pro tier includes AI assistance with fair use limits:

- **Limit**: 10 requests per day per device
- **Tracking**: Usage tracked locally by device ID and date
- **Reset**: Counter resets daily at midnight

### Implementation

```dart
final aiUsage = AiUsageTracker(
  deviceId: deviceId,
  date: DateTime.now(),
);

if (aiUsage.canMakeRequest()) {
  // Make AI request
  aiUsage.incrementUsage();
} else {
  // Show limit reached message
}
```

## Testing

### Mock License Tokens

For testing, you can create mock tokens without valid signatures:

```dart
const mockToken = 'BLS1.eyJlbWFpbCI6InRlc3RAZXhhbXBsZS5jb20ifQ==.bW9ja3NpZw==';
```

### Test Cases

1. Valid Pro license
2. Expired license
3. Invalid signature
4. Malformed token
5. Free tier limits
6. Pro tier unlimited access
7. AI usage tracking

## Troubleshooting

### License Not Activating

1. Check token format is correct (BLS1.data.signature)
2. Verify signature is valid
3. Check if license is expired
4. Ensure network connectivity (for online verification if implemented)

### Entitlements Not Applied

1. Restart app to reload license
2. Check SharedPreferences for stored token
3. Verify license validation succeeded

## Future Enhancements

- Online license validation
- License revocation
- Subscription licenses (time-based)
- Family/team licenses
- License transfer between devices
- Offline grace period
- License server integration
