# Architecture Overview

This document summarizes the core architecture and developer workflow for the Smart Hair Care app (MVP).

## High-level structure

The repository follows a feature-first layout with clear separation between UI, state, persistence, and localization:

- `lib/app` — App entry, theme, and global widgets
- `lib/bootstrap.dart` — App initialization and top-level Riverpod setup
- `lib/core` — Shared core code (database, models, helpers)
  - `lib/core/database` — Drift database definition, tables, and DAOs
- `lib/features` — Feature modules (product inventory, daily log, hair profile, home)
- `lib/l10n/arb` — ARB translation resources


## Tech stack

- Flutter + Dart
- Riverpod (state management)
- Drift (type-safe SQLite) for persistence
- Freezed + json_serializable for immutable models and JSON
- build_runner for code generation (Drift, Retrofit, Freezed, etc.)
- flutter_localizations with ARB files for i18n


## Database (current MVP)

The app's Drift database currently exposes these tables/DAOs:

- `products` — Product inventory
- `daily_logs` — Daily routine entries
- `hair_profiles` — User hair profile data

## Developer workflow / code generation

1. Install deps:

```sh
flutter pub get
```

2. Generate code (recommended):

```sh
flutter pub run build_runner build --delete-conflicting-outputs
```

3. Regenerate localization if ARB changed:

```sh
flutter gen-l10n --arb-dir="lib/l10n/arb"
```

4. If you encounter stale generated files or build artifacts, run:

```sh
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```


## Tests & validation

- Run static analysis:

```sh
dart analyze
```

- Run tests:

```sh
flutter test
```
# Smart Hair Care - Architecture & Conventions

This document outlines the **architectural patterns** and **design conventions** used in this project. These patterns should remain stable even as specific implementation details change.

---

## Table of Contents

