# Build and Development Guide

## Prerequisites

- Flutter SDK 3.38.6 or compatible stable version
- Android Studio or Xcode for mobile development
- VS Code with Flutter extension (recommended)

## Setup

### 1. Install Dependencies

```bash
flutter pub get
```

### 2. Generate Code

The project uses code generation for Isar database and Riverpod. Run:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Or for continuous generation during development:

```bash
flutter pub run build_runner watch --delete-conflicting-outputs
```

### 3. Run the App

```bash
# Run on connected device
flutter run

# Run on specific device
flutter devices
flutter run -d <device_id>

# Run in release mode
flutter run --release
```

## Build

### Android

```bash
# Debug build
flutter build apk --debug

# Release build (requires signing configuration)
flutter build apk --release
flutter build appbundle --release
```

### iOS

```bash
# Debug build
flutter build ios --debug

# Release build (requires signing configuration)
flutter build ios --release
```

### Web

```bash
flutter build web
```

## Testing

### Run All Tests

```bash
flutter test
```

### Run Specific Test

```bash
flutter test test/entitlements_test.dart
```

### Run with Coverage

```bash
flutter test --coverage
```

## Code Quality

### Analyze Code

```bash
flutter analyze
```

### Format Code

```bash
flutter format lib/ test/
```

## Project Structure

```
lib/
├── main.dart                 # App entry point
└── src/
    ├── core/                 # Core functionality
    │   ├── app.dart          # Main app widget
    │   ├── entitlements/     # Feature entitlements (Free/Pro)
    │   └── licensing/        # License verification (BLS1 format)
    ├── features/             # Feature modules
    │   ├── ai/               # AI design assistance (Pro)
    │   ├── bom/              # Bill of Materials
    │   ├── elements/         # Design elements
    │   ├── home/             # Home screen
    │   ├── pdf_export/       # PDF/Image export
    │   ├── pricing/          # Pricing configuration
    │   ├── projects/         # Project management
    │   ├── quotes/           # Quote generation
    │   └── templates/        # Design templates
    └── shared/               # Shared utilities
```

## Feature Development

### Adding a New Feature

1. Create feature directory under `lib/src/features/<feature_name>/`
2. Organize into layers:
   - `domain/` - Models and interfaces
   - `data/` - Data sources and repositories
   - `presentation/` - UI screens and widgets
3. Add providers in separate provider files
4. Update routing if needed
5. Add tests

### Code Generation

When adding Isar models or Riverpod annotations:
1. Add `part '<filename>.g.dart';` directive
2. Run `flutter pub run build_runner build`

## Known Issues

### Isar Code Generation

First time running build_runner with Isar models will generate the `.g.dart` files.
If you encounter errors, ensure:
- All Isar collections have proper annotations
- Part directives are correctly specified

### Platform-Specific Issues

- **Android**: Ensure Android SDK is properly installed
- **iOS**: Requires macOS with Xcode installed
- **Web**: Some features (like local database) may not work fully on web

## Deployment

### Android

1. Configure signing in `android/key.properties`
2. Update `android/app/build.gradle` with signing config
3. Build release: `flutter build appbundle --release`
4. Upload to Google Play Console

### iOS

1. Configure signing in Xcode
2. Build release: `flutter build ios --release`
3. Archive and upload via Xcode

## Troubleshooting

### Clean Build

If you encounter build issues:

```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### Reset Everything

```bash
rm -rf build/
rm -rf .dart_tool/
flutter clean
flutter pub get
```

## License

See LICENSE file for details.
