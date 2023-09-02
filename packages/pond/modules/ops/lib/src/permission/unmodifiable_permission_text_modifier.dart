import 'package:drop_core/drop_core.dart';
import 'package:ops/src/permission/permission_text_modifier.dart';

class UnmodifiablePermissionTextModifier extends PermissionTextModifier<UnmodifiablePermission> {
  @override
  String getText(DropCoreContext context, UnmodifiablePermission permission) {
    return "!request.resource.data.diff(resource == null ? {} : resource.data).affectedKeys().hasAny(['${permission.field}'])";
  }
}
