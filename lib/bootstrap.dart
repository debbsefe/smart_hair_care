import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final class AppProviderObserver extends ProviderObserver {
  const AppProviderObserver();

  @override
  void didUpdateProvider(
    ProviderObserverContext context,
    Object? previousValue,
    Object? newValue,
  ) {
    final providerName = context.provider.name ?? context.provider.runtimeType;
    log(
      'Provider updated: $providerName\n'
      '  Previous: $previousValue\n'
      '  New: $newValue',
    );
  }

  @override
  void didAddProvider(
    ProviderObserverContext context,
    Object? value,
  ) {
    final providerName = context.provider.name ?? context.provider.runtimeType;
    log('Provider added: $providerName');
  }

  @override
  void providerDidFail(
    ProviderObserverContext context,
    Object error,
    StackTrace stackTrace,
  ) {
    final providerName = context.provider.name ?? context.provider.runtimeType;
    log(
      'Provider error: $providerName\n'
      '  Error: $error\n'
      '  StackTrace: $stackTrace',
    );
  }
}

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize logging
  _initializeLogging();

  // Initialize Supabase
  await initializeSupabase();

  runApp(
    ProviderScope(
      observers: const [AppProviderObserver()],
      child: await builder(),
    ),
  );
}

void _initializeLogging() {
  Logger.root.level = kDebugMode ? Level.ALL : Level.WARNING;
  Logger.root.onRecord.listen(
    (record) {
      final logMessage =
          '[${record.loggerName}] ${record.level.name}: '
          '${record.time}: ${record.message}'
          '${record.stackTrace != null ? '\n${record.stackTrace}' : ''}';
      if (kDebugMode) {
        print(logMessage);
      }
    },
  );

  FlutterError.onError = (details) {
    Logger.root.severe(
      details.exceptionAsString(),
      details.exception,
      details.stack,
    );
  };
}

Future<void> initializeSupabase() async {
  const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  assert(
    supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty,
    'SUPABASE_URL and SUPABASE_ANON_KEY must be provided via --dart-define',
  );

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );
}
