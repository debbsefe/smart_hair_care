import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_hair_care/features/product_inventory/providers/providers.dart';
import 'package:smart_hair_care/features/product_inventory/view/add_edit_product_page.dart';
import 'package:smart_hair_care/features/product_inventory/view/product_detail_page.dart';
import 'package:smart_hair_care/features/product_inventory/widgets/widgets.dart';
import 'package:smart_hair_care/features/shared/widgets/widgets.dart';
import 'package:smart_hair_care/l10n/l10n.dart';

/// Page displaying the list of hair care products
class ProductsPage extends ConsumerWidget {
  const ProductsPage({super.key});

  /// Returns a [MaterialPageRoute] for Navigator 1.0 navigation
  static Route<void> getRoute() {
    return MaterialPageRoute<void>(
      builder: (_) => const ProductsPage(),
      settings: const RouteSettings(name: '/products'),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(productsProvider);
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.productsTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearch(context, ref),
          ),
        ],
      ),
      body: _buildBody(context, ref, state),
      floatingActionButton: FloatingActionButton(
        heroTag: 'products_fab',
        onPressed: () => Navigator.push(context, AddEditProductPage.getRoute()),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, ProductsState state) {
    if (state.isLoading && state.products.isEmpty) {
      return const LoadingView();
    }

    if (state.error != null && state.products.isEmpty) {
      return ErrorView(
        message: state.error!,
        onRetry: () => ref.read(productsProvider.notifier).loadProducts(),
      );
    }

    if (state.products.isEmpty) {
      return EmptyView(
        icon: Icons.inventory_2_outlined,
        title: context.l10n.productsEmptyMessage,
        subtitle: context.l10n.productsEmptyHint,
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(productsProvider.notifier).loadProducts(),
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 8, bottom: 88),
        itemCount: state.products.length,
        itemBuilder: (context, index) {
          final product = state.products[index];
          return ProductTile(
            product: product,
            onTap: () => Navigator.push(
              context,
              ProductDetailPage.getRoute(productId: product.id),
            ),
            onFavoriteToggle: () => ref
                .read(productsProvider.notifier)
                .toggleFavorite(product.id, isFavorite: !product.isFavorite),
            onDelete: () => _confirmDelete(context, ref, product.id),
          );
        },
      ),
    );
  }

  Future<void> _showSearch(BuildContext context, WidgetRef ref) async {
    await showSearch(
      context: context,
      delegate: _ProductSearchDelegate(ref),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    int productId,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product'),
        content: const Text('Are you sure you want to delete this product?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed ?? false) {
      await ref.read(productsProvider.notifier).deleteProduct(productId);
    }
  }
}

class _ProductSearchDelegate extends SearchDelegate<void> {
  _ProductSearchDelegate(this.ref);

  final WidgetRef ref;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults(context);
  }

  Widget _buildSearchResults(BuildContext context) {
    if (query.isEmpty) {
      return const Center(child: Text('Enter a search term'));
    }

    return FutureBuilder(
      future: ref.read(productsProvider.notifier).searchProducts(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final products = snapshot.data ?? [];
        if (products.isEmpty) {
          return const Center(child: Text('No products found'));
        }

        return ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return ListTile(
              leading: const Icon(Icons.inventory_2_outlined),
              title: Text(product.name),
              subtitle: Text(product.brand ?? product.category),
              onTap: () async {
                close(context, null);
                await Navigator.push(
                  context,
                  ProductDetailPage.getRoute(productId: product.id),
                );
              },
            );
          },
        );
      },
    );
  }
}
