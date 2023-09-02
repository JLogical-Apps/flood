import 'package:actions_core/actions_core.dart';
import 'package:pond_core/pond_core.dart';
import 'package:utils_core/utils_core.dart';

extension CorePondContextActionExtensions on CorePondContext {
  Future<R> run<A extends Action<P, R>, P, R>(A action, P parameters) async {
    return locate<ActionCoreComponent>().run<A, P, R>(action, parameters);
  }
}
