import 'package:asset_core/asset_core.dart';
import 'package:asset_core/src/asset_providers/security/repository/admin_repository_permission_asset_modifier.dart';
import 'package:asset_core/src/asset_providers/security/repository/all_repository_permission_asset_modifier.dart';
import 'package:asset_core/src/asset_providers/security/repository/and_repository_permission_asset_modifier.dart';
import 'package:asset_core/src/asset_providers/security/repository/authenticated_repository_permission_asset_modifier.dart';
import 'package:asset_core/src/asset_providers/security/repository/equals_repository_permission_asset_modifier.dart';
import 'package:asset_core/src/asset_providers/security/repository/none_repository_permission_asset_modifier.dart';
import 'package:asset_core/src/asset_providers/security/repository/or_repository_permission_asset_modifier.dart';
import 'package:drop_core/drop_core.dart';
import 'package:utils_core/utils_core.dart';

abstract class RepositoryPermissionAssetModifier<T extends Permission> with IsTypedModifier<T, Permission> {
  AssetPermission toAssetPermission(Repository repository, T permission);

  static final permissionModifierResolver = ModifierResolver<RepositoryPermissionAssetModifier, Permission>(modifiers: [
    AllRepositoryPermissionAssetModifier(),
    NoneRepositoryPermissionAssetModifier(),
    AuthenticatedRepositoryPermissionAssetModifier(),
    EqualsRepositoryPermissionAssetModifier(),
    AdminRepositoryPermissionAssetModifier(),
    AndRepositoryPermissionAssetModifier(),
    OrRepositoryPermissionAssetModifier(),
  ]);

  static RepositoryPermissionAssetModifier getModifier(Permission permission) =>
      permissionModifierResolver.resolve(permission);

  static AssetPermission getAssetPermission(Repository repository, Permission permission) =>
      getModifier(permission).toAssetPermission(repository, permission);
}
