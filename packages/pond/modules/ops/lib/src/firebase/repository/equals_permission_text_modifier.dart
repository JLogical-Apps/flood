import 'package:drop_core/drop_core.dart';
import 'package:ops/src/firebase/repository/field/permission_field_text_modifier.dart';
import 'package:ops/src/firebase/repository/permission_context.dart';
import 'package:ops/src/firebase/repository/permission_text_modifier.dart';

class EqualsPermissionTextModifier extends PermissionTextModifier<EqualsPermission> {
  @override
  String getText(DropCoreContext context, PermissionContext permissionContext, EqualsPermission permission) {
    final permission1Text = _getPermissionText(context, permissionContext, permission.field1);
    final permission2Text = _getPermissionText(context, permissionContext, permission.field2);

    final permissionCombinations = permission1Text.expand((permission) {
      return permission2Text.map((permission2) => [permission, permission2]);
    }).toList();

    return permissionCombinations.map((permission) {
      final [permission1, permission2] = permission;
      return '$permission1 == $permission2';
    }).join(' && ');
  }

  List<String> _getPermissionText(
    DropCoreContext context,
    PermissionContext permissionContext,
    PermissionField permissionField,
  ) {
    return PermissionFieldTextModifier.getModifier(permissionField)
        .getText(context, permissionContext, permissionField);
  }
}
