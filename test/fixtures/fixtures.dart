import 'package:mocktail/mocktail.dart';
import 'package:smart_hair_care/core/database/daos/daily_logs_dao.dart';
import 'package:smart_hair_care/core/database/daos/hair_profiles_dao.dart';
import 'package:smart_hair_care/core/database/daos/products_dao.dart';
import 'package:smart_hair_care/core/database/database.dart';

// Mock DAO classes
class MockProductsDao extends Mock implements ProductsDao {}

class MockDailyLogsDao extends Mock implements DailyLogsDao {}

class MockHairProfilesDao extends Mock implements HairProfilesDao {}

// Fake classes for mocktail fallback values
class FakeProductsCompanion extends Fake implements ProductsCompanion {}

class FakeDailyLogsCompanion extends Fake implements DailyLogsCompanion {}

class FakeHairProfilesCompanion extends Fake implements HairProfilesCompanion {}

class FakeProduct extends Fake implements Product {}

class FakeDailyLog extends Fake implements DailyLog {}

class FakeHairProfile extends Fake implements HairProfile {}

/// Register fallback values for mocktail
void registerFallbackValues() {
  registerFallbackValue(FakeProductsCompanion());
  registerFallbackValue(FakeDailyLogsCompanion());
  registerFallbackValue(FakeHairProfilesCompanion());
  registerFallbackValue(FakeProduct());
  registerFallbackValue(FakeDailyLog());
  registerFallbackValue(FakeHairProfile());
  registerFallbackValue(DateTime.now());
}

/// Test fixtures for Product entity
class ProductFixtures {
  static final _baseDate = DateTime(2026);

  static Product shampoo() => Product(
    id: 1,
    name: 'Curl Defining Shampoo',
    brand: 'SheaMoisture',
    category: 'shampoo',
    isFavorite: false,
    createdAt: _baseDate,
    updatedAt: _baseDate,
  );

  static Product conditioner() => Product(
    id: 2,
    name: 'Deep Moisture Conditioner',
    brand: 'DevaCurl',
    category: 'conditioner',
    isFavorite: true,
    createdAt: _baseDate.add(const Duration(days: 1)),
    updatedAt: _baseDate.add(const Duration(days: 1)),
  );

  static Product stylingProduct() => Product(
    id: 3,
    name: 'Curl Cream',
    brand: 'Cantu',
    category: 'styling',
    isFavorite: false,
    createdAt: _baseDate.add(const Duration(days: 2)),
    updatedAt: _baseDate.add(const Duration(days: 2)),
  );

  static List<Product> sampleProducts() => [
    shampoo(),
    conditioner(),
    stylingProduct(),
  ];
}

/// Test fixtures for DailyLog entity
class DailyLogFixtures {
  static DateTime get today => DateTime.now();
  static DateTime get yesterday => today.subtract(const Duration(days: 1));

  static DailyLog washDay() => DailyLog(
    id: 1,
    date: today,
    routineType: 'wash_day',
    productsUsed: '1,2',
    techniques: 'Squish to condish',
    hairLength: 25,
    createdAt: today,
  );

  static DailyLog refreshDay() => DailyLog(
    id: 2,
    date: yesterday,
    routineType: 'refresh_day',
    productsUsed: '3',
    createdAt: yesterday,
  );

  static List<DailyLog> sampleLogs() => [washDay(), refreshDay()];
}

/// Test fixtures for HairProfile entity
class HairProfileFixtures {
  static final _baseDate = DateTime(2026);

  static HairProfile curlyProfile() => HairProfile(
    id: 1,
    name: 'My Curly Hair',
    primaryType: 'curly',
    specificPatterns: const ['3B'],
    isMultiTextured: false,
    porosity: 'high',
    density: 'medium',
    isColorTreated: false,
    isHeatDamaged: false,
    lastUpdated: _baseDate,
  );
}
