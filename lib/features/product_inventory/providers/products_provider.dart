import 'dart:async';

import 'package:drift/drift.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_hair_care/core/database/daos/products_dao.dart';
import 'package:smart_hair_care/core/database/database.dart';

/// State class for products list
class ProductsState extends Equatable {
  const ProductsState({
    this.products = const [],
    this.isLoading = false,
    this.error,
  });

  final List<Product> products;
  final bool isLoading;
  final String? error;

  @override
  List<Object?> get props => [products, isLoading, error];

  ProductsState copyWith({
    List<Product>? products,
    bool? isLoading,
    String? error,
  }) {
    return ProductsState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Notifier for managing products state (Riverpod 3)
class ProductsNotifier extends Notifier<ProductsState> {
  late final ProductsDao _dao;

  @override
  ProductsState build() {
    _dao = ref.watch(productsDaoProvider);
    // Defer loading to avoid reading state during build
    unawaited(Future.microtask(_loadProducts));
    return const ProductsState(isLoading: true);
  }

  Future<void> _loadProducts() async {
    state = state.copyWith(isLoading: true);
    try {
      final products = await _dao.getAllProducts();
      state = state.copyWith(products: products, isLoading: false);
    } on Exception catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> loadProducts() => _loadProducts();

  /// Clears any error state
  void clearError() {
    if (state.error != null) {
      // ignore: avoid_redundant_argument_values, null clears existing error
      state = state.copyWith(error: null);
    }
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
    try {
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
      await _loadProducts();
    } on Exception catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> updateProduct(Product product) async {
    try {
      await _dao.updateProduct(product);
      await _loadProducts();
    } on Exception catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      await _dao.deleteProduct(id);
      await _loadProducts();
    } on Exception catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> toggleFavorite(int id, {required bool isFavorite}) async {
    try {
      await _dao.toggleFavorite(id, isFavorite: isFavorite);
      await _loadProducts();
    } on Exception catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<List<Product>> searchProducts(String query) async {
    return _dao.searchProducts(query);
  }
}

/// Provider for products state
final productsProvider = NotifierProvider<ProductsNotifier, ProductsState>(
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
  final state = ref.watch(productsProvider);
  return state.products.where((p) => p.isFavorite).toList();
});
