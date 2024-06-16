import 'package:asset_core/asset_core.dart';
import 'package:drop_core/drop_core.dart';

class ListMetaModifier extends BehaviorMetaModifier<ListValueObjectProperty> {
  @override
  AssetProvider? getAssetProvider(AssetCoreComponent context, ListValueObjectProperty behavior) {
    return BehaviorMetaModifier.getModifier(behavior.property)?.getAssetProvider(context, behavior.property);
  }
}