1. [Project Structure](#project-structure)
2. [State Management](#state-management)
3. [API Layer](#api-layer)
4. [Navigation](#navigation)
5. [Localization](#localization)
6. [Widgets](#widgets)
7. [Architectural Principles](#architectural-principles)
8. [Feature Development Checklist](#feature-development-checklist)

---

## Project Structure

### Feature-Based Organization

Features are organized under `lib/features/<feature_name>/` with a consistent, three-layer structure:

```
lib/features/<feature_name>/
├── notifiers/          # State management layer
│   ├── notifiers.dart          # Barrel export
│   └── *.dart                  # State notifiers
├── view/               # UI layer (pages)
│   ├── view.dart               # Barrel export
│   └── *_page.dart             # Full-screen pages
├── widgets/            # Reusable components
│   ├── widgets.dart            # Barrel export
│   └── *.dart                  # Standalone widgets
└── <feature_name>.dart # Feature-level barrel export
```

**Rationale:**
- **Cohesion**: Each feature is self-contained and easy to locate
- **Scalability**: Add new features by copying the structure pattern
- **Maintainability**: Clear separation between state, UI, and components

### Barrel Exports

Each subdirectory exports its public API through a barrel file:

```dart
// notifiers/notifiers.dart
export '<name>_notifier.dart';
export '<other>_notifier.dart';
```

This allows clean imports: `import 'package:app/features/foo/notifiers/notifiers.dart';`

---

## State Management

### Pattern: AsyncNotifier for Async Data

**When to use:** Data fetching from APIs or databases (products, logs, profiles)

**How it works:**
- `build()` method returns `Future<T>` - Riverpod manages loading/error/data states automatically
- Mutations call `ref.invalidateSelf()` to reload data
- UI observes with `AsyncValue.when()` for three states: loading → error → data

**Example structure:**
```dart
class ExampleNotifier extends AsyncNotifier<List<Model>> {
  @override
  Future<List<Model>> build() async {
    // Fetch data (from API, database, etc.)
    return await dataSource.getAll();
  }

  Future<void> mutate({required param}) async {
    // Perform mutation
    await dataSource.update(param);
    ref.invalidateSelf(); // Triggers rebuild of build()
  }
}

final exampleProvider = AsyncNotifierProvider<ExampleNotifier, List<Model>>(
  ExampleNotifier.new,
);

// Derived providers for computed state
final filteredExampleProvider = Provider<List<Model>>((ref) {
  final dataAsync = ref.watch(exampleProvider);
  return dataAsync.when(
    data: (items) => items.where((item) => condition).toList(),
    loading: () => [],
    error: (_, _) => [],
  );
});
```

### Pattern: Simple Notifier for Local State

**When to use:** UI state that doesn't involve async operations (filters, toggles, form inputs)

**Example:**
```dart
class FilterNotifier extends Notifier<FilterValue> {
  @override
  FilterValue build() => FilterValue.default;

  void setFilter(FilterValue value) => state = value;
}

final filterProvider = NotifierProvider<FilterNotifier, FilterValue>(
  FilterNotifier.new,
);
```

### UI Pattern: AsyncValue.when()

All pages consuming async data should use this pattern:

```dart
class ExamplePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataAsync = ref.watch(exampleProvider);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(exampleProvider.future),
        child: dataAsync.when(
          data: (items) => ListView(/* build list */),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => ErrorWidget(
            error: error,
            onRetry: () => ref.invalidate(exampleProvider),
          ),
        ),
      ),
    );
  }
}
```

---

## API Layer

### Pattern: Retrofit + Dio + Freezed

**Architecture:**
1. **Retrofit service** - HTTP client with typed endpoints
2. **Dio** - HTTP client with interceptors (logging, error handling)
3. **Freezed models** - Type-safe JSON serialization

**Directory structure:**
```
lib/core/network/
├── api_client.dart         # Retrofit abstract service + provider
├── api_constants.dart      # Configuration (base URLs, timeouts)
└── models/
    ├── models.dart         # Barrel export
    └── *.dart              # Freezed response/request models
```

**Retrofit service pattern:**
```dart
@RestApi()
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  @GET('<endpoint>')
  Future<ResponseModel> methodName({
    @Query('<param>') String? param,
    // ... more parameters
  });
}

final apiClientProvider = Provider<ApiClient>((ref) {
  final dio = _createDio(baseUrl);
  ref.onDispose(dio.close);
  return ApiClient(dio);
});

Dio _createDio(String baseUrl) {
  final dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(milliseconds: 30000),
    receiveTimeout: const Duration(milliseconds: 30000),
    headers: {'Accept': 'application/json'},
  ));

  if (kDebugMode) {
    dio.interceptors.add(PrettyDioLogger(/* configure as needed */));
  }

  return dio;
}
```

**Freezed model pattern:**
```dart
@freezed
sealed class ApiResponse with _$ApiResponse {
  const factory ApiResponse({
    @JsonKey(name: 'field_name') String? fieldName,
    // ... more fields
  }) = _ApiResponse;

  factory ApiResponse.fromJson(Map<String, dynamic> json) =>
      _$ApiResponseFromJson(json);
}
```

**Key principles:**
- API responses are immutable (`@freezed`)
- Field names map to JSON keys via `@JsonKey`
- Type-safe: compile-time verification of API contracts

---

## Navigation

### Pattern: Static getRoute() Factory Method

Each page provides a static factory method for navigation:

```dart
class ExamplePage extends ConsumerStatefulWidget {
  const ExamplePage({super.key, this.param});
  final ParamType? param;

  /// Static factory for Navigator 1.0
  static Route<ReturnType?> getRoute({ParamType? param}) {
    return MaterialPageRoute<ReturnType?>(
      builder: (_) => ExamplePage(param: param),
      settings: const RouteSettings(name: '/example'),
    );
  }

  @override
  ConsumerState<ExamplePage> createState() => _ExamplePageState();
}
```

**Usage:**
```dart
// Navigate and capture result
final result = await Navigator.push<ReturnType?>(
  context,
  ExamplePage.getRoute(param: value),
);

// Return result
Navigator.pop(context, result);
```

**Benefits:**
- Type-safe navigation
- Route configuration in one place
- Parameters validated at compile-time

---

## Localization

### Pattern: ARB-based Internationalization

**Structure:**
```
lib/l10n/
├── arb/
│   └── app_en.arb    # English strings (source of truth)
└── gen/              # Generated files (git-ignored)
    ├── app_localizations.dart
    ├── app_localizations_en.dart
    └── l10n.dart
```
