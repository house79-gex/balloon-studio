# Balloon Design Studio

A professional balloon art design application for tablets and phones.

## ⚠️ TESTING MODE ACTIVE

**License verification is currently DISABLED for testing purposes.**

The app is configured to run in **Pro mode by default** without requiring a valid license token. This allows for testing all premium features without license activation.

### To Re-enable License Verification:

1. **In `lib/src/core/entitlements/entitlements_provider.dart`:**
   - Uncomment the original license check code
   - Remove the direct return of `EntitlementsConfig.pro`

2. **In `lib/src/core/licensing/license_verification_service.dart`:**
   - Set `_testingModeBypassVerification` to `false`
   - Replace `_publicKeyBase64` with your actual Ed25519 public key
   - Uncomment the original `verifyToken` and `validateLicense` implementations
   - Remove the mock implementations

3. **Test the license system:**
   - Generate valid license tokens signed with your private key
   - Verify tokens are properly validated
   - Test expiration and device limits

---

## Features

### Free Tier
- Up to 5 projects
- Up to 10 elements per project
- 8 base templates
- Basic pricing (size only)
- BOM visibility
- Basic quotes with deposit/balance
- Simplified PDF export

### Pro Tier
- Unlimited projects and elements
- 8+ templates
- Advanced pricing (brand, color, size)
- Advanced quotes
- Professional PDF export
- Simplified PDF export
- Image export
- AI-powered design assistance (10 requests/day)
- Perpetual license (max 2 devices)

## Technology Stack

- **Framework**: Flutter 3.38.6
- **State Management**: Riverpod
- **Database**: Isar (local/offline)
- **PDF Generation**: pdf + printing packages
- **Licensing**: Ed25519 signature verification

## Project Structure

```
lib/
├── src/
│   ├── core/
│   │   ├── entitlements/     # Free vs Pro feature configuration
│   │   ├── licensing/        # License token verification (BLS1 format)
│   │   └── app.dart          # Main app widget
│   ├── features/
│   │   ├── home/             # Home screen
│   │   ├── projects/         # Project management
│   │   ├── elements/         # Element management
│   │   ├── templates/        # Design templates
│   │   ├── pricing/          # Pricing configuration
│   │   ├── bom/              # Bill of Materials
│   │   ├── quotes/           # Quote generation
│   │   ├── pdf_export/       # PDF export
│   │   └── ai/               # AI integration
│   └── shared/               # Shared utilities
└── main.dart                 # App entry point
```

## Getting Started

### Prerequisites
- Flutter SDK 3.38.6 or compatible
- Android Studio / Xcode for mobile development

### Installation

1. Install dependencies:
```bash
flutter pub get
```

2. Run code generation:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

3. Run the app:
```bash
flutter run
```

## License Format

License tokens use the BLS1 format:
```
BLS1.<base64_data>.<base64_signature>
```

The token is verified using Ed25519 signature verification.

## Android Configuration

- **Package Name**: com.giuseppepaggiolu.ballondesign.studio
- **App Name**: Balloon Design Studio
- **Min SDK**: 21
- **Target SDK**: 34

## iOS Configuration

- **Bundle ID**: com.giuseppepaggiolu.ballondesign.studio
- **Display Name**: Balloon Design Studio
- **Min iOS Version**: 12.0
