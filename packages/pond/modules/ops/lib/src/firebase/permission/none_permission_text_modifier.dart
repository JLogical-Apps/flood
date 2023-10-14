import 'package:drop_core/drop_core.dart';
import 'package:ops/src/firebase/permission/permission_text_modifier.dart';

class NonePermissionTextModifier extends PermissionTextModifier<NonePermission> {
  @override
  String getText(DropCoreContext context, NonePermission permission) {
    return 'false';
  }
}
