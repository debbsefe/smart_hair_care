// Ignore for testing purposes
// ignore_for_file: prefer_const_constructors

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hair_care/app/app.dart';
import 'package:smart_hair_care/features/home/home.dart';

void main() {
  group('App', () {
    testWidgets('renders HomePage', (tester) async {
      await tester.pumpWidget(
        ProviderScope(child: App()),
      );
      expect(find.byType(HomePage), findsOneWidget);
    });
  });
}
