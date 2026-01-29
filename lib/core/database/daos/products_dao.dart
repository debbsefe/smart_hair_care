import 'package:drift/drift.dart';
import 'package:smart_hair_care/core/database/database.dart';
import 'package:smart_hair_care/core/database/tables/products_table.dart';

part 'products_dao.g.dart';

/// Data Access Object for Products table
@DriftAccessor(tables: [Products])
class ProductsDao extends DatabaseAccessor<AppDatabase>
    with _$ProductsDaoMixin {
  ProductsDao(super.attachedDatabase);

  // Read operations
  Future<List<Product>> getAllProducts() => select(products).get();

  Stream<List<Product>> watchAllProducts() => select(products).watch();

  Future<Product?> getProductById(int id) =>
      (select(products)..where((p) => p.id.equals(id))).getSingleOrNull();

  Future<List<Product>> getProductsByCategory(String category) =>
      (select(products)..where((p) => p.category.equals(category))).get();

  Future<List<Product>> getFavoriteProducts() =>
      (select(products)..where((p) => p.isFavorite.equals(true))).get();

  Future<List<Product>> searchProducts(String query) => (select(
    products,
  )..where((p) => p.name.like('%$query%') | p.brand.like('%$query%'))).get();

  // Create operations
  Future<int> insertProduct(ProductsCompanion product) =>
      into(products).insert(product);

  Future<void> insertProducts(List<ProductsCompanion> productList) =>
      batch((batch) => batch.insertAll(products, productList));

  // Update operations
  Future<bool> updateProduct(Product product) =>
      update(products).replace(product);

  Future<int> toggleFavorite(int id, {required bool isFavorite}) =>
      (update(products)..where((p) => p.id.equals(id))).write(
        ProductsCompanion(isFavorite: Value(isFavorite)),
      );

  // Delete operations
  Future<int> deleteProduct(int id) =>
      (delete(products)..where((p) => p.id.equals(id))).go();

  Future<int> deleteAllProducts() => delete(products).go();
}
