import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_hair_care/l10n/l10n.dart';

extension PumpApp on WidgetTester {
  /// Pump a widget with Riverpod ProviderScope and localization.
  ///
  /// [overrides] accepts provider overrides like:
  /// ```dart
  /// await tester.pumpApp(
  ///   MyWidget(),
  ///   overrides: [myProvider.overrideWithValue(mockValue)],
  /// );
  /// ```
  Future<void> pumpApp(
    Widget widget, {
    List<Override> overrides = const [],
  }) {
    return pumpWidget(
      ProviderScope(
        overrides: overrides,
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: widget,
        ),
      ),
    );
  }
}
