import 'package:asset_core/asset_core.dart';
import 'package:drop_core/drop_core.dart';
import 'package:ops/src/firebase/asset/asset_permission_context.dart';
import 'package:ops/src/firebase/asset/asset_permission_text_modifier.dart';
import 'package:ops/src/firebase/asset/field/asset_permission_field_text_modifier.dart';

class EqualsAssetPermissionTextModifier extends AssetPermissionTextModifier<EqualsAssetPermission> {
  @override
  String getText(
    DropCoreContext context,
    AssetPermissionContext assetPermissionContext,
    EqualsAssetPermission assetPermission,
  ) {
    final permission1Text = _getPermissionText(context, assetPermissionContext, assetPermission.field1);
    final permission2Text = _getPermissionText(context, assetPermissionContext, assetPermission.field2);

    final permissionCombinations = permission1Text.expand((permission) {
      return permission2Text.map((permission2) => [permission, permission2]);
    }).toList();

    return permissionCombinations.map((permission) {
      final [permission1, permission2] = permission;
      return '$permission1 == $permission2';
    }).join(' && ');
  }

  List<String> _getPermissionText(
    DropCoreContext context,
    AssetPermissionContext permissionContext,
    AssetPermissionField permissionField,
  ) {
    return AssetPermissionFieldTextModifier.getModifier(permissionField)
        .getText(context, permissionContext, permissionField);
  }
}
