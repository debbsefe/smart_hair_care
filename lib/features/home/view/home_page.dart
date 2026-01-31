import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_hair_care/features/daily_log/daily_log.dart';
import 'package:smart_hair_care/features/hair_profile/hair_profile.dart';
import 'package:smart_hair_care/features/product_inventory/product_inventory.dart';
import 'package:smart_hair_care/l10n/l10n.dart';

/// Notifier for bottom navigation index (Riverpod 3)
class BottomNavIndexNotifier extends Notifier<int> {
  @override
  int build() => 0;

  // ignore: use_setters_to_change_properties, method name matches Riverpod convention
  void setIndex(int index) => state = index;
}

/// Provider to track the current bottom navigation index
final bottomNavIndexProvider = NotifierProvider<BottomNavIndexNotifier, int>(
  BottomNavIndexNotifier.new,
);

/// Home page with bottom navigation connecting all features
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  /// Returns a [MaterialPageRoute] for Navigator 1.0 navigation
  static Route<void> getRoute() {
    return MaterialPageRoute<void>(
      builder: (_) => const HomePage(),
      settings: const RouteSettings(name: '/'),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavIndexProvider);
    final l10n = context.l10n;

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: const [
          ProductsPage(),
          DailyLogPage(),
          HairProfilePage(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          ref.read(bottomNavIndexProvider.notifier).setIndex(index);
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.inventory_2_outlined),
            selectedIcon: const Icon(Icons.inventory_2),
            label: l10n.navProducts,
          ),
          NavigationDestination(
            icon: const Icon(Icons.calendar_today_outlined),
            selectedIcon: const Icon(Icons.calendar_today),
            label: l10n.navDailyLog,
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon: const Icon(Icons.person),
            label: l10n.navProfile,
          ),
        ],
      ),
    );
  }
}
