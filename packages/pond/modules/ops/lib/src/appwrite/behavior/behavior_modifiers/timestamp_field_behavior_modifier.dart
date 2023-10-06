import 'package:drop_core/drop_core.dart';
import 'package:ops/src/appwrite/behavior/appwrite_attribute_behavior_modifier.dart';

class TimestampFieldBehaviorModifier extends AppwriteAttributeBehaviorModifier<SimpleValueObjectProperty<Timestamp?>> {
  @override
  String getType(SimpleValueObjectProperty<Timestamp?> behavior) {
    return 'datetime';
  }
}
