import 'package:drop_core/drop_core.dart';
import 'package:ops/src/firebase/permission/field/permission_field_text_modifier.dart';
import 'package:ops/src/firebase/permission/permission_context.dart';

class PropertyPermissionFieldTextModifier extends PermissionFieldTextModifier<PropertyPermissionField> {
  @override
  List<String> getText(
    DropCoreContext context,
    PermissionContext permissionContext,
    PropertyPermissionField permissionField,
  ) {
    return _getPropertyContexts(permissionContext)
        .map((context) => '$context.${permissionField.propertyName}')
        .toList();
  }

  List<String> _getPropertyContexts(PermissionContext permissionContext) {
    if (permissionContext == PermissionContext.read || permissionContext == PermissionContext.delete) {
      return ['resource.data'];
    } else if (permissionContext == PermissionContext.create) {
      return ['request.resource.data'];
    } else {
      return ['request.resource.data', 'resource.data'];
    }
  }
}
