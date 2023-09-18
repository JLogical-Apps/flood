import 'package:drop_core/drop_core.dart';
import 'package:pond/pond.dart';

extension DropAppPondContextExtensions on AppPondContext {
  DropCoreComponent get dropCoreComponent {
    return find<DropCoreComponent>();
  }
}
