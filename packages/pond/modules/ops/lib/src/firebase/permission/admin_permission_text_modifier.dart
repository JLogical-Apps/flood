import 'package:drop_core/drop_core.dart';
import 'package:ops/src/firebase/permission/permission_text_modifier.dart';

class AdminPermissionTextModifier extends PermissionTextModifier<AdminPermission> {
  @override
  String getText(DropCoreContext context, AdminPermission permission) {
    return 'request.auth.uid != null && request.auth.token.admin == true';
  }
}
