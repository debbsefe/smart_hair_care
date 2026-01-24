import 'package:flutter/widgets.dart';
import 'package:smart_hair_care/l10n/gen/app_localizations.dart';

export 'package:smart_hair_care/l10n/gen/app_localizations.dart';

extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
