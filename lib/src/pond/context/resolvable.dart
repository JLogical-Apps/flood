import 'app_context.dart';

abstract class Resolvable {
  Future resolve(AppContext context);
}
