import 'package:asset_core/asset_core.dart';
import 'package:drop_core/drop_core.dart';
import 'package:drop_core/src/record/value_object/meta/asset_meta_modifier.dart';
import 'package:drop_core/src/record/value_object/meta/default_meta_modifier.dart';
import 'package:drop_core/src/record/value_object/meta/embedded_meta_modifier.dart';
import 'package:drop_core/src/record/value_object/meta/list_embedded_meta_modifier.dart';
import 'package:drop_core/src/record/value_object/meta/mapper_meta_modifier.dart';
import 'package:drop_core/src/record/value_object/meta/only_date_meta_modifier.dart';
import 'package:drop_core/src/record/value_object/meta/required_meta_modifier.dart';
import 'package:drop_core/src/record/value_object/meta/required_on_edit_meta_modifier.dart';
import 'package:utils_core/utils_core.dart';

abstract class BehaviorMetaModifier<T extends ValueObjectBehavior> with IsTypedModifier<T, ValueObjectBehavior> {
  AssetProvider? getAssetProvider(AssetCoreComponent context, T behavior) {
    return null;
  }

  bool isRequiredOnEdit(T behavior) {
    return false;
  }

  bool isOnlyDate(T behavior) {
    return false;
  }

  dynamic getDefaultValue(T behavior) {
    return null;
  }

  void Function(ValueObject valueObject)? getValueObjectInstantiator(T behavior) {
    return null;
  }

  static final behaviorMetaModifierResolver = ModifierResolver<BehaviorMetaModifier, ValueObjectBehavior>(modifiers: [
    AssetMetaModifier(),
    DefaultMetaModifier(),
    EmbeddedMetaModifier(),
    ListEmbeddedMetaModifier(),
    OnlyDateMetaModifier(),
    RequiredMetaModifier(),
    RequiredOnEditMetaModifier(),
    MapperMetaModifier(),
    WrapperBehaviorMetaModifier(),
  ]);

  static BehaviorMetaModifier? getModifier(ValueObjectBehavior behavior) =>
      behaviorMetaModifierResolver.resolveOrNull(behavior);
}

class WrapperBehaviorMetaModifier<T extends ValueObjectPropertyWrapper> extends BehaviorMetaModifier<T> {
  @override
  AssetProvider? getAssetProvider(AssetCoreComponent context, T behavior) {
    final unwrappedBehavior = behavior.property;
    return BehaviorMetaModifier.getModifier(unwrappedBehavior)?.getAssetProvider(context, unwrappedBehavior);
  }

  @override
  bool isRequiredOnEdit(T behavior) {
    final unwrappedBehavior = behavior.property;
    return BehaviorMetaModifier.getModifier(unwrappedBehavior)?.isRequiredOnEdit(unwrappedBehavior) ?? false;
  }

  @override
  bool isOnlyDate(T behavior) {
    final unwrappedBehavior = behavior.property;
    return BehaviorMetaModifier.getModifier(unwrappedBehavior)?.isOnlyDate(unwrappedBehavior) ?? false;
  }

  @override
  dynamic getDefaultValue(T behavior) {
    final unwrappedBehavior = behavior.property;
    return BehaviorMetaModifier.getModifier(unwrappedBehavior)?.getDefaultValue(unwrappedBehavior);
  }

  @override
  void Function(ValueObject valueObject)? getValueObjectInstantiator(T behavior) {
    final unwrappedBehavior = behavior.property;
    return BehaviorMetaModifier.getModifier(unwrappedBehavior)?.getValueObjectInstantiator(unwrappedBehavior);
  }
}
