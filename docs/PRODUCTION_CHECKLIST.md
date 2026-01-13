# Production Checklist

This document lists all the items that need to be addressed before deploying the app to production.

## Critical Security Items 🔒

### 1. License Verification
- [x] **Replace Ed25519 Public Key**
  - Location: `lib/src/core/licensing/license_verification_service.dart`
  - Current: `MUExUvgd6sSAkqCuy8GrprTxQzenOjzRqHk/+ycCK1A=`
  - Action: ✓ Production Ed25519 public key has been embedded
  - Priority: **CRITICAL**

### 2. Device ID Generation
- [ ] **Implement Secure Device Identification**
  - Location: `lib/src/core/licensing/license_provider.dart`
  - Current: Uses timestamp (insecure)
  - Action: Use platform-specific device identifiers or crypto-secure random ID
  - Priority: **HIGH**
  - Options:
    - Android: Use Android ID or device fingerprint
    - iOS: Use identifierForVendor
    - Or use UUID package with secure storage

## Platform Configuration 📱

### Android

- [ ] **Update Storage Permissions**
  - Location: `android/app/src/main/AndroidManifest.xml`
  - Current: Uses deprecated WRITE/READ_EXTERNAL_STORAGE
  - Action: Migrate to scoped storage or remove if not needed
  - Priority: **MEDIUM**

- [ ] **Configure Release Signing**
  - Create keystore: `keytool -genkey -v -keystore ~/key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias key`
  - Create `android/key.properties`
  - Update `android/app/build.gradle` with signing config
  - Priority: **CRITICAL**

- [ ] **Update Application ID**
  - Verify `com.giuseppepaggiolu.ballondesign.studio` is correct
  - Ensure it matches Google Play Console
  - Priority: **HIGH**

- [ ] **Add App Icons**
  - Sizes: mdpi, hdpi, xhdpi, xxhdpi, xxxhdpi
  - Location: `android/app/src/main/res/mipmap-*/`
  - Priority: **HIGH**

- [ ] **Add Splash Screen**
  - Configure in `android/app/src/main/res/drawable/`
  - Update theme in `styles.xml`
  - Priority: **MEDIUM**

### iOS

- [ ] **Configure Signing & Capabilities**
  - Team ID and provisioning profiles
  - App ID: `com.giuseppepaggiolu.ballondesign.studio`
  - Priority: **CRITICAL**

- [ ] **Add App Icons**
  - Use Asset Catalog in Xcode
  - All required sizes for iPhone/iPad
  - Priority: **HIGH**

- [ ] **Add Launch Screen**
  - Configure in Xcode
  - Support all screen sizes
  - Priority: **MEDIUM**

- [ ] **Update Bundle Identifier**
  - Verify bundle ID matches App Store Connect
  - Priority: **HIGH**

## Code Generation 🔨

- [ ] **Run Build Runner**
  - Command: `flutter pub run build_runner build --delete-conflicting-outputs`
  - Generate `.g.dart` files for:
    - Isar database models
    - Riverpod providers (if annotations added)
  - Priority: **CRITICAL**

## Database Setup 💾

- [ ] **Initialize Isar Database**
  - Implement database initialization in main.dart
  - Register all collections (Project, Element, PricingEntry)
  - Test database operations
  - Priority: **HIGH**

- [ ] **Implement Repository Pattern**
  - Create concrete implementations for:
    - ProjectRepository
    - ElementRepository
    - PricingRepository
  - Add to providers
  - Priority: **HIGH**

## Features Implementation 🚀

### Phase 1: Core Features
- [ ] Project CRUD operations
- [ ] Element CRUD operations
- [ ] Template browser
- [ ] Basic pricing configuration

### Phase 2: Business Logic
- [ ] BOM generation logic
- [ ] Quote generation (basic & advanced)
- [ ] Price calculation engine
- [ ] License activation UI

### Phase 3: Export Features
- [ ] PDF export implementation
  - [ ] Simplified PDF (Free)
  - [ ] Professional PDF (Pro)
- [ ] Image export (Pro only)

### Phase 4: AI Integration (Pro)
- [ ] Connect to AI service
- [ ] Design suggestions
- [ ] Color combinations
- [ ] Usage tracking UI

## Quality Assurance 🧪

### Testing
- [ ] **Unit Tests**
  - [ ] Business logic coverage > 80%
  - [ ] All models tested
  - [ ] All services tested

- [ ] **Widget Tests**
  - [ ] All screens tested
  - [ ] Navigation flows tested
  - [ ] Form validation tested

- [ ] **Integration Tests**
  - [ ] End-to-end feature flows
  - [ ] Database persistence
  - [ ] License activation flow

### Code Quality
- [ ] **Run Flutter Analyze**
  - Command: `flutter analyze`
  - Fix all errors and warnings
  - Priority: **HIGH**

