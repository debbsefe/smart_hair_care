import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hair_care/core/database/daos/products_dao.dart';
import 'package:smart_hair_care/core/database/database.dart';

void main() {
  late AppDatabase db;
  late ProductsDao dao;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    dao = ProductsDao(db);
  });

  tearDown(() async {
    await db.close();
  });

  ProductsCompanion createTestProduct({
    String name = 'Test Shampoo',
    String category = 'shampoo',
    String? brand,
  }) {
    return ProductsCompanion.insert(
      name: name,
      category: category,
    );
  }

  group('ProductsDao', () {
    test('insertProduct returns new id', () async {
      final id = await dao.insertProduct(createTestProduct());

      expect(id, isPositive);
    });

    test('getAllProducts returns empty list initially', () async {
      final products = await dao.getAllProducts();

      expect(products, isEmpty);
    });

    test('getAllProducts returns inserted products', () async {
      await dao.insertProduct(createTestProduct(name: 'Shampoo'));
      await dao.insertProduct(
        createTestProduct(name: 'Conditioner', category: 'conditioner'),
      );

      final products = await dao.getAllProducts();

      expect(products.length, 2);
    });

    test('getProductById returns product when exists', () async {
      final id = await dao.insertProduct(createTestProduct(name: 'My Shampoo'));

      final product = await dao.getProductById(id);

      expect(product, isNotNull);
      expect(product!.name, 'My Shampoo');
    });

    test('getProductById returns null when not exists', () async {
      final product = await dao.getProductById(999);

      expect(product, isNull);
    });

    test('getProductsByCategory returns filtered products', () async {
      await dao.insertProduct(createTestProduct());
      await dao.insertProduct(createTestProduct(category: 'conditioner'));
      await dao.insertProduct(createTestProduct());

      final shampoos = await dao.getProductsByCategory('shampoo');

      expect(shampoos.length, 2);
      expect(shampoos.every((p) => p.category == 'shampoo'), isTrue);
    });

    test('getFavoriteProducts returns only favorites', () async {
      final id = await dao.insertProduct(createTestProduct());
      await dao.toggleFavorite(id, isFavorite: true);
      await dao.insertProduct(createTestProduct(name: 'Not favorite'));

      final favorites = await dao.getFavoriteProducts();

      expect(favorites.length, 1);
    });

    test('searchProducts finds by name', () async {
      await dao.insertProduct(createTestProduct(name: 'Curl Defining'));
      await dao.insertProduct(createTestProduct(name: 'Something Else'));

      final results = await dao.searchProducts('Curl');

      expect(results.length, 1);
      expect(results.first.name, 'Curl Defining');
    });

    test('updateProduct modifies product', () async {
      final id = await dao.insertProduct(createTestProduct(name: 'Original'));
      final product = await dao.getProductById(id);

      final updated = product!.copyWith(name: 'Updated');
      await dao.updateProduct(updated);

      final result = await dao.getProductById(id);
      expect(result!.name, 'Updated');
    });

    test('toggleFavorite changes favorite status', () async {
      final id = await dao.insertProduct(createTestProduct());

      await dao.toggleFavorite(id, isFavorite: true);

      final product = await dao.getProductById(id);
      expect(product!.isFavorite, isTrue);
    });

    test('deleteProduct removes product', () async {
      final id = await dao.insertProduct(createTestProduct());

      await dao.deleteProduct(id);

      final product = await dao.getProductById(id);
      expect(product, isNull);
    });

    test('deleteAllProducts removes all products', () async {
      await dao.insertProduct(createTestProduct());
      await dao.insertProduct(createTestProduct(name: 'Another'));

      await dao.deleteAllProducts();

      final products = await dao.getAllProducts();
      expect(products, isEmpty);
    });

    test('watchAllProducts streams updates', () async {
      final stream = dao.watchAllProducts();

      final firstEmission = await stream.first;
      expect(firstEmission, isEmpty);

      await dao.insertProduct(createTestProduct());

      final secondEmission = await stream.first;
      expect(secondEmission.length, 1);
    });
  });
}
