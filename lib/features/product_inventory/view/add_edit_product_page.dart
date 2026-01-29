import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_hair_care/core/database/database.dart';
import 'package:smart_hair_care/features/product_inventory/providers/providers.dart';
import 'package:smart_hair_care/l10n/l10n.dart';

/// Product categories available in the app
const productCategories = [
  'shampoo',
  'conditioner',
  'deep_conditioner',
  'leave_in',
  'oil',
  'cream',
  'gel',
  'mousse',
  'spray',
  'treatment',
  'other',
];

/// Page for adding or editing a product
class AddEditProductPage extends ConsumerStatefulWidget {
  const AddEditProductPage({
    this.product,
    super.key,
  });

  final Product? product;

  bool get isEditing => product != null;

  /// Returns a [MaterialPageRoute] for Navigator 1.0 navigation
  static Route<void> getRoute({Product? product}) {
    return MaterialPageRoute<void>(
      builder: (_) => AddEditProductPage(product: product),
      settings: RouteSettings(
        name: product != null
            ? '/products/${product.id}/edit'
            : '/products/add',
      ),
    );
  }

  @override
  ConsumerState<AddEditProductPage> createState() => _AddEditProductPageState();
}

class _AddEditProductPageState extends ConsumerState<AddEditProductPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _brandController;
  late final TextEditingController _ingredientsController;
  late final TextEditingController _notesController;
  late final TextEditingController _imageUrlController;

  late String _selectedCategory;
  double? _rating;
  DateTime? _purchaseDate;
  DateTime? _expiryDate;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    final product = widget.product;
    _nameController = TextEditingController(text: product?.name);
    _brandController = TextEditingController(text: product?.brand);
    _ingredientsController = TextEditingController(text: product?.ingredients);
    _notesController = TextEditingController(text: product?.notes);
    _imageUrlController = TextEditingController(text: product?.imageUrl);
    _selectedCategory = product?.category ?? productCategories.first;
    _rating = product?.rating;
    _purchaseDate = product?.purchaseDate;
    _expiryDate = product?.expiryDate;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _ingredientsController.dispose();
    _notesController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final notifier = ref.read(productsProvider.notifier);

      if (widget.isEditing) {
        await notifier.updateProduct(
          widget.product!.copyWith(
            name: _nameController.text.trim(),
            brand: Value(_brandController.text.trim().nullIfEmpty),
            category: _selectedCategory,
            ingredients: Value(_ingredientsController.text.trim().nullIfEmpty),
            rating: Value(_rating),
            notes: Value(_notesController.text.trim().nullIfEmpty),
            imageUrl: Value(_imageUrlController.text.trim().nullIfEmpty),
            purchaseDate: Value(_purchaseDate),
            expiryDate: Value(_expiryDate),
            updatedAt: DateTime.now(),
          ),
        );
      } else {
        await notifier.addProduct(
          name: _nameController.text.trim(),
          category: _selectedCategory,
          brand: _brandController.text.trim().nullIfEmpty,
          ingredients: _ingredientsController.text.trim().nullIfEmpty,
          rating: _rating,
          notes: _notesController.text.trim().nullIfEmpty,
          imageUrl: _imageUrlController.text.trim().nullIfEmpty,
          purchaseDate: _purchaseDate,
          expiryDate: _expiryDate,
        );
      }

      if (mounted) {
        Navigator.pop(context);
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  Future<void> _selectDate({required bool isPurchaseDate}) async {
    final initialDate = isPurchaseDate
        ? _purchaseDate
        : _expiryDate ?? DateTime.now();

    final date = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      setState(() {
        if (isPurchaseDate) {
          _purchaseDate = date;
        } else {
          _expiryDate = date;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isEditing ? l10n.editProductTitle : l10n.addProductTitle,
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Name field
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: l10n.productNameLabel,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.label_outline),
              ),
              textCapitalization: TextCapitalization.words,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.productNameRequired;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Brand field
            TextFormField(
              controller: _brandController,
              decoration: InputDecoration(
                labelText: l10n.productBrandLabel,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.business_outlined),
              ),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 16),

            // Category dropdown
            DropdownButtonFormField<String>(
              initialValue: _selectedCategory,
              decoration: InputDecoration(
                labelText: l10n.productCategoryLabel,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.category_outlined),
              ),
              items: productCategories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(_formatCategory(category)),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedCategory = value);
                }
              },
            ),
            const SizedBox(height: 16),

            // Rating slider
            Text(l10n.productRatingLabel, style: theme.textTheme.bodyMedium),
            Slider(
              value: _rating ?? 0,
              max: 5,
              divisions: 10,
              label: _rating?.toStringAsFixed(1) ?? 'Not rated',
              onChanged: (value) {
                setState(() => _rating = value == 0 ? null : value);
              },
            ),
            const SizedBox(height: 16),

            // Ingredients field
            TextFormField(
              controller: _ingredientsController,
              decoration: InputDecoration(
                labelText: l10n.productIngredientsLabel,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.science_outlined),
                helperText: l10n.productIngredientsHint,
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),

            // Notes field
            TextFormField(
              controller: _notesController,
              decoration: InputDecoration(
                labelText: l10n.productNotesLabel,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.notes_outlined),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),

            // Image URL field
            TextFormField(
              controller: _imageUrlController,
              decoration: InputDecoration(
                labelText: l10n.productImageUrlLabel,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.image_outlined),
              ),
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 16),

            // Date pickers
            Row(
              children: [
                Expanded(
                  child: _DatePickerField(
                    label: l10n.productPurchaseDateLabel,
                    date: _purchaseDate,
                    onTap: () => _selectDate(isPurchaseDate: true),
                    onClear: () => setState(() => _purchaseDate = null),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _DatePickerField(
                    label: l10n.productExpiryDateLabel,
                    date: _expiryDate,
                    onTap: () => _selectDate(isPurchaseDate: false),
                    onClear: () => setState(() => _expiryDate = null),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Submit button
            FilledButton(
              onPressed: _isSubmitting ? null : _submit,
              child: _isSubmitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(widget.isEditing ? l10n.saveButton : l10n.addButton),
            ),
          ],
        ),
      ),
    );
  }

  String _formatCategory(String category) {
    return category
        .replaceAll('_', ' ')
        .split(' ')
        .map((word) {
          if (word.isEmpty) return word;
          return word[0].toUpperCase() + word.substring(1);
        })
        .join(' ');
  }
}

class _DatePickerField extends StatelessWidget {
  const _DatePickerField({
    required this.label,
    required this.date,
    required this.onTap,
    required this.onClear,
  });

  final String label;
  final DateTime? date;
  final VoidCallback onTap;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: date != null
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: onClear,
                )
              : const Icon(Icons.calendar_today_outlined),
        ),
        child: Text(
          date != null ? '${date!.day}/${date!.month}/${date!.year}' : '',
        ),
      ),
    );
  }
}

extension on String {
  String? get nullIfEmpty => isEmpty ? null : this;
}
