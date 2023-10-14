import 'package:drop_core/drop_core.dart';
import 'package:ops/src/appwrite/permission/permission_text_modifier.dart';

class AuthenticatedPermissionTextModifier extends PermissionTextModifier<AuthenticatedPermission> {
  @override
  List<String> getPermissions(DropCoreContext context, AuthenticatedPermission permission) {
    return ['users'];
  }
}
