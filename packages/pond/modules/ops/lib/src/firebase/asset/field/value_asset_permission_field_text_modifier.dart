import 'package:asset_core/asset_core.dart';
import 'package:drop_core/drop_core.dart';
import 'package:ops/src/firebase/asset/asset_permission_context.dart';
import 'package:ops/src/firebase/asset/field/asset_permission_field_text_modifier.dart';

class ValueAssetPermissionFieldTextModifier extends AssetPermissionFieldTextModifier<ValueAssetPermissionField> {
  @override
  List<String> getText(
    DropCoreContext context,
    AssetPermissionContext assetPermissionContext,
    ValueAssetPermissionField assetPermissionField,
  ) {
    return [_getValue(assetPermissionField.value)];
  }

  String _getValue(dynamic value) {
    if (value == null) {
      return 'null';
    } else if (value is String) {
      return '"$value"';
    } else {
      return value.toString();
    }
  }
}
