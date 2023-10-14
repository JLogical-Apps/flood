import 'package:drop_core/drop_core.dart';
import 'package:ops/src/firebase/permission/permission_text_modifier.dart';

class AndPermissionTextModifier extends PermissionTextModifier<AndPermission> {
  final PermissionTextModifier Function(Permission permission) permissionTextModifierGetter;

  AndPermissionTextModifier({required this.permissionTextModifierGetter});

  @override
  String getText(DropCoreContext context, AndPermission permission) {
    return permission.permissions
        .map((permission) => '(${permissionTextModifierGetter(permission).getText(context, permission)})')
        .join(' && ');
  }
}
