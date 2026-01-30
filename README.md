# Smart Hair Care 💇‍♀️

![coverage][coverage_badge]
[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![License: MIT][license_badge]][license_link]

A comprehensive hair care companion app to help you track products, log daily routines, understand your hair profile, and run experiments to discover what works best for your hair.

---

## Features ✨

### 📦 Product Inventory
- Track all your hair care products in one place
- Store product details: brand, category, ingredients, purchase/expiry dates
- Rate products and add notes about your experience
- Quick access to find the right product for your routine

### 📝 Daily Log
- Calendar-based logging system for your hair care routines
- Track routine type (wash day, refresh, deep conditioning, protein treatment, scalp care, protective styling)
- Record hair condition, weather, and humidity
- Note products used and techniques applied
- Build a history to identify patterns

### 👤 Hair Profile
- Guided setup wizard to define your hair characteristics
- Hair type classification (1A through 4C)
- Porosity, density, thickness, and scalp type assessment
- Track treatments (color-treated, heat-damaged)
- Document concerns and goals for targeted care

### 🧪 Experiments
- Scientific approach to finding what works
- Create experiments with hypotheses and methods
- Track variables and record observations over time
- Mark experiments as active, completed, or abandoned
- Rate success and document conclusions

---

## Architecture 🏗️

This app follows a **feature-first architecture** with clean separation of concerns:

```
lib/
├── app/                    # App entry point and configuration
├── bootstrap.dart          # App initialization with Riverpod
├── database/               # Drift SQLite database layer
│   ├── daos/              # Data Access Objects for each table
│   └── tables/            # Table definitions
├── features/              # Feature modules
│   ├── product_inventory/ # Products feature
│   ├── daily_log/         # Daily logging feature
│   ├── hair_profile/      # Hair bio/profile feature
│   ├── experiments/       # Experiments feature
│   └── home/              # Home navigation
└── l10n/                  # Localization (EN, ES)
```

### Tech Stack

- **State Management**: [Riverpod](https://riverpod.dev/) - Reactive caching and dependency injection
- **Database**: [Drift](https://drift.simonbinder.eu/) - Type-safe SQLite with compile-time verification
- **Navigation**: Navigator 1.0 with static `getRoute()` methods for each page
- **Theming**: Material 3 with custom purple/mauve color scheme
- **Localization**: flutter_localizations with ARB files (English)
- **Code Quality**: [very_good_analysis](https://pub.dev/packages/very_good_analysis) lint rules

---

## Getting Started 🚀

### Prerequisites

- Flutter SDK (see `pubspec.yaml` for version)
- Dart SDK (see `pubspec.yaml` for version)

### Setup

1. **Clone the repository**
```sh
git clone <repository-url>
cd smart_hair_care
```

2. **Install dependencies**
```sh
flutter pub get
```

3. **Run code generation** (required for Drift database)
```sh
dart run build_runner build --delete-conflicting-outputs
```

4. **Run the app**

This project contains 3 flavors:

- development
- staging
- production

To run the desired flavor either use the launch configuration in VSCode/Android Studio or use the following commands:

```sh
# Development
flutter run --flavor development --target lib/main_development.dart

# Staging
flutter run --flavor staging --target lib/main_staging.dart

# Production
flutter run --flavor production --target lib/main_production.dart
```

_\*Smart Hair Care works on iOS, Android, Web, and Windows._

---

## Running Tests 🧪

To run all unit and widget tests use the following command:

```sh
very_good test --coverage --test-randomize-ordering-seed random
```

To view the generated coverage report you can use [lcov](https://github.com/linux-test-project/lcov).

```sh
# Generate Coverage Report
genhtml coverage/lcov.info -o coverage/

# Open Coverage Report
open coverage/index.html
```

---

## Working with Translations 🌐

This project relies on [flutter_localizations][flutter_localizations_link] and follows the [official internationalization guide for Flutter][internationalization_link].

### Supported Locales

- 🇺🇸 English (en)

### Adding Strings

1. Open the `app_en.arb` file at `lib/l10n/arb/app_en.arb`
2. Add a new key/value pair
3. Use in code:

```dart
import 'package:smart_hair_care/l10n/l10n.dart';

@override
Widget build(BuildContext context) {
  final l10n = context.l10n;
  return Text(l10n.productsTitle);
}
```

### Generating Translations

To use the latest translations changes:

```sh
flutter gen-l10n --arb-dir="lib/l10n/arb"
```

Alternatively, run `flutter run` and code generation will take place automatically.

---

## Database Schema 📊

The app uses Drift SQLite with the following tables:

| Table | Description |
|-------|-------------|
| `products` | Hair care product inventory |
| `daily_logs` | Daily hair care routine entries |
| `hair_profiles` | User's hair characteristics |
| `experiments` | Hair care experiments |

---

## Contributing 🤝

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## License 📄

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

[coverage_badge]: coverage_badge.svg
[flutter_localizations_link]: https://api.flutter.dev/flutter/flutter_localizations/flutter_localizations-library.html
[internationalization_link]: https://flutter.dev/docs/development/accessibility-and-localization/internationalization
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
[very_good_cli_link]: https://github.com/VeryGoodOpenSource/very_good_cli
