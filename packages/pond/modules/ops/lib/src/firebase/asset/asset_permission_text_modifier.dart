import 'package:asset_core/asset_core.dart';
import 'package:drop_core/drop_core.dart';
import 'package:ops/src/firebase/asset/admin_asset_permission_text_modifier.dart';
import 'package:ops/src/firebase/asset/all_asset_permission_text_modifier.dart';
import 'package:ops/src/firebase/asset/and_asset_permission_text_modifier.dart';
import 'package:ops/src/firebase/asset/asset_permission_context.dart';
import 'package:ops/src/firebase/asset/authenticated_asset_permission_text_modifier.dart';
import 'package:ops/src/firebase/asset/equals_asset_permission_text_modifier.dart';
import 'package:ops/src/firebase/asset/none_asset_permission_text_modifier.dart';
import 'package:ops/src/firebase/asset/or_asset_permission_text_modifier.dart';
import 'package:utils_core/utils_core.dart';

abstract class AssetPermissionTextModifier<P extends AssetPermission> with IsTypedModifier<P, AssetPermission> {
  String getText(DropCoreContext context, AssetPermissionContext assetPermissionContext, P assetPermission);

  static final assetPermissionTextModifierResolver =
      ModifierResolver<AssetPermissionTextModifier, AssetPermission>(modifiers: [
    AllAssetPermissionTextModifier(),
    NoneAssetPermissionTextModifier(),
    AuthenticatedAssetPermissionTextModifier(),
    AdminAssetPermissionTextModifier(),
    EqualsAssetPermissionTextModifier(),
    AndAssetPermissionTextModifier(permissionTextModifierGetter: getModifier),
    OrAssetPermissionTextModifier(permissionTextModifierGetter: getModifier),
  ]);

  static AssetPermissionTextModifier getModifier(AssetPermission assetPermission) {
    return assetPermissionTextModifierResolver.resolve(assetPermission);
  }
}
