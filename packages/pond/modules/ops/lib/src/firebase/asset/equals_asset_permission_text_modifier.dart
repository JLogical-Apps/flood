import 'package:asset_core/asset_core.dart';
import 'package:collection/collection.dart';
import 'package:drop_core/drop_core.dart';
import 'package:ops/src/firebase/asset/asset_permission_text_modifier.dart';
import 'package:ops/src/firebase/asset/field/asset_permission_field_text_modifier.dart';

class EqualsAssetPermissionTextModifier extends AssetPermissionTextModifier<EqualsAssetPermission> {
  @override
  String getText(
    DropCoreContext context,
    AssetPermissionContext assetPermissionContext,
    EqualsAssetPermission assetPermission,
  ) {
    final permission1Text = _getPermissionText(context, assetPermissionContext, assetPermission.field1);
    final permission2Text = _getPermissionText(context, assetPermissionContext, assetPermission.field2);

    final conditionText = '$permission1Text == $permission2Text';

    final fieldDependingOnRootEntity =
        [assetPermission.field1, assetPermission.field2].firstWhereOrNull((field) => field.dependsOnRootEntity());

    if (assetPermissionContext != AssetPermissionContext.create || fieldDependingOnRootEntity == null) {
      return conditionText;
    }

    final repository = context.getRepositoryForTypeRuntime(fieldDependingOnRootEntity.getRootEntityType());
    final path = RepositoryMetaModifier.getModifier(repository).getPath(repository);

    return 'firestore.exists(/databases/(default)/documents/$path/\$(id)) ? ($conditionText) : (${AssetPermissionTextModifier.getPermissionText(context, assetPermission: AssetPermission.authenticated, assetPermissionContext: assetPermissionContext)})';
  }

  String _getPermissionText(
    DropCoreContext context,
    AssetPermissionContext permissionContext,
    AssetPermissionField permissionField,
  ) {
    return AssetPermissionFieldTextModifier.getModifier(permissionField)
        .getText(context, permissionContext, permissionField);
  }
}
