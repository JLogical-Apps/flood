import 'package:drop_core/drop_core.dart';
import 'package:ops/src/appwrite/behavior/appwrite_attribute_behavior_modifier.dart';

class BoolFieldBehaviorModifier extends AppwriteAttributeBehaviorModifier<SimpleValueObjectProperty<bool?>> {
  @override
  String getType(SimpleValueObjectProperty<bool?> behavior) {
    return 'boolean';
  }
}
