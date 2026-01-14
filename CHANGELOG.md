# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased] - 2026-01-14

### Changed
- **Build Compatibility Restoration:**
  - Verified Riverpod 2.x configuration (flutter_riverpod ^2.4.0, riverpod_annotation ^2.3.0, riverpod_generator ^2.4.0)
  - Confirmed build_runner ^2.4.13 compatibility with Isar 3.1.0
  - Added repositories to buildscript in android/build.gradle for proper AGP resolution
  - Updated documentation to reflect actual dependency versions
  
- **Android Build Configuration:**
  - AGP: 8.1.1 (compatible with isar_flutter_libs 3.1.x lacking namespace)
  - Gradle Wrapper: 8.7
  - Kotlin: 1.9.22
  - Ensured repositories (google(), mavenCentral(), gradlePluginPortal()) are declared in both pluginManagement and buildscript

### Rationale
- **Riverpod 2.x**: Maintained for compatibility with Isar 3.1.0 and source_gen 1.x
  - Isar 3.1.0 requires source_gen ^1.x which constrains build_runner to ~2.4.x
  - Riverpod 2.x works well with build_runner 2.4.x
  - Riverpod 3.x/4.x requires newer build tooling not compatible with current Isar version
  
- **AGP 8.1.1**: Required for isar_flutter_libs 3.1.x compatibility
  - isar_flutter_libs 3.1.x does not declare Android namespace
  - AGP 8.1.1 does not enforce namespace requirement (AGP 8.5+ does)
  - Maintains compatibility with current Gradle and Kotlin versions

### Compatibility
- Flutter: 3.38.6+
- Dart SDK: 3.7.0+ (Flutter 3.38.6 uses Dart SDK 3.10.7)
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

---

## [Previous] - 2026-01-13

### Note
Previous changelog entries documenting Riverpod 3.x/4.x upgrade were based on planned changes that were not implemented. The project continues to use Riverpod 2.x for compatibility with Isar 3.1.0 and the existing build toolchain.
