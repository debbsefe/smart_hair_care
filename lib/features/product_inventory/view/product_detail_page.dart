import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_hair_care/core/database/database.dart';
import 'package:smart_hair_care/features/product_inventory/providers/providers.dart';
import 'package:smart_hair_care/features/product_inventory/view/add_edit_product_page.dart';
import 'package:smart_hair_care/l10n/l10n.dart';

/// Page displaying detailed information about a single product
class ProductDetailPage extends ConsumerWidget {
  const ProductDetailPage({
    required this.productId,
    super.key,
  });

  final int productId;

  /// Returns a [MaterialPageRoute] for Navigator 1.0 navigation
  static Route<void> getRoute({required int productId}) {
    return MaterialPageRoute<void>(
      builder: (_) => ProductDetailPage(productId: productId),
      settings: RouteSettings(name: '/products/$productId'),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productAsync = ref.watch(productByIdProvider(productId));
    final l10n = context.l10n;

    return productAsync.when(
      data: (product) {
        if (product == null) {
          return Scaffold(
            appBar: AppBar(title: Text(l10n.productDetailTitle)),
            body: const Center(child: Text('Product not found')),
          );
        }
        return _ProductDetailView(product: product);
      },
      loading: () => Scaffold(
        appBar: AppBar(title: Text(l10n.productDetailTitle)),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        appBar: AppBar(title: Text(l10n.productDetailTitle)),
        body: Center(child: Text('Error: $error')),
      ),
    );
  }
}

class _ProductDetailView extends ConsumerWidget {
  const _ProductDetailView({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.productDetailTitle),
        actions: [
          IconButton(
            icon: Icon(
              product.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: product.isFavorite ? Colors.red : null,
            ),
            onPressed: () => ref
                .read(productsProvider.notifier)
                .toggleFavorite(product.id, isFavorite: !product.isFavorite),
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => Navigator.push(
              context,
              AddEditProductPage.getRoute(product: product),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image/header
            Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: product.imageUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          product.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Icon(
                            Icons.inventory_2_outlined,
                            size: 48,
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                      )
                    : Icon(
                        Icons.inventory_2_outlined,
                        size: 48,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
              ),
            ),
            const SizedBox(height: 24),

            // Name and brand
            Center(
              child: Text(
                product.name,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            if (product.brand != null) ...[
              const SizedBox(height: 4),
              Center(
                child: Text(
                  product.brand!,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 16),

            // Category and rating
            Center(
              child: Wrap(
                spacing: 12,
                children: [
                  Chip(
                    label: Text(product.category),
                    backgroundColor: theme.colorScheme.secondaryContainer,
                  ),
                  if (product.rating != null)
                    Chip(
                      avatar: Icon(
                        Icons.star,
                        color: Colors.amber.shade600,
                        size: 18,
                      ),
                      label: Text(product.rating!.toStringAsFixed(1)),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Details section
            _DetailSection(
              title: l10n.productIngredientsLabel,
              content: product.ingredients,
              icon: Icons.science_outlined,
            ),
            _DetailSection(
              title: l10n.productNotesLabel,
              content: product.notes,
              icon: Icons.notes_outlined,
            ),

            // Dates
            if (product.purchaseDate != null || product.expiryDate != null) ...[
              const Divider(height: 32),
              Text(
                'Dates',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              if (product.purchaseDate != null)
                _DateRow(
                  label: l10n.productPurchaseDateLabel,
                  date: product.purchaseDate!,
                ),
              if (product.expiryDate != null)
                _DateRow(
                  label: l10n.productExpiryDateLabel,
                  date: product.expiryDate!,
                  isExpired: product.expiryDate!.isBefore(DateTime.now()),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DetailSection extends StatelessWidget {
  const _DetailSection({
    required this.title,
    required this.content,
    required this.icon,
  });

  final String title;
  final String? content;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    if (content == null || content!.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            content!,
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _DateRow extends StatelessWidget {
  const _DateRow({
    required this.label,
    required this.date,
    this.isExpired = false,
  });

  final String label;
  final DateTime date;
  final bool isExpired;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.textTheme.bodyMedium),
          Text(
            '${date.day}/${date.month}/${date.year}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isExpired ? theme.colorScheme.error : null,
              fontWeight: isExpired ? FontWeight.bold : null,
            ),
          ),
        ],
      ),
    );
  }
}
