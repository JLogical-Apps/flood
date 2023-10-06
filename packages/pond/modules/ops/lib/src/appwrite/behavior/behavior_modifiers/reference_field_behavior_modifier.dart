import 'package:drop_core/drop_core.dart';
import 'package:ops/src/appwrite/behavior/appwrite_attribute_behavior_modifier.dart';

class ReferenceFieldBehaviorModifier extends AppwriteAttributeBehaviorModifier<ReferenceValueObjectProperty> {
  @override
  String getType(ReferenceValueObjectProperty behavior) {
    return 'string';
  }

  @override
  int? getSize(ReferenceValueObjectProperty<Entity<ValueObject>> behavior) {
    return 256; // IDs should not be larger than 256 characters.
  }
}
