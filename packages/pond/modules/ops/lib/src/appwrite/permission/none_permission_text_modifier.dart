import 'package:drop_core/drop_core.dart';
import 'package:ops/src/appwrite/permission/permission_text_modifier.dart';

class NonePermissionTextModifier extends PermissionTextModifier<NonePermission> {
  @override
  List<String> getPermissions(DropCoreContext context, NonePermission permission) {
    return [];
  }
}
