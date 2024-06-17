import 'package:asset_core/src/asset_providers/security/field/asset_permission_field.dart';
import 'package:asset_core/src/asset_providers/security/repository/field/repository_permission_field_asset_modifier.dart';
import 'package:drop_core/drop_core.dart';

class ValueRepositoryPermissionFieldAssetModifier extends RepositoryPermissionFieldAssetModifier<ValuePermissionField> {
  @override
  AssetPermissionField toAssetPermissionField(Repository repository, ValuePermissionField permissionField) {
    return AssetPermissionField.value(permissionField.value);
  }
}
