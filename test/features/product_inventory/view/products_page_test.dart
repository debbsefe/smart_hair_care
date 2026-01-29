import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smart_hair_care/core/database/database.dart';
import 'package:smart_hair_care/features/product_inventory/view/products_page.dart';

import '../../../helpers/helpers.dart';

void main() {
  late MockProductsDao mockDao;

  setUp(() {
    mockDao = MockProductsDao();
  });

  group('ProductsPage', () {
    testWidgets('shows empty state when no products', (tester) async {
      when(() => mockDao.getAllProducts()).thenAnswer((_) async => []);

      await tester.pumpApp(
        const ProductsPage(),
        overrides: [productsDaoProvider.overrideWithValue(mockDao)],
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.inventory_2_outlined), findsOneWidget);
      expect(find.text('No products yet'), findsOneWidget);
    });

    testWidgets('shows product list when products exist', (tester) async {
      final products = ProductFixtures.sampleProducts();
      when(() => mockDao.getAllProducts()).thenAnswer((_) async => products);

      await tester.pumpApp(
        const ProductsPage(),
        overrides: [productsDaoProvider.overrideWithValue(mockDao)],
      );
      await tester.pumpAndSettle();

      expect(find.text('Curl Defining Shampoo'), findsOneWidget);
      expect(find.text('Deep Moisture Conditioner'), findsOneWidget);
      expect(find.text('Curl Cream'), findsOneWidget);
    });

    testWidgets('has floating action button', (tester) async {
      when(() => mockDao.getAllProducts()).thenAnswer((_) async => []);

      await tester.pumpApp(
        const ProductsPage(),
        overrides: [productsDaoProvider.overrideWithValue(mockDao)],
      );
      await tester.pumpAndSettle();

      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('shows app bar with title', (tester) async {
      when(() => mockDao.getAllProducts()).thenAnswer((_) async => []);

      await tester.pumpApp(
        const ProductsPage(),
        overrides: [productsDaoProvider.overrideWithValue(mockDao)],
      );
      await tester.pumpAndSettle();

      expect(find.text('My Products'), findsOneWidget);
    });

    testWidgets('shows product brand when available', (tester) async {
      final products = [ProductFixtures.shampoo()];
      when(() => mockDao.getAllProducts()).thenAnswer((_) async => products);

      await tester.pumpApp(
        const ProductsPage(),
        overrides: [productsDaoProvider.overrideWithValue(mockDao)],
      );
      await tester.pumpAndSettle();

      expect(find.text('SheaMoisture'), findsOneWidget);
    });

    testWidgets('shows favorite icon for favorite products', (tester) async {
      final products = [ProductFixtures.conditioner()]; // isFavorite: true
      when(() => mockDao.getAllProducts()).thenAnswer((_) async => products);

      await tester.pumpApp(
        const ProductsPage(),
        overrides: [productsDaoProvider.overrideWithValue(mockDao)],
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.favorite), findsOneWidget);
    });
  });
}
