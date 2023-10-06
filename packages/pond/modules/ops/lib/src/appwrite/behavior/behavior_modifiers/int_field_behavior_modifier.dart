import 'package:drop_core/drop_core.dart';
import 'package:ops/src/appwrite/behavior/appwrite_attribute_behavior_modifier.dart';

class IntFieldBehaviorModifier extends AppwriteAttributeBehaviorModifier<SimpleValueObjectProperty<int?>> {
  @override
  String getType(SimpleValueObjectProperty<int?> behavior) {
    return 'integer';
  }
}
