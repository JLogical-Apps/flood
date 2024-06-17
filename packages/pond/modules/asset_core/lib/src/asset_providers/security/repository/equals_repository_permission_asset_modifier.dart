import 'package:asset_core/src/asset_providers/security/asset_permission.dart';
import 'package:asset_core/src/asset_providers/security/repository/field/repository_permission_field_asset_modifier.dart';
import 'package:asset_core/src/asset_providers/security/repository/repository_permission_asset_modifier.dart';
import 'package:drop_core/drop_core.dart';

class EqualsRepositoryPermissionAssetModifier extends RepositoryPermissionAssetModifier<EqualsPermission> {
  @override
  AssetPermission toAssetPermission(Repository repository, EqualsPermission permission) => AssetPermission.equals(
        RepositoryPermissionFieldAssetModifier.getAssetPermissionField(repository, permission.field1),
        RepositoryPermissionFieldAssetModifier.getAssetPermissionField(repository, permission.field2),
      );
}
