import 'package:asset_core/asset_core.dart';
import 'package:drop_core/drop_core.dart';

class MapperMetaModifier extends BehaviorMetaModifier<MapperValueObjectProperty> {
  @override
  AssetProvider? getAssetProvider(MapperValueObjectProperty behavior) {
    final unwrappedBehavior = behavior.property;
    return BehaviorMetaModifier.getModifier(unwrappedBehavior)?.getAssetProvider(unwrappedBehavior);
  }

  @override
  bool isRequiredOnEdit(MapperValueObjectProperty behavior) {
    final unwrappedBehavior = behavior.property;
    return BehaviorMetaModifier.getModifier(unwrappedBehavior)?.isRequiredOnEdit(unwrappedBehavior) ?? false;
  }

  @override
  bool isOnlyDate(MapperValueObjectProperty behavior) {
    final unwrappedBehavior = behavior.property;
    return BehaviorMetaModifier.getModifier(unwrappedBehavior)?.isOnlyDate(unwrappedBehavior) ?? false;
  }

  @override
  dynamic getDefaultValue(MapperValueObjectProperty behavior) {
    final unwrappedBehavior = behavior.property;
    return BehaviorMetaModifier.getModifier(unwrappedBehavior)?.getDefaultValue(unwrappedBehavior);
  }

  @override
  void Function(ValueObject valueObject)? getValueObjectInstantiator(MapperValueObjectProperty behavior) {
    final unwrappedBehavior = behavior.property;
    return BehaviorMetaModifier.getModifier(unwrappedBehavior)?.getValueObjectInstantiator(unwrappedBehavior);
  }
}
