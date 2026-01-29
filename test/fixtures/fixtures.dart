import 'package:mocktail/mocktail.dart';
import 'package:smart_hair_care/core/database/daos/daily_logs_dao.dart';
import 'package:smart_hair_care/core/database/daos/experiments_dao.dart';
import 'package:smart_hair_care/core/database/daos/hair_profiles_dao.dart';
import 'package:smart_hair_care/core/database/daos/products_dao.dart';
import 'package:smart_hair_care/core/database/database.dart';

// Mock DAO classes
class MockProductsDao extends Mock implements ProductsDao {}

class MockDailyLogsDao extends Mock implements DailyLogsDao {}

class MockHairProfilesDao extends Mock implements HairProfilesDao {}

class MockExperimentsDao extends Mock implements ExperimentsDao {}

// Fake classes for mocktail fallback values
class FakeProductsCompanion extends Fake implements ProductsCompanion {}

class FakeDailyLogsCompanion extends Fake implements DailyLogsCompanion {}

class FakeHairProfilesCompanion extends Fake implements HairProfilesCompanion {}

class FakeExperimentsCompanion extends Fake implements ExperimentsCompanion {}

/// Register fallback values for mocktail
void registerFallbackValues() {
  registerFallbackValue(FakeProductsCompanion());
  registerFallbackValue(FakeDailyLogsCompanion());
  registerFallbackValue(FakeHairProfilesCompanion());
  registerFallbackValue(FakeExperimentsCompanion());
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
        hairType: '3b',
        porosity: 'high',
        density: 'medium',
        isColorTreated: false,
        isHeatDamaged: false,
        lastUpdated: _baseDate,
      );
}

/// Test fixtures for Experiment entity
class ExperimentFixtures {
  static Experiment activeExperiment() => Experiment(
        id: 1,
        name: 'Protein vs Moisture Balance',
        hypothesis: 'More protein will reduce frizz',
        startDate: DateTime(2026),
        status: 'active',
        createdAt: DateTime(2026),
      );

  static Experiment completedExperiment() => Experiment(
        id: 2,
        name: 'Deep Conditioning Frequency',
        hypothesis: 'Weekly deep conditioning improves curl definition',
        startDate: DateTime(2025, 12),
        endDate: DateTime(2025, 12, 31),
        status: 'completed',
        results: 'Curl definition improved significantly',
        conclusion: 'Weekly deep conditioning is optimal',
        successRating: 4,
        createdAt: DateTime(2025, 12),
      );

  static List<Experiment> sampleExperiments() => [
        activeExperiment(),
        completedExperiment(),
      ];
}
