# Balloon Design Studio

A professional balloon art design application for tablets and phones.

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

### Public Key Configuration

The Ed25519 public key for license validation is stored in:
```
lib/src/core/licensing/license_verification_service.dart
```

**To change the public key:**
1. Open `lib/src/core/licensing/license_verification_service.dart`
2. Locate the `_publicKeyBase64` constant (around line 10)
3. Replace the base64-encoded key string with your new Ed25519 public key
4. Rebuild the application

Current key: `MUExUvgd6sSAkqCuy8GrprTxQzenOjzRqHk/+ycCK1A=`

## Templates

The application includes 8 base templates available in the Free tier:

- **Classic Balloon Arch** (concrete implementation) - A traditional balloon arch with 4 element types and realistic specifications
- 7 additional template stubs (to be implemented)

Templates are defined in:
```
lib/src/features/templates/domain/template_model.dart
```

The Classic Balloon Arch template includes:
- 80x 11" white balloons (Qualatex standard)
- 60x 11" gold chrome balloons (Qualatex)
- 40x 11" rose gold chrome balloons (Qualatex)
- 30x 5" ivory balloons (Qualatex standard)

## PDF Export

The application supports two PDF export types with different capabilities based on license tier:

### Free Tier
- **Simplified PDF Export**: ✅ Available
  - Concise project summary
  - Project name, date, and notes
  - Minimal BOM (Bill of Materials) with item name, quantity, and total
  - Basic pricing summary (total, deposit, balance)
  
- **Professional PDF Export**: ❌ Blocked
  - If Free tier attempts to access Professional export, the system falls back to Simplified export with a watermark

### Pro Tier
- **Simplified PDF Export**: ✅ Available
  - Same as Free tier, no watermark
  
- **Professional PDF Export**: ✅ Available
  - Full professional layout with header and branding
  - Complete project information
  - Detailed client information section
  - Comprehensive BOM with brand, color, size, unit price
  - Advanced quote section with tax calculations
  - Payment terms and additional notes (for advanced quotes)
  - Validity date information

### Watermark Protection
If a Free tier user somehow accesses the Professional PDF export path, a watermark is automatically applied:
- **Watermark text**: "Versione gratuita"
- **Position**: Diagonal overlay
- **Opacity**: 20% grey

The PDF implementation is located in:
```
lib/src/features/pdf_export/infrastructure/pdf_export_service_impl.dart
```

Image export functionality is gated to Pro tier only and currently remains as a placeholder.

## Android Configuration

- **Package Name**: com.giuseppepaggiolu.ballondesign.studio
- **App Name**: Balloon Design Studio
- **Min SDK**: 21
- **Target SDK**: 34

## iOS Configuration

- **Bundle ID**: com.giuseppepaggiolu.ballondesign.studio
- **Display Name**: Balloon Design Studio
- **Min iOS Version**: 12.0
