import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_hair_care/core/network/models/models.dart';
import 'package:smart_hair_care/features/product_inventory/notifiers/notifiers.dart';
import 'package:smart_hair_care/features/product_inventory/widgets/widgets.dart';
import 'package:smart_hair_care/l10n/l10n.dart';

/// Page for searching products from Open Beauty Facts API
class ProductSearchPage extends ConsumerStatefulWidget {
  const ProductSearchPage({super.key});

  /// Returns a [MaterialPageRoute] for Navigator 1.0 navigation
  static Route<ApiProduct?> getRoute() {
    return MaterialPageRoute<ApiProduct?>(
      builder: (_) => const ProductSearchPage(),
      settings: const RouteSettings(name: '/products/search'),
    );
  }

  @override
  ConsumerState<ProductSearchPage> createState() => _ProductSearchPageState();
}

class _ProductSearchPageState extends ConsumerState<ProductSearchPage> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    ref.read(productSearchProvider.notifier).search(query);
  }

  void _clearSearch() {
    _searchController.clear();
    ref.read(productSearchProvider.notifier).clearSearch();
  }

  void _selectProduct(ApiProduct product) {
    Navigator.pop(context, product);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final searchState = ref.watch(productSearchProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.searchProductsTitle),
      ),
      body: Column(
        children: [
          // Search input
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: l10n.searchProductsHint,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: _clearSearch,
                      )
                    : null,
                border: const OutlineInputBorder(),
              ),
              onChanged: _onSearchChanged,
              textInputAction: TextInputAction.search,
              autofocus: true,
            ),
          ),
          // Results
          Expanded(
            child: _buildContent(searchState, l10n, theme),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
    ProductSearchState searchState,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    if (searchState.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: theme.colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                l10n.searchProductsError,
                style: theme.textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                searchState.error!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.outline,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              FilledButton.tonal(
                onPressed: () => _onSearchChanged(searchState.query),
                child: Text(l10n.searchProductsRetry),
              ),
            ],
          ),
        ),
      );
    }

    if (searchState.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (searchState.query.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search,
                size: 64,
                color: theme.colorScheme.outline,
              ),
              const SizedBox(height: 16),
              Text(
                l10n.searchProductsEmpty,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.outline,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    if (searchState.products.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.inventory_2_outlined,
                size: 64,
                color: theme.colorScheme.outline,
              ),
              const SizedBox(height: 16),
              Text(
                l10n.searchProductsNoResults,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.outline,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: searchState.products.length,
      itemBuilder: (context, index) {
        final product = searchState.products[index];
        return ApiProductTile(
          product: product,
          onTap: () => _selectProduct(product),
        );
      },
    );
  }
}