- [ ] **Code Formatting**
  - Command: `flutter format .`
  - Ensure consistent style
  - Priority: **MEDIUM**

- [ ] **Performance Testing**
  - Test on low-end devices
  - Check memory usage
  - Optimize heavy operations
  - Priority: **MEDIUM**

## Monitoring & Analytics 📊

- [ ] **Crash Reporting**
  - Integrate Firebase Crashlytics or Sentry
  - Test crash reporting
  - Priority: **HIGH**

- [ ] **Analytics**
  - Add Google Analytics or Firebase Analytics
  - Define key events to track
  - Priority: **MEDIUM**

- [ ] **Error Tracking**
  - Implement error logging service
  - Add error boundaries
  - Priority: **MEDIUM**

- [ ] **Performance Monitoring**
  - Add Firebase Performance or similar
  - Track critical operations
  - Priority: **LOW**

## Security Review 🔐

- [ ] **Security Audit**
  - Review all API endpoints (if any)
  - Check data storage security
  - Validate license verification
  - Priority: **HIGH**

- [ ] **Penetration Testing**
  - Test license bypass attempts
  - Test data encryption
  - Priority: **MEDIUM**

- [ ] **Dependencies Audit**
  - Check for known vulnerabilities
  - Update outdated packages
  - Priority: **HIGH**

## Legal & Compliance ⚖️

- [ ] **Privacy Policy**
  - Create privacy policy
  - Add to app and stores
  - Priority: **CRITICAL**

- [ ] **Terms of Service**
  - Create ToS document
  - Add acceptance flow
  - Priority: **HIGH**

- [ ] **License Agreement**
  - EULA for Pro licenses
  - License activation terms
  - Priority: **HIGH**

- [ ] **App Store Assets**
  - Screenshots (phone & tablet)
  - App description
  - Promotional text
  - Keywords
  - Priority: **HIGH**

## Documentation 📚

- [ ] **User Documentation**
  - User manual
  - Quick start guide
  - FAQ
  - Priority: **MEDIUM**

- [ ] **API Documentation**
  - If backend API exists
  - Document all endpoints
  - Priority: **MEDIUM**

- [ ] **Admin Documentation**
  - License generation guide
  - Support procedures
  - Priority: **MEDIUM**

## Performance Optimization ⚡

- [ ] **Image Optimization**
  - Compress all images
  - Use appropriate formats
  - Lazy loading
  - Priority: **LOW**

- [ ] **Code Optimization**
  - Remove debug code
  - Optimize build size
  - Tree shaking
  - Priority: **MEDIUM**

- [ ] **Database Optimization**
  - Add indexes to frequent queries
  - Optimize query performance
  - Priority: **MEDIUM**

## Deployment 🚀

### Pre-Launch
- [ ] **Beta Testing**
  - TestFlight (iOS)
  - Google Play Internal Testing
  - Gather feedback
  - Priority: **HIGH**

- [ ] **Localization** (if needed)
  - Add language support
  - Translate all strings
  - Test RTL languages
  - Priority: **LOW**

### Launch
- [ ] **Google Play Console Setup**
  - App listing
  - Content rating
  - Pricing & distribution
  - Priority: **CRITICAL**

- [ ] **App Store Connect Setup**
  - App information
  - Age rating
  - Pricing & availability
  - Priority: **CRITICAL**

- [ ] **Release Build**
  - Android: `flutter build appbundle --release`
  - iOS: `flutter build ios --release`
  - Test release builds
  - Priority: **CRITICAL**

### Post-Launch
- [ ] **Monitoring Setup**
  - Monitor crash reports
  - Watch analytics
  - Track reviews
  - Priority: **HIGH**

- [ ] **Support System**
  - Support email/system
  - Response procedures
  - Priority: **HIGH**

- [ ] **Update Strategy**
  - Plan regular updates
  - Bug fix process
  - Feature roadmap
  - Priority: **MEDIUM**

## License Server (Future)

If implementing online license validation:
- [ ] Backend API for license validation
- [ ] License generation system
- [ ] Device registration tracking
- [ ] License revocation capability
- [ ] Admin dashboard

## Notes

- **Priority Levels**:
  - **CRITICAL**: Must be done before any release
  - **HIGH**: Should be done before production
  - **MEDIUM**: Important but can be done post-MVP
  - **LOW**: Nice to have

- Review this checklist regularly during development
- Mark items as complete as you finish them
- Add new items as they are identified
- Update priorities as needed

## Sign-off

Before production release, ensure all CRITICAL and HIGH priority items are completed and signed off by:
- [ ] Lead Developer
- [ ] Security Reviewer
- [ ] QA Team
- [ ] Product Owner
- [ ] Legal/Compliance
