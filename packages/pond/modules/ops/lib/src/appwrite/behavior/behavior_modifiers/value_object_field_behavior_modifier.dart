import 'package:drop_core/drop_core.dart';
import 'package:ops/src/appwrite/behavior/appwrite_attribute_behavior_modifier.dart';
import 'package:appwrite_core/appwrite_core.dart';

class ValueObjectFieldBehaviorModifier
    extends AppwriteAttributeBehaviorModifier<SimpleValueObjectProperty<ValueObject?>> {
  final AppwriteAttributeBehaviorModifier? Function(ValueObjectBehavior behavior) modifierGetter;

  ValueObjectFieldBehaviorModifier({
    required this.modifierGetter,
  });

  @override
  String getType(SimpleValueObjectProperty<ValueObject?> behavior) {
    return 'string';
  }

  @override
  int? getSize(SimpleValueObjectProperty<ValueObject?> behavior) {
    return AppwriteConsts.longTextSize;
  }
}
