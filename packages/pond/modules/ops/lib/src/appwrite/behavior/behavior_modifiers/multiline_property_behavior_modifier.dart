import 'package:appwrite_core/appwrite_core.dart';
import 'package:drop_core/drop_core.dart';
import 'package:ops/src/appwrite/behavior/appwrite_attribute_behavior_modifier.dart';

class MultilinePropertyBehaviorModifier extends WrapperAppwriteAttributeBehaviorModifier<MultilineValueObjectProperty> {
  MultilinePropertyBehaviorModifier({required super.modifierGetter});

  @override
  ValueObjectBehavior unwrapBehavior(MultilineValueObjectProperty<String?, String?> behavior) {
    return behavior.property;
  }

  @override
  int getSize(MultilineValueObjectProperty<String?, String?> behavior) {
    return AppwriteConsts.longTextSize;
  }
}
