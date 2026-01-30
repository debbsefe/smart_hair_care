import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_hair_care/core/database/database.dart';
import 'package:smart_hair_care/features/product_inventory/notifiers/notifiers.dart';

/// A widget that allows selecting multiple products from inventory
class ProductPicker extends ConsumerStatefulWidget {
  const ProductPicker({
    required this.selectedProductIds,
    required this.onChanged,
    super.key,
  });

  /// Comma-separated list of product IDs
  final String? selectedProductIds;

  /// Callback when selection changes, returns comma-separated IDs
  final ValueChanged<String?> onChanged;

  @override
  ConsumerState<ProductPicker> createState() => _ProductPickerState();
}

class _ProductPickerState extends ConsumerState<ProductPicker> {
  late Set<int> _selectedIds;

  @override
  void initState() {
    super.initState();
    _selectedIds = _parseIds(widget.selectedProductIds);
  }

  @override
  void didUpdateWidget(ProductPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedProductIds != widget.selectedProductIds) {
      _selectedIds = _parseIds(widget.selectedProductIds);
    }
  }

  Set<int> _parseIds(String? ids) {
    if (ids == null || ids.isEmpty) return {};
    return ids
        .split(',')
        .map((s) => int.tryParse(s.trim()))
        .whereType<int>()
        .toSet();
  }

  String? _idsToString(Set<int> ids) {
    if (ids.isEmpty) return null;
    return ids.join(',');
  }

  void _toggleProduct(int id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    });
    widget.onChanged(_idsToString(_selectedIds));
  }

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(productsProvider);
    final theme = Theme.of(context);

    return productsAsync.when(
      data: (products) => _buildContent(context, theme, products),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, _) => const Center(child: Text('Failed to load products')),
    );
  }

  Widget _buildContent(
    BuildContext context,
    ThemeData theme,
    List<Product> products,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with label
        Row(
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 20,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 8),
            Text(
              'Products Used',
              style: theme.textTheme.titleSmall,
            ),
            const Spacer(),
            if (_selectedIds.isNotEmpty)
              TextButton.icon(
                onPressed: () {
                  setState(() => _selectedIds.clear());
                  widget.onChanged(null);
                },
                icon: const Icon(Icons.clear, size: 18),
                label: const Text('Clear'),
              ),
          ],
        ),
        const SizedBox(height: 8),

        // Selected products chips
        if (_selectedIds.isNotEmpty) ...[
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _selectedIds.map((id) {
              final product = products.where((p) => p.id == id).firstOrNull;
              return Chip(
                avatar: const Icon(Icons.check, size: 18),
                label: Text(product?.name ?? 'Product #$id'),
                onDeleted: () => _toggleProduct(id),
                deleteIcon: const Icon(Icons.close, size: 18),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
        ],

        // Add products button
        OutlinedButton.icon(
          onPressed: () => _showProductPicker(context, products),
          icon: const Icon(Icons.add),
          label: Text(
            _selectedIds.isEmpty ? 'Select Products' : 'Add More Products',
          ),
        ),

        // Helper text
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            'Select products from your inventory',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showProductPicker(
    BuildContext context,
    List<Product> products,
  ) async {
    if (products.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No products in inventory. Add some products first!'),
        ),
      );
      return;
    }

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => _ProductPickerSheet(
          products: products,
          selectedIds: _selectedIds,
          scrollController: scrollController,
          onToggle: _toggleProduct,
        ),
      ),
    );
  }
}

class _ProductPickerSheet extends StatefulWidget {
  const _ProductPickerSheet({
    required this.products,
    required this.selectedIds,
    required this.scrollController,
    required this.onToggle,
  });

  final List<Product> products;
  final Set<int> selectedIds;
  final ScrollController scrollController;
  final void Function(int) onToggle;

  @override
  State<_ProductPickerSheet> createState() => _ProductPickerSheetState();
}

class _ProductPickerSheetState extends State<_ProductPickerSheet> {
  String _searchQuery = '';
  String? _selectedCategory;

  List<Product> get _filteredProducts {
    var products = widget.products;

    if (_selectedCategory != null) {
      products = products
          .where((p) => p.category == _selectedCategory)
          .toList();
    }

    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      products = products.where((p) {
        return p.name.toLowerCase().contains(query) ||
            (p.brand?.toLowerCase().contains(query) ?? false);
      }).toList();
    }

    return products;
  }

  List<String> get _categories {
    return widget.products.map((p) => p.category).toSet().toList()..sort();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filteredProducts = _filteredProducts;

    return Column(
      children: [
        // Handle
        Container(
          margin: const EdgeInsets.only(top: 12),
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(2),
          ),
        ),

        // Title
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Text(
                'Select Products',
                style: theme.textTheme.titleLarge,
              ),
              const Spacer(),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
        ),

        // Search bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search products...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            onChanged: (value) => setState(() => _searchQuery = value),
          ),
        ),

        // Category filter
        if (_categories.length > 1) ...[
          const SizedBox(height: 12),
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                FilterChip(
                  label: const Text('All'),
                  selected: _selectedCategory == null,
                  onSelected: (_) => setState(() => _selectedCategory = null),
                ),
                const SizedBox(width: 8),
                ..._categories.map(
                  (category) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(category),
                      selected: _selectedCategory == category,
                      onSelected: (_) => setState(
                        () => _selectedCategory = _selectedCategory == category
                            ? null
                            : category,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],

        const SizedBox(height: 8),
        const Divider(),

        // Products list
        Expanded(
          child: filteredProducts.isEmpty
              ? Center(
                  child: Text(
                    'No products found',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                )
              : ListView.builder(
                  controller: widget.scrollController,
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = filteredProducts[index];
                    final isSelected = widget.selectedIds.contains(product.id);

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: isSelected
                            ? theme.colorScheme.primaryContainer
                            : theme.colorScheme.surfaceContainerHighest,
                        child: Icon(
                          isSelected ? Icons.check : Icons.inventory_2_outlined,
                          color: isSelected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      title: Text(product.name),
                      subtitle: Text(
                        [
                          if (product.brand != null) product.brand!,
                          product.category,
                        ].join(' • '),
                      ),
                      trailing: isSelected
                          ? Icon(
                              Icons.check_circle,
                              color: theme.colorScheme.primary,
                            )
                          : null,
                      selected: isSelected,
                      onTap: () => widget.onToggle(product.id),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
