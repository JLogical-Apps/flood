import 'package:drop_core/drop_core.dart';
import 'package:ops/src/firebase/permission/field/permission_field_text_modifier.dart';
import 'package:ops/src/firebase/permission/permission_context.dart';

class EntityPropertyPermissionFieldTextModifier extends PermissionFieldTextModifier<EntityPropertyPermissionField> {
  final PermissionFieldTextModifier Function(PermissionField) modifierGetter;

  EntityPropertyPermissionFieldTextModifier({required this.modifierGetter});

  @override
  List<String> getText(
    DropCoreContext context,
    PermissionContext permissionContext,
    EntityPropertyPermissionField permissionField,
  ) {
    final repository = context.getRepositoryForTypeRuntime(permissionField.entityType);
    final path = RepositoryMetaModifier.getModifier(repository).getPath(repository);

    final subField = permissionField.permissionField;
    final subsets = modifierGetter(subField).getText(context, permissionContext, subField);

    return subsets
        .map((value) => 'get(/databases/\$(database)/documents/$path/\$($value)).data.${permissionField.propertyName}')
        .toList();
  }
}
