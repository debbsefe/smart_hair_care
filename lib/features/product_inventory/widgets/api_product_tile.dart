import 'package:flutter/material.dart';
import 'package:smart_hair_care/core/network/models/models.dart';

/// A card widget displaying API product information from search results
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
    final imageUrl = product.imageSmallUrl ?? product.imageUrl;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Product image or placeholder
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: imageUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Icon(
                            Icons.inventory_2_outlined,
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                      )
                    : Icon(
                        Icons.inventory_2_outlined,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
              ),
              const SizedBox(width: 16),
              // Product info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.productName ?? 'Unknown Product',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (product.brands != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        product.brands!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    if (product.categories != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        product.categories!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.outline,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              // Add icon
              Icon(
                Icons.add_circle_outline,
                color: theme.colorScheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
