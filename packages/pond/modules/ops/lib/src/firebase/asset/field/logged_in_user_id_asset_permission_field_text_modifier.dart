import 'package:asset_core/asset_core.dart';
import 'package:drop_core/drop_core.dart';
import 'package:ops/src/firebase/asset/field/asset_permission_field_text_modifier.dart';

class LoggedInUserIdAssetPermissionFieldTextModifier
    extends AssetPermissionFieldTextModifier<LoggedInUserIdAssetPermissionField> {
  @override
  String getText(
    DropCoreContext context,
    AssetPermissionContext assetPermissionContext,
    LoggedInUserIdAssetPermissionField assetPermissionField,
  ) {
    return 'request.auth.uid';
  }
}
