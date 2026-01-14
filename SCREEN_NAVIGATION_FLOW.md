# Screen Navigation Flow - Balloon Studio

```
┌─────────────────────────────────────────────────────────────────┐
│                         HOME SCREEN                              │
│  (lib/src/features/home/presentation/home_screen.dart)          │
├─────────────────────────────────────────────────────────────────┤
│  AppBar: "Balloon Design Studio"               [PRO Badge]      │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  Benvenuto a Balloon Design Studio                              │
│                                                                  │
│  ┌────────────────────────────────────────────────────────┐    │
│  │ Il Tuo Piano: PRO                                      │    │
│  │ • Progetti: Illimitato                                 │    │
│  │ • Elementi: Illimitato                                 │    │
│  │ • PDF Professionale • Esportazione Immagini            │    │
│  │ • AI Abilitata (10/giorno)                             │    │
│  └────────────────────────────────────────────────────────┘    │
│                                                                  │
│  ┌─────────────────┐  ┌─────────────────┐                      │
│  │    Progetti     │  │     Modelli     │                      │
│  │  [work_icon]    │  │ [dashboard_icon]│                      │
│  │  Gestisci i     │  │  Sfoglia i      │                      │
│  │  tuoi design    │  │  modelli di     │  ← TAP TO NAVIGATE   │
│  │  di palloncini  │  │  design         │                      │
│  └─────────────────┘  └─────────────────┘                      │
│          ↓                      ↓                                │
│  ┌─────────────────┐  ┌─────────────────┐                      │
│  │     Prezzi      │  │     Esporta     │                      │
│  │  [money_icon]   │  │ [download_icon] │                      │
│  │  Configura      │  │  Esporta design │  ← SHOWS SNACKBAR    │
│  │  i prezzi       │  │  e preventivi   │                      │
│  └─────────────────┘  └─────────────────┘                      │
│                                                                  │
│                                          [+ Nuovo Progetto]     │
└─────────────────────────────────────────────────────────────────┘
                          │                  │
                          ↓                  ↓
        ┌─────────────────────────┐  ┌─────────────────────────┐
        │   PROJECTS SCREEN       │  │   TEMPLATES SCREEN      │
        │     (New Screen)        │  │      (New Screen)       │
        └─────────────────────────┘  └─────────────────────────┘
```

## Projects Screen
```
┌─────────────────────────────────────────────────────────────────┐
│  ← I Miei Progetti                                              │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  Empty State (when no projects):                                │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │              [work_outline_icon]                         │  │
│  │                                                          │  │
│  │          Nessun progetto ancora                         │  │
│  │     Crea il tuo primo progetto per iniziare            │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                  │
│  OR                                                              │
│                                                                  │
│  Project Cards (when data exists):                              │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │ Project Name                          [Bozza]           │  │
│  │ Description text here                                   │  │
│  │ • Cliente Name  • Event Type  • 5 elementi            │  │
│  └──────────────────────────────────────────────────────────┘  │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │ Another Project                       [In Corso]        │  │
│  │ ...                                                      │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                  │
│                                          [+ Nuovo Progetto]     │
└─────────────────────────────────────────────────────────────────┘
```

## Templates Screen
```
┌─────────────────────────────────────────────────────────────────┐
│  ← Modelli di Design                                            │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  Empty State (when no templates):                               │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │           [dashboard_outlined_icon]                      │  │
│  │                                                          │  │
│  │          Nessun modello disponibile                     │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                  │
│  OR                                                              │
│                                                                  │
│  Template Grid (2 columns, when data exists):                   │
│  ┌────────────────────┐  ┌────────────────────┐               │
│  │  [Thumbnail Area]  │  │  [Thumbnail Area]  │               │
│  │                    │  │                    │               │
│  │  Template 1        │  │  Template 2        │               │
│  │  Description       │  │  Description       │               │
│  │              [PRO] │  │                    │               │
│  └────────────────────┘  └────────────────────┘               │
│  ┌────────────────────┐  ┌────────────────────┐               │
│  │  [Thumbnail Area]  │  │  [Thumbnail Area]  │               │
│  │  ...               │  │  ...               │               │
│  └────────────────────┘  └────────────────────┘               │
│                                                                  │
│  Tap on template → Opens Dialog:                                │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  Template Name                                   [X]     │  │
│  │  ─────────────────────────────────────────────────────   │  │
│  │  Description text here...                                │  │
│  │                                                          │  │
│  │  [⭐ Solo PRO badge if premium]                         │  │
│  │                                                          │  │
│  │                      [Annulla] [Usa Modello]           │  │
│  └──────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
```

## Navigation Map
```
                    HomeScreen
                        │
        ┌───────────────┼───────────────┐
        │               │               │
        ↓               ↓               ↓
   ProjectsScreen  TemplatesScreen  Snackbar
        │               │          (Pricing/Export)
        ↓               ↓
   [Future CRUD]   [Future Template
    operations]     application]
```

