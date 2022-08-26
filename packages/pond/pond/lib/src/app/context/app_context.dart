import 'package:pond_core/pond_core.dart';

class AppContext {
  static late AppContext global;

  final CorePondContext corePondContext;

  AppContext({required this.corePondContext});
}
