import 'package:drop_core/drop_core.dart';
import 'package:ops/src/appwrite/permission/permission_text_modifier.dart';

class AllPermissionTextModifier extends PermissionTextModifier<AllPermission> {
  @override
  List<String> getPermissions(DropCoreContext context, AllPermission permission) {
    return ['any'];
  }
}
