import 'package:drop_core/drop_core.dart';
import 'package:ops/src/firebase/permission/field/permission_field_text_modifier.dart';
import 'package:ops/src/firebase/permission/permission_context.dart';

class LoggedInUserIdPermissionFieldTextModifier extends PermissionFieldTextModifier<LoggedInUserIdPermissionField> {
  @override
  List<String> getText(
      DropCoreContext context, PermissionContext permissionContext, LoggedInUserIdPermissionField permissionField) {
    return ['request.auth.uid'];
  }
}
