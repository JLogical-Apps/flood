import 'package:drop_core/drop_core.dart';
import 'package:ops/src/firebase/repository/permission_context.dart';
import 'package:ops/src/firebase/repository/permission_text_modifier.dart';

class AllPermissionTextModifier extends PermissionTextModifier<AllPermission> {
  @override
  String getText(DropCoreContext context, PermissionContext permissionContext, AllPermission permission) {
    return 'true';
  }
}
