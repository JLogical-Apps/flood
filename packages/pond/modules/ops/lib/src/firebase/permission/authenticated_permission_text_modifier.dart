import 'package:drop_core/drop_core.dart';
import 'package:ops/src/firebase/permission/permission_text_modifier.dart';

class AuthenticatedPermissionTextModifier extends PermissionTextModifier<AuthenticatedPermission> {
  @override
  String getText(DropCoreContext context, AuthenticatedPermission permission) {
    return 'request.auth != null';
  }
}