## Layout Structure

### HomeScreen Layout
```
Scaffold
└── SafeArea
    └── SingleChildScrollView  ← Prevents overflow
        └── Padding
            └── Column
                ├── Welcome Text
                ├── Entitlements Card
                └── GridView.count  ← shrinkWrap: true
                    ├── Projects Card (onTap: navigate)
                    ├── Templates Card (onTap: navigate)
                    ├── Pricing Card (onTap: snackbar)
                    └── Export Card (onTap: snackbar)
```

### ProjectsScreen Layout
```
Scaffold
├── AppBar
├── body: SafeArea
│   ├── Empty State (if no data)
│   └── ListView.builder (if has data)
│       └── Project Cards
└── FloatingActionButton (+ Nuovo Progetto)
```

### TemplatesScreen Layout
```
Scaffold
├── AppBar
└── body: SafeArea
    ├── Empty State (if no data)
    └── GridView.builder (if has data)
        └── Template Cards
            └── onTap: showDialog
```

## Key Improvements

### Before (Issues)
```
❌ Empty onTap callbacks: () {}
❌ Hardcoded English strings
❌ Layout overflow (Expanded + GridView)
❌ No screens for Projects/Templates
❌ Non-functional navigation
```

### After (Fixed)
```
✅ Working onTap with Navigator.push()
✅ Italian localization with gen-l10n
✅ SafeArea + SingleChildScrollView
✅ ProjectsScreen & TemplatesScreen created
✅ Full navigation implementation
✅ Flexible widgets prevent overflow
```

## File Organization

```
lib/
├── l10n/
│   └── app_it.arb              ← Italian translations
├── src/
│   ├── core/
│   │   └── app.dart            ← Modified: localization setup
│   └── features/
│       ├── home/
│       │   └── presentation/
│       │       └── home_screen.dart      ← Modified: navigation + i18n
│       ├── projects/
│       │   ├── domain/
│       │   │   └── project_model.dart    ← Existing
│       │   └── presentation/
│       │       └── projects_screen.dart  ← NEW
│       └── templates/
│           ├── domain/
│           │   └── template_model.dart   ← Existing
│           └── presentation/
│               └── templates_screen.dart ← NEW
└── main.dart                   ← Unchanged

l10n.yaml                       ← NEW: localization config
pubspec.yaml                    ← Modified: flutter_localizations
```

## Italian Localization Keys

All screens use AppLocalizations.of(context)! to access:

```dart
// Home Screen
l10n.appTitle               → "Balloon Design Studio"
l10n.welcomeMessage         → "Benvenuto a Balloon Design Studio"
l10n.yourPlan(plan)         → "Il Tuo Piano: {plan}"
l10n.projects               → "Progetti"
l10n.projectsDescription    → "Gestisci i tuoi design di palloncini"
l10n.templates              → "Modelli"
l10n.templatesDescription   → "Sfoglia i modelli di design"
l10n.newProject             → "Nuovo Progetto"
l10n.unlimited              → "Illimitato"

// Projects Screen
l10n.myProjects             → "I Miei Progetti"
l10n.noProjects             → "Nessun progetto ancora"
l10n.createFirstProject     → "Crea il tuo primo progetto per iniziare"
l10n.draft                  → "Bozza"
l10n.inProgress             → "In Corso"
l10n.completed              → "Completato"
l10n.archived               → "Archiviato"
l10n.elementsCount(n)       → "{n} elementi"

// Templates Screen
l10n.designTemplates        → "Modelli di Design"
l10n.noTemplates            → "Nessun modello disponibile"
l10n.proOnly                → "Solo PRO"
l10n.useTemplate            → "Usa Modello"
l10n.cancel                 → "Annulla"

// And 20+ more keys for all UI elements
```

## Testing Scenarios

### Scenario 1: Navigation from Home
1. User opens app
2. Sees Italian welcome message
3. Taps "Progetti" card
4. → Navigates to ProjectsScreen
5. Sees "Nessun progetto ancora"
6. Taps back button
7. → Returns to HomeScreen

### Scenario 2: Template Browsing
1. User taps "Modelli" card
2. → Navigates to TemplatesScreen
3. Sees "Nessun modello disponibile"
4. (When data exists: sees grid of templates)
5. Taps template card
6. → Opens dialog with details
7. Taps "Usa Modello"
8. → Shows snackbar

### Scenario 3: Layout Overflow Prevention
1. User opens app on small screen
2. Content scrolls without overflow
3. All cards fit properly
4. FAB doesn't cover content
5. SafeArea respects system UI
6. Text doesn't overflow cards

This completes the visual documentation of the implementation!
