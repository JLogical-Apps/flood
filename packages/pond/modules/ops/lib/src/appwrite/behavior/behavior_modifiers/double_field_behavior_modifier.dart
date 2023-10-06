import 'package:drop_core/drop_core.dart';
import 'package:ops/src/appwrite/behavior/appwrite_attribute_behavior_modifier.dart';

class DoubleFieldBehaviorModifier
    extends AppwriteAttributeBehaviorModifier<SimpleValueObjectProperty<double?>> {
  @override
  String getType(SimpleValueObjectProperty<double?> behavior) {
    return 'float';
  }
}
