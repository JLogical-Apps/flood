import 'package:drop_core/drop_core.dart';
import 'package:ops/src/firebase/permission/permission_text_modifier.dart';

class AllPermissionTextModifier extends PermissionTextModifier<AllPermission> {
  @override
  String getText(DropCoreContext context, AllPermission permission) {
    return 'true';
  }
}
