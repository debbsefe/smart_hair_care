import 'package:smart_hair_care/l10n/l10n.dart';

/// Taken from emailregex.com
final _emailRegex = RegExp(
  r'''(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])''',
);

/// Returns true if [email] matches a valid email format.
bool isValidEmail(String email) => _emailRegex.hasMatch(email);

/// Form field validator for email addresses.
String? Function(String?) emailAddressValidator(
  AppLocalizations l10n, [
  String? errorMessage,
]) {
  return (String? value) {
    if (value != null && _emailRegex.hasMatch(value)) {
      return null;
    }
    return errorMessage ?? l10n.invalidEmail;
  };
}
