import 'package:drop_core/drop_core.dart';
import 'package:ops/src/firebase/permission/permission_context.dart';
import 'package:ops/src/firebase/permission/permission_text_modifier.dart';

class OrPermissionTextModifier extends PermissionTextModifier<OrPermission> {
  final PermissionTextModifier Function(Permission permission) permissionTextModifierGetter;

  OrPermissionTextModifier({required this.permissionTextModifierGetter});

  @override
  String getText(DropCoreContext context, PermissionContext permissionContext, OrPermission permission) {
    return permission.permissions
        .map((permission) =>
            '(${permissionTextModifierGetter(permission).getText(context, permissionContext, permission)})')
        .join(' || ');
  }
}
