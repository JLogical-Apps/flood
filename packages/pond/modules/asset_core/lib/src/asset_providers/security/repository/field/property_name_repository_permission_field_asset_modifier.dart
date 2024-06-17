import 'package:asset_core/src/asset_providers/security/field/asset_permission_field.dart';
import 'package:asset_core/src/asset_providers/security/repository/field/repository_permission_field_asset_modifier.dart';
import 'package:drop_core/drop_core.dart';

class PropertyNameRepositoryPermissionFieldAssetModifier
    extends RepositoryPermissionFieldAssetModifier<PropertyPermissionField> {
  @override
  AssetPermissionField toAssetPermissionField(Repository repository, PropertyPermissionField permissionField) {
    return AssetPermissionField.entity(
      AssetPermissionField.entityId,
      entityType: RepositoryMetaModifier.getModifier(repository).getEntityType(repository),
    ).propertyName(permissionField.propertyName);
  }
}
