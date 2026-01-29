import 'package:flutter/material.dart';
import 'package:smart_hair_care/app/theme/app_theme.dart';
import 'package:smart_hair_care/features/home/home.dart';
import 'package:smart_hair_care/l10n/l10n.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Hair Care',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const HomePage(),
    );
  }
}
