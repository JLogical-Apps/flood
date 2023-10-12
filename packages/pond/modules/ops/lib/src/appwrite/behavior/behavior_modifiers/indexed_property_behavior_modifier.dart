import 'dart:math';

import 'package:drop_core/drop_core.dart';
import 'package:ops/src/appwrite/behavior/appwrite_attribute_behavior_modifier.dart';

const _largestIndexSize = 768;

class IndexedPropertyBehaviorModifier extends WrapperAppwriteAttributeBehaviorModifier<IndexedValueObjectProperty> {
  IndexedPropertyBehaviorModifier({required super.modifierGetter});

  @override
  ValueObjectBehavior unwrapBehavior(IndexedValueObjectProperty behavior) {
    return behavior.property;
  }

  @override
  bool isIndexed(IndexedValueObjectProperty behavior) {
    return behavior.isIndexed;
  }

  @override
  int? getSize(IndexedValueObjectProperty behavior) {
    final existingSize = modifierGetter(behavior.property)!.getSize(behavior.property);
    if (existingSize != null) {
      return min(existingSize, _largestIndexSize);
    }

    return null;
  }
}
