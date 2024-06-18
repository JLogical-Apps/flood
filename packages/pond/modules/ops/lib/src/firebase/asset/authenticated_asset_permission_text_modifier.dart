import 'package:asset_core/asset_core.dart';
import 'package:drop_core/drop_core.dart';
import 'package:ops/src/firebase/asset/asset_permission_context.dart';
import 'package:ops/src/firebase/asset/asset_permission_text_modifier.dart';

class AuthenticatedAssetPermissionTextModifier extends AssetPermissionTextModifier<AuthenticatedAssetPermission> {
  @override
  String getText(
    DropCoreContext context,
    AssetPermissionContext assetPermissionContext,
    AuthenticatedAssetPermission assetPermission,
  ) {
    return 'request.auth != null';
  }
}
