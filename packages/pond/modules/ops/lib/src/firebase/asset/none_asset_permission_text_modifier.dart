import 'package:asset_core/asset_core.dart';
import 'package:drop_core/drop_core.dart';
import 'package:ops/src/firebase/asset/asset_permission_text_modifier.dart';

class NoneAssetPermissionTextModifier extends AssetPermissionTextModifier<NoneAssetPermission> {
  @override
  String getText(
    DropCoreContext context,
    AssetPermissionContext assetPermissionContext,
    NoneAssetPermission assetPermission,
  ) {
    return 'false';
  }
}
