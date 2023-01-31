import 'package:actions_core/actions_core.dart';
import 'package:pond/pond.dart';

extension AppPondContextActionExtensions on AppPondContext {
  Future<R> run<P, R>(Action<P, R> action, P parameters) async {
    return find<ActionCoreComponent>().run(action, parameters);
  }
}
