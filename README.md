# Balloon Design Studio

A professional balloon art design application for tablets and phones.

## Features

### Free Tier
- Up to 5 projects
- Up to 10 elements per project
- 8 base templates (including "Classic Balloon Arch" sample)
- Basic pricing (size only)
- BOM visibility
- Basic quotes with deposit/balance
- **Simplified PDF export only** (with watermark safeguard)

### Pro Tier
- Unlimited projects and elements
- 8+ templates (including "Classic Balloon Arch" and others)
- Advanced pricing (brand, color, size)
- Advanced quotes
- **Professional PDF export** (full-featured with branding)
- **Simplified PDF export** (both formats available)
- Image export (placeholder)
- AI-powered design assistance (10 requests/day, placeholder)
- Perpetual license (max 2 devices)

### PDF Export Behavior

**Free Tier:**
- ✅ Simplified PDF export available
- ❌ Professional PDF export blocked/gated
- 🔒 Watermark: "Versione gratuita" applied as safeguard

**Pro Tier:**
- ✅ Professional PDF export (detailed layout with header, client info, BOM, preventivo sections)
- ✅ Simplified PDF export (concise summary with minimal BOM)
- No watermarks

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
│   │   ├── licensing/        # License token verification (BLS1 format, Ed25519 public key)
│   │   └── app.dart          # Main app widget
│   ├── features/
│   │   ├── home/             # Home screen
│   │   ├── projects/         # Project management
│   │   ├── elements/         # Element management
│   │   ├── templates/        # Design templates (includes template_registry.dart with sample)
│   │   ├── pricing/          # Pricing configuration
│   │   ├── bom/              # Bill of Materials
│   │   ├── quotes/           # Quote generation
│   │   ├── pdf_export/       # PDF export (professional & simplified layouts)
│   │   └── ai/               # AI integration (placeholder)
│   └── shared/               # Shared utilities
└── main.dart                 # App entry point

### Templates

The app includes 8 base templates accessible in the Free tier:
1. **Classic Balloon Arch** - Full sample template with realistic parameters
   - 50 large balloons (11 inch)
   - 25 accent balloons (9 inch)
   - 15 highlight balloons (5 inch, metallic)
   - Arch frame and base weights
2. Organic Wall - Stub (coming soon)
3. Column Set - Stub (coming soon)
4. Centerpiece - Stub (coming soon)
5. Garland - Stub (coming soon)
6. Bouquet - Stub (coming soon)
7. Entrance Display - Stub (coming soon)
8. Backdrop - Stub (coming soon)

All templates are defined in `lib/src/features/templates/domain/template_registry.dart`.
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

### Public Key Configuration

The Ed25519 public key for license validation is hardcoded in:
- **Location**: `lib/src/core/licensing/license_verification_service.dart`
- **Current Key**: `MUExUvgd6sSAkqCuy8GrprTxQzenOjzRqHk/+ycCK1A=`

**To update the public key:**
1. Open `lib/src/core/licensing/license_verification_service.dart`
2. Locate the `_publicKeyBase64` constant
3. Replace the base64 string with your new Ed25519 public key
4. The key must be a valid Ed25519 public key in base64 format (32 bytes encoded)

## Android Configuration

- **Package Name**: com.giuseppepaggiolu.ballondesign.studio
- **App Name**: Balloon Design Studio
- **Min SDK**: 21
- **Target SDK**: 34

## iOS Configuration

- **Bundle ID**: com.giuseppepaggiolu.ballondesign.studio
- **Display Name**: Balloon Design Studio
- **Min iOS Version**: 12.0
