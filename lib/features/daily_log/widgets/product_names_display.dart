import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_hair_care/features/product_inventory/notifiers/notifiers.dart';

/// A widget that displays product names from comma-separated product IDs
class ProductNamesDisplay extends ConsumerWidget {
  const ProductNamesDisplay({
    required this.productIds,
    this.style,
    super.key,
  });

  /// Comma-separated list of product IDs
  final String productIds;

  /// Text style for the product names
  final TextStyle? style;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsProvider);

    return productsAsync.when(
      data: (allProducts) {
        if (allProducts.isEmpty) {
          return Text(productIds, style: style);
        }

        final ids = productIds.split(',').map((s) => int.tryParse(s.trim()));
        final productNames = <String>[];

        for (final id in ids) {
          if (id == null) continue;
          final product = allProducts.where((p) => p.id == id).firstOrNull;
          if (product != null) {
            productNames.add(product.name);
          }
        }

        if (productNames.isEmpty) {
          return Text(productIds, style: style);
        }

        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: productNames.map((name) {
            return Chip(
              label: Text(name),
              visualDensity: VisualDensity.compact,
            );
          }).toList(),
        );
      },
      loading: () => Text(productIds, style: style),
      error: (_, _) => Text(productIds, style: style),
    );
  }
}
