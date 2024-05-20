import 'package:asset_core/asset_core.dart';
import 'package:drop_core/src/record/value_object/asset_value_object_property.dart';
import 'package:drop_core/src/record/value_object/meta/behavior_meta_modifier.dart';

class AssetMetaModifier extends WrapperBehaviorMetaModifier<AssetValueObjectProperty> {
  @override
  AssetProvider? getAssetProvider(AssetCoreComponent context, AssetValueObjectProperty behavior) {
    return behavior.assetProvider(context);
  }
}
