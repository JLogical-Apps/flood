import 'package:asset_core/src/asset_providers/security/asset_permission.dart';
import 'package:asset_core/src/asset_providers/security/repository/repository_permission_asset_modifier.dart';
import 'package:drop_core/drop_core.dart';

class NoneRepositoryPermissionAssetModifier extends RepositoryPermissionAssetModifier<NonePermission> {
  @override
  AssetPermission toAssetPermission(Repository repository, NonePermission permission) => AssetPermission.none;
}
