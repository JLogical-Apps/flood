import 'package:asset_core/asset_core.dart';
import 'package:drop_core/drop_core.dart';
import 'package:ops/src/firebase/asset/field/asset_permission_field_text_modifier.dart';

class EntityPropertyAssetPermissionFieldTextModifier
    extends AssetPermissionFieldTextModifier<EntityPropertyAssetPermissionField> {
  final AssetPermissionFieldTextModifier Function(AssetPermissionField) modifierGetter;

  EntityPropertyAssetPermissionFieldTextModifier({required this.modifierGetter});

  @override
  String getText(
    DropCoreContext context,
    AssetPermissionContext assetPermissionContext,
    EntityPropertyAssetPermissionField assetPermissionField,
  ) {
    final repository = context.getRepositoryForTypeRuntime(assetPermissionField.entityType);
    final path = RepositoryMetaModifier.getModifier(repository).getPath(repository);

    final subField = assetPermissionField.permissionField;
    final subFieldText = modifierGetter(subField).getText(context, assetPermissionContext, subField);

    return 'firestore.get(/databases/(default)/documents/$path/\$($subFieldText)).data.${assetPermissionField.propertyName}';
  }
}
