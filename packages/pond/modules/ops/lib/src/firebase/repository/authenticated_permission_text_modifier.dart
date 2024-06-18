import 'package:drop_core/drop_core.dart';
import 'package:ops/src/firebase/repository/permission_context.dart';
import 'package:ops/src/firebase/repository/permission_text_modifier.dart';

class AuthenticatedPermissionTextModifier extends PermissionTextModifier<AuthenticatedPermission> {
  @override
  String getText(DropCoreContext context, PermissionContext permissionContext, AuthenticatedPermission permission) {
    return 'request.auth != null';
  }
}
