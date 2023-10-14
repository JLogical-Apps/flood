import 'package:drop_core/drop_core.dart';
import 'package:ops/src/appwrite/permission/permission_text_modifier.dart';

class AndPermissionTextModifier extends PermissionTextModifier<AndPermission> {
  final PermissionTextModifier Function(Permission permission) permissionTextModifierGetter;

  AndPermissionTextModifier({required this.permissionTextModifierGetter});

  @override
  List<String> getPermissions(DropCoreContext context, AndPermission permission) {
    return permission.permissions
        .map((permission) => '${permissionTextModifierGetter(permission).getPermissions(context, permission)}')
        .toList();
  }
}
