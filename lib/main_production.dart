import 'package:smart_hair_care/app/app.dart';
import 'package:smart_hair_care/bootstrap.dart';

Future<void> main() async {
  await bootstrap(() => const App());
}
