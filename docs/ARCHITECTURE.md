# Architecture Documentation

## Overview

Balloon Design Studio follows Clean Architecture principles with feature-based organization and Riverpod for state management.

## Architecture Layers

### 1. Domain Layer
- **Location**: `lib/src/features/<feature>/domain/`
- **Purpose**: Business logic and entities
- **Contains**:
  - Models (data classes)
  - Interfaces (abstract services)
  - Business rules
- **Dependencies**: None (pure Dart)

### 2. Data Layer
- **Location**: `lib/src/features/<feature>/data/`
- **Purpose**: Data sources and repositories
- **Contains**:
  - Repository implementations
  - Data sources (local/remote)
  - Data models/DTOs
- **Dependencies**: Domain layer, third-party packages (Isar, etc.)

### 3. Presentation Layer
- **Location**: `lib/src/features/<feature>/presentation/`
- **Purpose**: UI and user interactions
- **Contains**:
  - Screens/Pages
  - Widgets
  - View models (Riverpod providers)
- **Dependencies**: Domain layer, Flutter

## Core Modules

### Licensing System
```
lib/src/core/licensing/
├── license_model.dart              # Token and license info models
├── license_verification_service.dart  # Ed25519 verification
└── license_provider.dart           # State management
```

**Responsibilities**:
- Parse BLS1 format tokens
- Verify Ed25519 signatures
- Manage license state
- Provide license information to app

### Entitlements System
```
lib/src/core/entitlements/
├── entitlements_config.dart        # Free vs Pro configuration
└── entitlements_provider.dart      # Reactive entitlements
```

**Responsibilities**:
- Define feature limits for Free/Pro
- Provide reactive access to current tier
- Gate features based on license
- Enforce business rules

## Feature Modules

### Projects Module
**Purpose**: Manage balloon design projects

**Models**:
- `Project`: Main project entity with client info, metadata
- `ProjectStatus`: Draft, InProgress, Completed, Archived

**Key Features**:
- Create/edit/delete projects
- Project metadata (client, event details)
- Project status tracking
- Element count enforcement

### Elements Module
**Purpose**: Manage design elements (balloons, structures)

**Models**:
- `Element`: Individual design element
- `ElementType`: Balloon, Column, Arch, etc.

**Key Features**:
- Add/edit/delete elements
- Element specifications (brand, color, size)
- Position in design
- Pricing per element
- Element count limits (Free: 10, Pro: unlimited)

### Templates Module
**Purpose**: Provide design templates

**Models**:
- `DesignTemplate`: Template definition
- `TemplateElement`: Element in template

**Key Features**:
- 8 base templates (Free)
- Additional templates (Pro)
- Template application to projects
- Template customization

### Pricing Module
**Purpose**: Configure pricing lists

**Models**:
- `PricingEntry`: Price by brand/color/size

**Key Features**:
- Size-based pricing (Free)
- Brand + Color + Size pricing (Pro)
- Pricing CRUD operations
- Automatic price calculation

### BOM Module
**Purpose**: Generate Bill of Materials

**Models**:
- `BillOfMaterials`: Complete BOM
- `BOMItem`: Individual line item

**Key Features**:
- Generate BOM from project
- Item aggregation
- Cost calculation
- Export capabilities

### Quotes Module
**Purpose**: Generate customer quotes

**Models**:
- `Quote`: Customer quotation
- `QuoteType`: Basic vs Advanced

**Key Features**:
- Basic quotes (Free): deposit/balance
- Advanced quotes (Pro): taxes, custom terms
- Quote generation from BOM
- Client information

### PDF Export Module
**Purpose**: Export documents to PDF

**Services**:
- `PdfExportService`: Quote/BOM/Design export
- `ImageExportService`: Design images (Pro only)

**Key Features**:
- Simplified PDF (Free)
- Professional PDF (Pro)
- Image export PNG/JPEG (Pro)
- Configurable export options

### AI Module
**Purpose**: AI-powered design assistance (Pro)

**Services**:
- `AiDesignService`: Design suggestions
- `AiUsageTracker`: Fair use tracking

**Key Features**:
- Design suggestions
- Color combinations
- Fair use limit (10/day/device)
- Usage tracking per device

## State Management

### Riverpod Providers

#### Global Providers
- `entitlementsProvider`: Current user entitlements
- `licenseProvider`: Current license information
- `deviceIdProvider`: Device identification

