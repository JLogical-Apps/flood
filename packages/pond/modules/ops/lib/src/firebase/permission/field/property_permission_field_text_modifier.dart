import 'package:drop_core/drop_core.dart';
import 'package:ops/src/firebase/permission/field/permission_field_text_modifier.dart';
import 'package:ops/src/firebase/permission/permission_context.dart';

class PropertyPermissionFieldTextModifier extends PermissionFieldTextModifier<PropertyPermissionField> {
  @override
  String getText(
    DropCoreContext context,
    PermissionContext permissionContext,
    PropertyPermissionField permissionField,
  ) {
    final resourceContext =
        (permissionContext == PermissionContext.read || permissionContext == PermissionContext.delete)
            ? 'resource.data'
            : 'request.resource.data';
    return '$resourceContext.${permissionField.propertyName}';
  }
}
