import 'package:asset_core/asset_core.dart';
import 'package:drop_core/drop_core.dart';
import 'package:ops/src/firebase/asset/asset_permission_text_modifier.dart';

class AllAssetPermissionTextModifier extends AssetPermissionTextModifier<AllAssetPermission> {
  @override
  String getText(
    DropCoreContext context,
    AssetPermissionContext assetPermissionContext,
    AllAssetPermission assetPermission,
  ) {
    return 'true';
  }
}
