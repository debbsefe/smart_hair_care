import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_hair_care/core/database/daos/products_dao.dart';
import 'package:smart_hair_care/core/database/database.dart';

/// Notifier for managing products (Riverpod 3 AsyncNotifier)
class ProductsNotifier extends AsyncNotifier<List<Product>> {
  ProductsDao get _dao => ref.watch(productsDaoProvider);

  @override
  Future<List<Product>> build() async {
    final dao = ref.watch(productsDaoProvider);
    return dao.getAllProducts();
  }

  Future<void> addProduct({
    required String name,
    required String category,
    String? brand,
    String? ingredients,
    double? rating,
    String? notes,
    String? imageUrl,
    DateTime? purchaseDate,
    DateTime? expiryDate,
  }) async {
    await _dao.insertProduct(
      ProductsCompanion(
        name: Value(name),
        category: Value(category),
        brand: Value(brand),
        ingredients: Value(ingredients),
        rating: Value(rating),
        notes: Value(notes),
        imageUrl: Value(imageUrl),
        purchaseDate: Value(purchaseDate),
        expiryDate: Value(expiryDate),
      ),
    );
    ref.invalidateSelf();
  }

  Future<void> updateProduct(Product product) async {
    await _dao.updateProduct(product);
    ref.invalidateSelf();
  }

  Future<void> deleteProduct(int id) async {
    await _dao.deleteProduct(id);
    ref.invalidateSelf();
  }

  Future<void> toggleFavorite(int id, {required bool isFavorite}) async {
    await _dao.toggleFavorite(id, isFavorite: isFavorite);
    ref.invalidateSelf();
  }

  Future<List<Product>> searchProducts(String query) async {
    return _dao.searchProducts(query);
  }
}

/// Provider for products
final productsProvider = AsyncNotifierProvider<ProductsNotifier, List<Product>>(
  ProductsNotifier.new,
);

/// Provider for a single product by ID
final productByIdProvider = FutureProvider.family<Product?, int>((
  ref,
  id,
) async {
  final dao = ref.watch(productsDaoProvider);
  return dao.getProductById(id);
});

/// Provider for products filtered by category
final productsByCategoryProvider = FutureProvider.family<List<Product>, String>(
  (ref, category) async {
    final dao = ref.watch(productsDaoProvider);
    return dao.getProductsByCategory(category);
  },
);

/// Provider for favorite products
final favoriteProductsProvider = Provider<List<Product>>((ref) {
  final productsAsync = ref.watch(productsProvider);
  return productsAsync.when(
    data: (products) => products.where((p) => p.isFavorite).toList(),
    loading: () => [],
    error: (_, _) => [],
  );
});
