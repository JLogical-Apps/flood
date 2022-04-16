import 'package:jlogical_utils/src/pond/modules/environment/environment.dart';

class AppIconBanner {
  final Environment environment;
  final String text;
  final int color;

  AppIconBanner({required this.environment, required this.color, String? text})
      : this.text = text ?? environment.name.toUpperCase();
}
