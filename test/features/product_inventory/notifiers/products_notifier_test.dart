import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smart_hair_care/core/database/database.dart';
import 'package:smart_hair_care/features/product_inventory/notifiers/products_notifier.dart';

import '../../../fixtures/fixtures.dart';

void main() {
  late MockProductsDao mockDao;
  late ProviderContainer container;

  setUpAll(registerFallbackValues);

  setUp(() {
    mockDao = MockProductsDao();
    container = ProviderContainer(
      overrides: [
        productsDaoProvider.overrideWithValue(mockDao),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('ProductsNotifier', () {
    test('initial state is loading', () {
      when(() => mockDao.getAllProducts()).thenAnswer((_) async => []);

      final state = container.read(productsProvider);

      expect(state.isLoading, isTrue);
    });

    test('loads products successfully', () async {
      final products = ProductFixtures.sampleProducts();
      when(() => mockDao.getAllProducts()).thenAnswer((_) async => products);

      // Wait for the future to complete
      final result = await container.read(productsProvider.future);

      expect(result, equals(products));
    });

    test('handles load error', () async {
      when(
        () => mockDao.getAllProducts(),
      ).thenThrow(Exception('Database error'));

      // Trigger the provider and wait a bit for error state
      container.read(productsProvider);
      await Future<void>.delayed(const Duration(milliseconds: 100));

      final state = container.read(productsProvider);
      expect(state.hasError, isTrue);
    });

    test('adds product successfully', () async {
      when(() => mockDao.getAllProducts()).thenAnswer((_) async => []);
      when(() => mockDao.insertProduct(any())).thenAnswer((_) async => 1);

      // Wait for initial load
      await container.read(productsProvider.future);

      await container
          .read(productsProvider.notifier)
          .addProduct(
            name: 'New Product',
            category: 'shampoo',
            brand: 'TestBrand',
          );

      verify(() => mockDao.insertProduct(any())).called(1);
    });

    test('updates product successfully', () async {
      final products = ProductFixtures.sampleProducts();
      when(() => mockDao.getAllProducts()).thenAnswer((_) async => products);
      when(
        () => mockDao.updateProduct(any()),
      ).thenAnswer((_) async => true);

      await container.read(productsProvider.future);

      final updatedProduct = products.first.copyWith(name: 'Updated Name');
      await container
          .read(productsProvider.notifier)
          .updateProduct(
            updatedProduct,
          );

      verify(() => mockDao.updateProduct(any())).called(1);
    });

    test('deletes product successfully', () async {
      when(() => mockDao.getAllProducts()).thenAnswer((_) async => []);
      when(() => mockDao.deleteProduct(any())).thenAnswer((_) async => 1);

      await container.read(productsProvider.future);

      await container.read(productsProvider.notifier).deleteProduct(1);

      verify(() => mockDao.deleteProduct(1)).called(1);
    });

    test('toggles favorite successfully', () async {
      final products = ProductFixtures.sampleProducts();
      when(() => mockDao.getAllProducts()).thenAnswer((_) async => products);
      when(
        () => mockDao.toggleFavorite(
          any(),
          isFavorite: any(named: 'isFavorite'),
        ),
      ).thenAnswer((_) async => 1);

      await container.read(productsProvider.future);

      await container
          .read(productsProvider.notifier)
          .toggleFavorite(
            products.first.id,
            isFavorite: true,
          );

      verify(
        () => mockDao.toggleFavorite(
          any(),
          isFavorite: any(named: 'isFavorite'),
        ),
      ).called(1);
    });
  });

  group('Derived Providers', () {
    test('favoriteProductsProvider filters favorites', () async {
      final products = ProductFixtures.sampleProducts();
      when(() => mockDao.getAllProducts()).thenAnswer((_) async => products);

      await container.read(productsProvider.future);

      final favorites = container.read(favoriteProductsProvider);
      expect(favorites.where((p) => p.isFavorite).length, equals(1));
    });
  });
}
