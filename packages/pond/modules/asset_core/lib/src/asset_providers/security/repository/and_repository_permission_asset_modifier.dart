import 'package:asset_core/src/asset_providers/security/asset_permission.dart';
import 'package:asset_core/src/asset_providers/security/repository/repository_permission_asset_modifier.dart';
import 'package:drop_core/drop_core.dart';

class AndRepositoryPermissionAssetModifier extends RepositoryPermissionAssetModifier<AndPermission> {
  @override
  AssetPermission toAssetPermission(Repository repository, AndPermission permission) =>
      AssetPermission.and(permission.permissions
          .map((permission) => RepositoryPermissionAssetModifier.getAssetPermission(repository, permission))
          .toList());
}