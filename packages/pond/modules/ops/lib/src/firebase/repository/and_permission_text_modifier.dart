import 'package:drop_core/drop_core.dart';
import 'package:ops/src/firebase/repository/permission_context.dart';
import 'package:ops/src/firebase/repository/permission_text_modifier.dart';

class AndPermissionTextModifier extends PermissionTextModifier<AndPermission> {
  final PermissionTextModifier Function(Permission permission) permissionTextModifierGetter;

  AndPermissionTextModifier({required this.permissionTextModifierGetter});

  @override
  String getText(DropCoreContext context, PermissionContext permissionContext, AndPermission permission) {
    return permission.permissions
        .map((permission) =>
            '(${permissionTextModifierGetter(permission).getText(context, permissionContext, permission)})')
        .join(' && ');
  }
}
