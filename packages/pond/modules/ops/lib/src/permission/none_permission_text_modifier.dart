import 'package:drop_core/drop_core.dart';
import 'package:ops/src/permission/permission_text_modifier.dart';

class NonePermissionTextModifier extends PermissionTextModifier<NonePermission> {
  @override
  String getText(NonePermission permission) {
    return 'false';
  }
}
