import 'package:drop_core/drop_core.dart';

class ReferenceMetaModifier extends BehaviorMetaModifier<ReferenceValueObjectProperty> {
  @override
  bool isReference(ReferenceValueObjectProperty<Entity<ValueObject>> behavior) {
    return true;
  }
}
