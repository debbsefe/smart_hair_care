import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smart_hair_care/core/database/database.dart';
import 'package:smart_hair_care/features/product_inventory/providers/products_provider.dart';

import '../../../helpers/helpers.dart';

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
      expect(state.products, isEmpty);
      expect(state.error, isNull);
    });

    test('loads products successfully', () async {
      final products = ProductFixtures.sampleProducts();
      when(() => mockDao.getAllProducts()).thenAnswer((_) async => products);

      container.read(productsProvider);
      await Future<void>.delayed(const Duration(milliseconds: 100));

      final state = container.read(productsProvider);
      expect(state.isLoading, isFalse);
      expect(state.products, equals(products));
      expect(state.error, isNull);
    });

    test('handles load error', () async {
      when(() => mockDao.getAllProducts())
          .thenThrow(Exception('Database error'));

      container.read(productsProvider);
      await Future<void>.delayed(const Duration(milliseconds: 100));

      final state = container.read(productsProvider);
      expect(state.isLoading, isFalse);
      expect(state.error, isNotNull);
    });

    test('adds product successfully', () async {
      when(() => mockDao.getAllProducts()).thenAnswer((_) async => []);
      when(() => mockDao.insertProduct(any())).thenAnswer((_) async => 1);

      container.read(productsProvider);
      await Future<void>.delayed(const Duration(milliseconds: 100));

      await container.read(productsProvider.notifier).addProduct(
            name: 'New Product',
            category: 'shampoo',
            brand: 'TestBrand',
          );

      verify(() => mockDao.insertProduct(any())).called(1);
      verify(() => mockDao.getAllProducts()).called(greaterThanOrEqualTo(2));
    });

    test('deletes product successfully', () async {
      final product = ProductFixtures.shampoo();
      when(() => mockDao.getAllProducts()).thenAnswer((_) async => [product]);
      when(() => mockDao.deleteProduct(product.id)).thenAnswer((_) async => 1);

      container.read(productsProvider);
      await Future<void>.delayed(const Duration(milliseconds: 100));

      await container.read(productsProvider.notifier).deleteProduct(product.id);

      verify(() => mockDao.deleteProduct(product.id)).called(1);
    });

    test('toggles favorite successfully', () async {
      final product = ProductFixtures.shampoo();
      when(() => mockDao.getAllProducts()).thenAnswer((_) async => [product]);
      when(() => mockDao.toggleFavorite(product.id, isFavorite: true))
          .thenAnswer((_) async => 1);

      container.read(productsProvider);
      await Future<void>.delayed(const Duration(milliseconds: 100));

      await container
          .read(productsProvider.notifier)
          .toggleFavorite(product.id, isFavorite: true);

      verify(() => mockDao.toggleFavorite(product.id, isFavorite: true))
          .called(1);
    });

    test('clearError clears error state', () async {
      when(() => mockDao.getAllProducts())
          .thenThrow(Exception('Database error'));

      container.read(productsProvider);
      await Future<void>.delayed(const Duration(milliseconds: 100));

      expect(container.read(productsProvider).error, isNotNull);

      container.read(productsProvider.notifier).clearError();

      expect(container.read(productsProvider).error, isNull);
    });
  });

  group('ProductsState', () {
    test('copyWith creates new state with updated values', () {
      const state = ProductsState();
      final newState = state.copyWith(isLoading: true);

      expect(newState.isLoading, isTrue);
      expect(state.isLoading, isFalse);
    });

    test('equality works correctly', () {
      const state1 = ProductsState();
      const state2 = ProductsState();

      expect(state1, equals(state2));
    });
  });

  group('favoriteProductsProvider', () {
    test('returns only favorite products', () async {
      final products = ProductFixtures.sampleProducts();
      when(() => mockDao.getAllProducts()).thenAnswer((_) async => products);

      container.read(productsProvider);
      await Future<void>.delayed(const Duration(milliseconds: 100));

      final favorites = container.read(favoriteProductsProvider);
      expect(favorites.every((p) => p.isFavorite), isTrue);
    });
  });
}
