import 'package:asset_core/asset_core.dart';
import 'package:drop_core/drop_core.dart';
import 'package:ops/src/firebase/asset/asset_permission_text_modifier.dart';

class AndAssetPermissionTextModifier extends AssetPermissionTextModifier<AndAssetPermission> {
  final AssetPermissionTextModifier Function(AssetPermission assetPermission) permissionTextModifierGetter;

  AndAssetPermissionTextModifier({required this.permissionTextModifierGetter});

  @override
  String getText(
    DropCoreContext context,
    AssetPermissionContext assetPermissionContext,
    AndAssetPermission assetPermission,
  ) {
    return assetPermission.permissions
        .map((permission) =>
            '(${permissionTextModifierGetter(permission).getText(context, assetPermissionContext, permission)})')
        .join(' && ');
  }
}
