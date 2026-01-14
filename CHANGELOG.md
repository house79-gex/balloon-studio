# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased] - 2026-01-13

### Changed
- **Major Dependencies Upgrade:**
  - Upgraded Riverpod from 2.x to 3.x/4.x:
    - `flutter_riverpod`: ^2.4.0 → ^3.1.0
    - `riverpod_annotation`: ^2.3.0 → ^4.0.0
    - `riverpod_generator`: ^2.3.0 → ^4.0.0
  - Upgraded `build_runner`: ^2.4.0 → ^2.10.0
  - Upgraded `flutter_lints`: ^3.0.0 → ^6.0.0
  - Upgraded `intl`: ^0.18.0 → ^0.20.0
  - Updated Dart SDK constraint: `>=3.0.0 <4.0.0` → `>=3.7.0 <4.0.0`
  
- **Removed Dependencies:**
  - Removed `dependency_overrides` for `analyzer` and `_fe_analyzer_shared` (no longer needed)

- **Build Tooling:**
  - Android Gradle Plugin (AGP): 8.5.0 (verified)
  - Gradle Wrapper: 8.7 (verified)
  - Kotlin: 1.9.22 (verified)
  - Compatible with Flutter 3.38.6 (Dart SDK 3.10.7)

### Migration Notes

#### Riverpod 3.x/4.x Migration
- Existing code using `Provider` and `FutureProvider` continues to work without changes
- `StateNotifier` is now considered legacy in Riverpod 3.x but remains available
- For new code, consider using the code generation approach with `@riverpod` annotations
- To regenerate provider code after updates:
  ```bash
  flutter pub run build_runner build --delete-conflicting-outputs
  ```

#### flutter_lints 6.0
- New lint rules enforce stricter analysis standards
- May require minor code style adjustments for new warnings

#### intl 0.20.x
- Full compatibility with Dart 3.x features
- No API changes affecting this project

### Compatibility
- Flutter: 3.38.6+
- Dart SDK: 3.10.7+
- Android: Min SDK 21, Target SDK 34, Compile SDK 34
- iOS: Min version 12.0

### Build & Test Commands
```bash
# Install dependencies
flutter pub get

# Run code generation (regenerate *.g.dart files)
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode for continuous generation during development
flutter pub run build_runner watch --delete-conflicting-outputs

# Run static analysis
flutter analyze

# Format code
dart format .

# Run tests
flutter test
```
