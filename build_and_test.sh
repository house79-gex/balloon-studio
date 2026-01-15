#!/bin/bash
# Build and validation script for Balloon Design Studio
# This script should be run after Flutter SDK is properly installed

set -e  # Exit on error

echo "========================================"
echo "Balloon Design Studio - Build & Test"
echo "========================================"
echo ""

# Check Flutter is available
if ! command -v flutter &> /dev/null; then
    echo "❌ Error: Flutter SDK not found"
    echo "Please install Flutter SDK and ensure it's in your PATH"
    exit 1
fi

echo "✅ Flutter SDK found"
flutter --version
echo ""

# Navigate to project directory
cd "$(dirname "$0")"

echo "========================================"
echo "Step 1: Installing Dependencies"
echo "========================================"
flutter pub get
echo ""

echo "========================================"
echo "Step 2: Generating Localization Files"
echo "========================================"
flutter gen-l10n
echo ""

echo "========================================"
echo "Step 3: Running Build Runner"
echo "========================================"
flutter pub run build_runner build --delete-conflicting-outputs
echo ""

echo "========================================"
echo "Step 4: Running Static Analysis"
echo "========================================"
flutter analyze
echo ""

echo "========================================"
echo "Step 5: Running Tests"
echo "========================================"
flutter test
echo ""

echo "========================================"
echo "Step 6: Building Debug APK"
echo "========================================"
flutter build apk --debug
echo ""

echo "========================================"
echo "✅ Build Completed Successfully!"
echo "========================================"
echo ""
echo "APK Location: build/app/outputs/flutter-apk/app-debug.apk"
echo ""
echo "Next Steps:"
echo "1. Install the APK on your Samsung S23 Ultra or Android emulator"
echo "2. Follow the manual testing checklist in VALIDATION_TESTING_PLAN.md"
echo "3. Verify all navigation and tap handlers work correctly"
echo "4. Confirm Italian localization throughout the app"
echo "5. Test on multiple screen sizes to ensure no layout overflow"
echo ""
