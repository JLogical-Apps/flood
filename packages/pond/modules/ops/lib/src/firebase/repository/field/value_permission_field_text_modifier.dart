import 'package:drop_core/drop_core.dart';
import 'package:ops/src/firebase/repository/field/permission_field_text_modifier.dart';
import 'package:ops/src/firebase/repository/permission_context.dart';

class ValuePermissionFieldTextModifier extends PermissionFieldTextModifier<ValuePermissionField> {
  @override
  List<String> getText(
    DropCoreContext context,
    PermissionContext permissionContext,
    ValuePermissionField permissionField,
  ) {
    return [_getValue(permissionField.value)];
  }

  String _getValue(dynamic value) {
    if (value == null) {
      return 'null';
    } else if (value is String) {
      return '"$value"';
    } else {
      return value.toString();
    }
  }
}
