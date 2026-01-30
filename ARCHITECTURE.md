# Smart Hair Care - Architecture & Conventions

This document outlines the patterns and conventions used in this project. Follow these guidelines when adding new features.

---

## Table of Contents

1. [Project Structure](#project-structure)
2. [State Management](#state-management)
3. [API Layer](#api-layer)
4. [Navigation](#navigation)
5. [Localization](#localization)
6. [Widgets](#widgets)
7. [Code Generation](#code-generation)

---

## Project Structure

Features are organized under `lib/features/<feature_name>/` with the following structure:

```
lib/features/<feature_name>/
├── notifiers/
│   ├── notifiers.dart          # Barrel export
│   └── <name>_notifier.dart    # AsyncNotifier / Notifier
├── view/
│   ├── view.dart               # Barrel export
│   └── <name>_page.dart        # Page widgets
├── widgets/
│   ├── widgets.dart            # Barrel export
│   └── <name>_tile.dart        # Reusable widgets
└── <feature_name>.dart         # Feature barrel export (optional)
```

### Barrel Exports

Each subdirectory has a barrel file that exports all files in that directory:

```dart
// notifiers/notifiers.dart
export 'product_search_notifier.dart';
export 'products_notifier.dart';
```

---

## State Management

### Riverpod 3 with AsyncNotifier Pattern

Use `AsyncNotifier<T>` for data fetching with automatic `AsyncValue` handling. The `build()` method returns `Future<T>` and Riverpod automatically manages loading/error/data states.

### AsyncNotifier Class (Preferred for Data Fetching)

```dart
class ProductsNotifier extends AsyncNotifier<List<Product>> {
  late final ProductsDao _dao;

  @override
  Future<List<Product>> build() async {
    _dao = ref.watch(productsDaoProvider);
    return _dao.getAllProducts();
  }

  Future<void> addProduct({required String name, required String category}) async {
    await _dao.insertProduct(ProductsCompanion(
      name: Value(name),
      category: Value(category),
    ));
    ref.invalidateSelf(); // Triggers reload
  }

  Future<void> deleteProduct(int id) async {
    await _dao.deleteProduct(id);
    ref.invalidateSelf();
  }
}
```

### Provider Declaration

```dart
final productsProvider = AsyncNotifierProvider<ProductsNotifier, List<Product>>(
  ProductsNotifier.new,
);

// Derived providers for filtered views
final favoriteProductsProvider = Provider<List<Product>>((ref) {
  final productsAsync = ref.watch(productsProvider);
  return productsAsync.when(
    data: (products) => products.where((p) => p.isFavorite).toList(),
    loading: () => [],
    error: (_, _) => [],
  );
});
```

### UI with AsyncValue.when()

```dart
class ProductsPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsProvider);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(productsProvider.future),
        child: productsAsync.when(
          data: (products) => ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) => ProductTile(product: products[index]),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error: $error'),
                ElevatedButton(
                  onPressed: () => ref.invalidate(productsProvider),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

### Simple State Notifier (For Filters, Toggles)

```dart
class FilterNotifier extends Notifier<FilterStatus> {
  @override
  FilterStatus build() => FilterStatus.active;

  set filter(FilterStatus value) => state = value;
  FilterStatus get filter => state;
}

final filterProvider = NotifierProvider<FilterNotifier, FilterStatus>(
  FilterNotifier.new,
);
```

---

## API Layer

### Location

API clients live in `lib/core/network/`:

```
lib/core/network/
├── api_client.dart         # Retrofit service + provider
├── api_constants.dart      # Base URLs, timeouts
└── models/
    ├── models.dart         # Barrel export
    ├── api_product.dart    # Freezed model
    └── product_search_response.dart
```

### Retrofit Service Pattern

```dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';

part 'api_client.g.dart';

/// Provider at top
final apiClientProvider = Provider<ApiClient>((ref) {
  final dio = _createDio(ApiConstants.baseUrl);
  ref.onDispose(dio.close);
  return ApiClient(dio);
});

/// Retrofit abstract class
@RestApi()
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  @GET('/search')
  Future<SearchResponse> search({
    @Query('search_terms') String? searchTerms,
    @Query('page_size') int? pageSize,
    @Query('page') int? page,
  });
}

/// Dio creation at bottom
Dio _createDio(String baseUrl) {
  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(milliseconds: 30000),
      receiveTimeout: const Duration(milliseconds: 30000),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  );

  if (kDebugMode) {
    dio.interceptors.add(PrettyDioLogger());
  }

  return dio;
}
```

### API Models with Freezed

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_product.freezed.dart';
part 'api_product.g.dart';

@freezed
sealed class ApiProduct with _$ApiProduct {
  const factory ApiProduct({
    @JsonKey(name: '_id') String? id,
    String? code,
    @JsonKey(name: 'product_name') String? productName,
    String? brands,
    @JsonKey(name: 'image_url') String? imageUrl,
  }) = _ApiProduct;

  factory ApiProduct.fromJson(Map<String, dynamic> json) =>
      _$ApiProductFromJson(json);
}
```

---

## Navigation

### Navigator 1.0 with Static `getRoute()` Methods

Each page provides a static factory method returning a `MaterialPageRoute`:

```dart
class MyFeaturePage extends ConsumerStatefulWidget {
  const MyFeaturePage({super.key});

  /// Returns a [MaterialPageRoute] for Navigator 1.0 navigation
  static Route<ReturnType?> getRoute({OptionalParam? param}) {
    return MaterialPageRoute<ReturnType?>(
      builder: (_) => const MyFeaturePage(),
      settings: const RouteSettings(name: '/my-feature'),
    );
  }

  @override
  ConsumerState<MyFeaturePage> createState() => _MyFeaturePageState();
}
```

### Navigation Usage

```dart
// Navigate and wait for result
final result = await Navigator.push<ApiProduct?>(
  context,
  ProductSearchPage.getRoute(),
);

// Navigate without result
Navigator.push(
  context,
  ProductDetailPage.getRoute(product: product),
);

// Return result
Navigator.pop(context, selectedItem);
```

---

## Localization

### ARB Files Location

```
lib/l10n/arb/
└── app_en.arb    # English (source)
```

### Adding New Strings

Add to `app_en.arb`:

```json
{
    "searchProductsTitle": "Search Products",
    "searchProductsHint": "Search by product name or brand...",
    "searchProductsEmpty": "Enter a product name or brand to search",
    "searchProductsNoResults": "No products found",
    "searchProductsError": "Failed to search products",
    "searchProductsRetry": "Retry"
}
```

### Usage in Code

```dart
import 'package:smart_hair_care/l10n/l10n.dart';

// In build method
final l10n = context.l10n;
Text(l10n.searchProductsTitle);
```

### Generate Localizations

```bash
flutter gen-l10n
```

---

## Widgets

### Tile Pattern

List item widgets follow the `*Tile` naming convention:

```dart
class ApiProductTile extends StatelessWidget {
  const ApiProductTile({
    required this.product,
    this.onTap,
    super.key,
  });

  final ApiProduct product;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Image placeholder
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _buildImage(),
              ),
              const SizedBox(width: 16),
              // Content
              Expanded(child: _buildContent(theme)),
              // Action icon
              Icon(Icons.chevron_right, color: theme.colorScheme.outline),
            ],
          ),
        ),
      ),
    );
  }
}
```

### Page Pattern with Search

```dart
class SearchPage extends ConsumerStatefulWidget {
  // ... getRoute() ...

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final searchState = ref.watch(searchProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.searchTitle)),
      body: Column(
        children: [
          // Search input
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: l10n.searchHint,
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
              ),
              onChanged: (query) {
                ref.read(searchProvider.notifier).search(query);
              },
              autofocus: true,
            ),
          ),
          // Results
          Expanded(child: _buildContent(searchState, l10n)),
        ],
      ),
    );
  }

  Widget _buildContent(SearchState state, AppLocalizations l10n) {
    if (state.error != null) return _buildError(state, l10n);
    if (state.isLoading) return const Center(child: CircularProgressIndicator());
    if (state.query.isEmpty) return _buildEmptyPrompt(l10n);
    if (state.items.isEmpty) return _buildNoResults(l10n);
    return _buildList(state);
  }
}
```

---

## Code Generation

### Run Build Runner

```bash
# Full build
dart run build_runner build --delete-conflicting-outputs

# Watch mode
dart run build_runner watch --delete-conflicting-outputs

# Specific folder
dart run build_runner build --delete-conflicting-outputs \
  --build-filter="lib/features/product_inventory/**"
```

### Generated Files

- `*.freezed.dart` - Freezed classes
- `*.g.dart` - JSON serialization & Retrofit

### Analysis Options

In `analysis_options.yaml`, ignore warnings for Freezed/JsonKey:

```yaml
analyzer:
  errors:
    invalid_annotation_target: ignore
```

---

## Checklist for New Features

1. [ ] Create feature folder structure with `notifiers/`, `view/`, `widgets/`
2. [ ] Create AsyncNotifier for data fetching (or Notifier for complex state)
3. [ ] Create provider declaration with `AsyncNotifierProvider`
4. [ ] Create derived providers for filtered/computed data
5. [ ] Create page with static `getRoute()` method
6. [ ] Use `AsyncValue.when()` pattern in UI
7. [ ] Create tile widget if displaying lists
8. [ ] Add barrel exports to all subdirectories (`notifiers.dart`, `view.dart`)
9. [ ] Add localization strings to `app_en.arb`
10. [ ] Run `flutter gen-l10n`
11. [ ] Run `dart run build_runner build --delete-conflicting-outputs`
12. [ ] Run `flutter analyze`
13. [ ] Add unit tests in `test/features/<feature>/notifiers/`
