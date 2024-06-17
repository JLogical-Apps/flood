import 'package:asset_core/src/asset_providers/security/field/asset_permission_field.dart';
import 'package:asset_core/src/asset_providers/security/repository/field/repository_permission_field_asset_modifier.dart';
import 'package:drop_core/drop_core.dart';

class LoggedInUserIdRepositoryPermissionFieldAssetModifier
    extends RepositoryPermissionFieldAssetModifier<LoggedInUserIdPermissionField> {
  @override
  AssetPermissionField toAssetPermissionField(Repository repository, LoggedInUserIdPermissionField permissionField) {
    return AssetPermissionField.loggedInUserId;
  }
}
