import 'package:drop_core/drop_core.dart';
import 'package:ops/src/appwrite/behavior/appwrite_attribute_behavior_modifier.dart';

class DateTimeFieldBehaviorModifier extends AppwriteAttributeBehaviorModifier<SimpleValueObjectProperty<DateTime?>> {
  @override
  String getType(SimpleValueObjectProperty<DateTime?> behavior) {
    return 'datetime';
  }
}
