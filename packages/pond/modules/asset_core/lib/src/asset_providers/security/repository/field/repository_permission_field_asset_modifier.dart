import 'package:asset_core/src/asset_providers/security/field/asset_permission_field.dart';
import 'package:asset_core/src/asset_providers/security/repository/field/entity_id_repository_permission_field_asset_modifier.dart';
import 'package:asset_core/src/asset_providers/security/repository/field/logged_in_user_id_repository_permission_field_asset_modifier.dart';
import 'package:asset_core/src/asset_providers/security/repository/field/property_name_repository_permission_field_asset_modifier.dart';
import 'package:asset_core/src/asset_providers/security/repository/field/value_repository_permission_field_asset_modifier.dart';
import 'package:drop_core/drop_core.dart';
import 'package:utils_core/utils_core.dart';

abstract class RepositoryPermissionFieldAssetModifier<T extends PermissionField>
    with IsTypedModifier<T, PermissionField> {
  AssetPermissionField toAssetPermissionField(Repository repository, T permissionField);

  static final permissionFieldModifierResolver =
      ModifierResolver<RepositoryPermissionFieldAssetModifier, PermissionField>(modifiers: [
    ValueRepositoryPermissionFieldAssetModifier(),
    EntityIdRepositoryPermissionFieldAssetModifier(),
    LoggedInUserIdRepositoryPermissionFieldAssetModifier(),
    PropertyNameRepositoryPermissionFieldAssetModifier(),
  ]);

  static RepositoryPermissionFieldAssetModifier getModifier(PermissionField permissionField) =>
      permissionFieldModifierResolver.resolve(permissionField);

  static AssetPermissionField getAssetPermissionField(Repository repository, PermissionField permissionField) =>
      getModifier(permissionField).toAssetPermissionField(repository, permissionField);
}
