import 'package:asset_core/src/asset_providers/security/field/asset_permission_field.dart';
import 'package:asset_core/src/asset_providers/security/repository/field/repository_permission_field_asset_modifier.dart';
import 'package:drop_core/drop_core.dart';

class EntityPropertyRepositoryPermissionFieldAssetModifier
    extends RepositoryPermissionFieldAssetModifier<EntityPropertyPermissionField> {
  @override
  AssetPermissionField toAssetPermissionField(Repository repository, EntityPropertyPermissionField permissionField) {
    return AssetPermissionField.entity(
      RepositoryPermissionFieldAssetModifier.getAssetPermissionField(repository, permissionField.permissionField),
      entityType: permissionField.entityType,
    ).propertyName(permissionField.propertyName);
  }
}
