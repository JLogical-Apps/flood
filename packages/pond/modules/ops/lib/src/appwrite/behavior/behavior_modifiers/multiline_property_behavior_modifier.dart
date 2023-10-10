import 'package:drop_core/drop_core.dart';
import 'package:ops/src/appwrite/behavior/appwrite_attribute_behavior_modifier.dart';
import 'package:appwrite_core/appwrite_core.dart';

class MultilinePropertyBehaviorModifier extends WrapperAppwriteAttributeBehaviorModifier<MultilineValueObjectProperty> {
  MultilinePropertyBehaviorModifier({required super.modifierGetter});

  @override
  ValueObjectBehavior unwrapBehavior(MultilineValueObjectProperty<String?, String?, dynamic> behavior) {
    return behavior.property;
  }

  @override
  int getSize(MultilineValueObjectProperty<String?, String?, dynamic> behavior) {
    return AppwriteConsts.longTextSize;
  }
}
