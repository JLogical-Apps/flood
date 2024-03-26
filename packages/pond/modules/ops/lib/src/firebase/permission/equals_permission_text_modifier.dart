import 'package:drop_core/drop_core.dart';
import 'package:ops/src/firebase/permission/field/permission_field_text_modifier.dart';
import 'package:ops/src/firebase/permission/permission_context.dart';
import 'package:ops/src/firebase/permission/permission_text_modifier.dart';

class EqualsPermissionTextModifier extends PermissionTextModifier<EqualsPermission> {
  @override
  String getText(DropCoreContext context, PermissionContext permissionContext, EqualsPermission permission) {
    return [permission.field1, permission.field2]
        .map((permissionField) => PermissionFieldTextModifier.getModifier(permissionField)
            .getText(context, permissionContext, permissionField))
        .join(' == ');
  }
}