#### Feature Providers
Each feature module has its own providers:
- Data providers (async)
- State notifiers (mutable state)
- Computed providers (derived state)

### Provider Hierarchy
```
ProviderScope
├── deviceIdProvider
├── licenseProvider
│   └── entitlementsProvider
│       ├── canCreateProjectProvider
│       └── canAddElementProvider
└── Feature Providers...
```

## Data Persistence

### Isar Database
- **Purpose**: Local/offline data storage
- **Collections**:
  - Projects
  - Elements
  - PricingEntries

### SharedPreferences
- **Purpose**: Simple key-value storage
- **Stored Data**:
  - License token
  - Device ID
  - User preferences
  - AI usage counters

## Design Patterns

### Repository Pattern
Data access through repositories:
```dart
abstract class ProjectRepository {
  Future<List<Project>> getAll();
  Future<Project?> getById(int id);
  Future<void> save(Project project);
  Future<void> delete(int id);
}
```

### Provider Pattern
State management with Riverpod:
```dart
final projectsProvider = FutureProvider<List<Project>>((ref) async {
  final repository = ref.watch(projectRepositoryProvider);
  return repository.getAll();
});
```

### Service Pattern
Business logic in services:
```dart
abstract class QuoteService {
  Future<Quote> generateQuote(int projectId);
}
```

## Dependency Injection

Riverpod handles dependency injection:

```dart
// Define provider
final projectRepositoryProvider = Provider<ProjectRepository>((ref) {
  return IsarProjectRepository(ref.watch(isarProvider));
});

// Use provider
final repository = ref.watch(projectRepositoryProvider);
```

## Error Handling

### AsyncValue Pattern
```dart
final dataProvider = FutureProvider<Data>((ref) async {
  // May throw
  return await fetchData();
});

// In widget
ref.watch(dataProvider).when(
  data: (data) => DataWidget(data),
  loading: () => LoadingWidget(),
  error: (error, stack) => ErrorWidget(error),
);
```

### Result Pattern
For business logic:
```dart
sealed class Result<T> {
  const Result();
}

class Success<T> extends Result<T> {
  final T value;
  const Success(this.value);
}

class Failure<T> extends Result<T> {
  final String message;
  const Failure(this.message);
}
```

## Testing Strategy

### Unit Tests
- Test domain logic
- Test data transformations
- Test business rules

### Widget Tests
- Test UI components
- Test user interactions
- Test state changes

### Integration Tests
- Test feature flows
- Test data persistence
- Test state management

## Code Generation

### Isar
```dart
@collection
class Project {
  Id id = Isar.autoIncrement;
  // fields...
}
```

Run: `flutter pub run build_runner build`

### Riverpod (Future)
```dart
@riverpod
class ProjectsNotifier extends _$ProjectsNotifier {
  // implementation
}
```

## Best Practices

### 1. Feature Independence
- Features should be loosely coupled
- Share code through shared/ directory
- Use providers for cross-feature communication

### 2. Immutability
- Use const constructors where possible
- Prefer immutable data models
- Use copyWith for updates

### 3. Async/Await
- Use FutureProvider for async data
- Handle loading/error states
- Use async/await for clarity

### 4. Code Organization
- One widget per file (complex widgets)
- Group related providers
- Keep files under 300 lines

### 5. Documentation
- Document complex business logic
- Add dartdocs for public APIs
- Comment non-obvious code

## Performance Considerations

### 1. Provider Optimization
- Use Provider.autoDispose when appropriate
- Minimize provider rebuilds
- Use family/select for targeted updates

### 2. Widget Optimization
- Use const constructors
- Separate build methods
- Use RepaintBoundary for complex widgets

### 3. Database Optimization
- Index frequently queried fields
- Batch operations where possible
- Use lazy loading for large lists

## Security Considerations

### 1. License Verification
- Verify signatures before trust
- Store public key securely
- Handle verification failures gracefully

### 2. Data Protection
- Don't log sensitive data
- Encrypt sensitive local data
- Clear data on license violation

### 3. Input Validation
- Validate all user inputs
- Sanitize before persistence
- Handle edge cases

## Future Enhancements

### Planned Features
- Multi-language support (i18n)
- Offline mode improvements
- Cloud sync (Pro)
- Collaboration features (Pro)
- Advanced analytics
- Custom branding (Pro)

### Technical Debt
- Add integration tests
- Improve error messages
- Add performance monitoring
- Add crash reporting
