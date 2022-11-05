import 'package:pond_core/pond_core.dart';
import 'package:type_core/type_core.dart';

class DropCoreComponent extends CorePondComponent {
  @override
  List<CorePondComponentBehavior> get behaviors => [
        CorePondComponentBehavior.dependency<TypeCoreComponent>(),
      ];
}
