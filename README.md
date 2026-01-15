# Balloon Design Studio

A professional balloon art design application for tablets and phones.

## 🇮🇹 Language / Lingua

**This app is Italian-only** / **Questa app è solo in italiano**

The application has been localized to Italian. All user-facing text, menus, and messages are in Italian.

### Localization Configuration

- **Framework**: Flutter's built-in localization (flutter_gen/gen_l10n)
- **Dependencies**: 
  - `intl: ^0.20.2` (compatible with Flutter SDK's flutter_localizations)
  - `flutter_localizations` (from Flutter SDK)
- **Configuration**: 
  - `l10n.yaml` defines ARB file location and output settings using standard Flutter localization generation
  - `lib/l10n/app_it.arb` contains all Italian translations
  - `pubspec.yaml` has `generate: true` to enable code generation
- **Generated Code**: `flutter gen-l10n` creates `AppLocalizations` class in `flutter_gen/gen_l10n/`
- **Usage**: Import `package:flutter_gen/gen_l10n/app_localizations.dart` and use `AppLocalizations.of(context)`

The app is configured to support only Italian locale (`it`), with no English fallback. The structure is extensible for adding more languages in the future by adding additional ARB files (e.g., `app_en.arb`).

**Note**: The `synthetic-package` flag has been removed from `l10n.yaml` as it's deprecated in recent Flutter SDK versions. Localization files are generated in the standard `flutter_gen/gen_l10n/` directory.

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

- **Framework**: Flutter 3.38.6+ (Dart SDK 3.7.0+)
- **State Management**: Riverpod 2.x (flutter_riverpod ^2.4.0, riverpod_annotation ^2.3.0)
- **Database**: Isar 3.1.0 (local/offline, compatible with source_gen 1.x)
- **PDF Generation**: pdf + printing packages
- **Licensing**: Ed25519 signature verification
- **Build Tools**: AGP 8.1.1, Gradle 8.7, Kotlin 1.9.22, build_runner ^2.4.x

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
- Flutter SDK 3.38.6 or compatible (Dart SDK 3.7.0+, Flutter 3.38.6 uses Dart SDK 3.10.7)
- Android Studio / Xcode for mobile development

### Installation

1. Install dependencies:
```bash
flutter pub get
```

2. Generate localization files:
```bash
flutter gen-l10n
```

3. Run code generation (generates *.g.dart files for Isar models and Riverpod providers):
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

   For continuous generation during development, use:
```bash
flutter pub run build_runner watch --delete-conflicting-outputs
```

4. Run the app:
```bash
flutter run
```

### Development

#### Code Generation
This project uses code generation for:
- **Isar database models** (*.g.dart files)
- **Riverpod providers** (when using @riverpod annotations)

Always run code generation after:
- Modifying Isar model classes
- Adding/updating @riverpod annotated providers
- Pulling changes that affect generated code

#### Linting and Formatting
```bash
# Run static analysis
flutter analyze

# Format code
dart format .
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
- **Compile SDK**: 36

### Android Build Notes
- AGP 8.1.1 and Kotlin 1.9.22 are maintained for compatibility with isar_flutter_libs 3.1.x
- Namespace shim for isar_flutter_libs applied in android/build.gradle to handle missing namespace declaration
- Required Android resources (styles, launcher icons, launch background) are included

## iOS Configuration

- **Bundle ID**: com.giuseppepaggiolu.ballondesign.studio
- **Display Name**: Balloon Design Studio
- **Min iOS Version**: 12.0
