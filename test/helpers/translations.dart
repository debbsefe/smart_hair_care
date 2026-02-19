import 'dart:ui';

import 'package:smart_hair_care/l10n/l10n.dart';

Future<AppLocalizations> loadTranslations() =>
    AppLocalizations.delegate.load(const Locale('en'));
