import 'package:drop_core/drop_core.dart';
import 'package:ops/src/firebase/repository/field/permission_field_text_modifier.dart';
import 'package:ops/src/firebase/repository/permission_context.dart';

class EntityIdPermissionFieldTextModifier extends PermissionFieldTextModifier<EntityIdPermissionField> {
  @override
  List<String> getText(
    DropCoreContext context,
    PermissionContext permissionContext,
    EntityIdPermissionField permissionField,
  ) {
    return ['id'];
  }
}
