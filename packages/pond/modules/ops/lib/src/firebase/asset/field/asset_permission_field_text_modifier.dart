import 'package:asset_core/asset_core.dart';
import 'package:drop_core/drop_core.dart';
import 'package:ops/src/firebase/asset/asset_permission_context.dart';
import 'package:ops/src/firebase/asset/field/entity_property_asset_permission_field_text_modifier.dart';
import 'package:ops/src/firebase/asset/field/logged_in_user_id_asset_permission_field_text_modifier.dart';
import 'package:ops/src/firebase/asset/field/path_metadata_asset_permission_field_text_modifier.dart';
import 'package:ops/src/firebase/asset/field/value_asset_permission_field_text_modifier.dart';
import 'package:utils_core/utils_core.dart';

abstract class AssetPermissionFieldTextModifier<P extends AssetPermissionField>
    with IsTypedModifier<P, AssetPermissionField> {
  List<String> getText(DropCoreContext context, AssetPermissionContext assetPermissionContext, P assetPermissionField);

  static final assetPermissionFieldTextModifierResolver =
      ModifierResolver<AssetPermissionFieldTextModifier, AssetPermissionField>(modifiers: [
    ValueAssetPermissionFieldTextModifier(),
    PathMetadataAssetPermissionFieldTextModifier(),
    EntityPropertyAssetPermissionFieldTextModifier(modifierGetter: getModifier),
    LoggedInUserIdAssetPermissionFieldTextModifier(),
  ]);

  static AssetPermissionFieldTextModifier getModifier(AssetPermissionField assetPermissionField) {
    return assetPermissionFieldTextModifierResolver.resolve(assetPermissionField);
  }
}
