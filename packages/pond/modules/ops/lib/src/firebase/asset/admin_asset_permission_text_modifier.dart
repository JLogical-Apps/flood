import 'package:asset_core/asset_core.dart';
import 'package:drop_core/drop_core.dart';
import 'package:ops/src/firebase/asset/asset_permission_text_modifier.dart';

class AdminAssetPermissionTextModifier extends AssetPermissionTextModifier<AdminAssetPermission> {
  @override
  String getText(
    DropCoreContext context,
    AssetPermissionContext assetPermissionContext,
    AdminAssetPermission assetPermission,
  ) {
    return 'request.auth.uid != null && request.auth.token.admin == true';
  }
}
