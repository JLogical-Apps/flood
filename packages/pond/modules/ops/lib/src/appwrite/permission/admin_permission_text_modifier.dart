import 'package:drop_core/drop_core.dart';
import 'package:ops/src/appwrite/permission/permission_text_modifier.dart';

class AdminPermissionTextModifier extends PermissionTextModifier<AdminPermission> {
  @override
  List<String> getPermissions(DropCoreContext context, AdminPermission permission) {
    return ['label:admin'];
  }
}
