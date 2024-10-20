import 'package:drop_core/drop_core.dart';
import 'package:ops/src/firebase/repository/permission_context.dart';
import 'package:ops/src/firebase/repository/permission_text_modifier.dart';

class NonePermissionTextModifier extends PermissionTextModifier<NonePermission> {
  @override
  String getText(DropCoreContext context, PermissionContext permissionContext, NonePermission permission) {
    return 'false';
  }
}
