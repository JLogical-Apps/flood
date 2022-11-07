import 'package:drop_core/drop_core.dart';
import 'package:pond_core/pond_core.dart';
import 'package:type_core/type_core.dart';

class DropCoreComponent extends CorePondComponent with IsDropCoreContext {
  @override
  List<CorePondComponentBehavior> get behaviors => [
        CorePondComponentBehavior.dependency<TypeCoreComponent>(),
      ];

  @override
  List<Repository> get repositories => context.components.whereType<Repository>().toList();
}
