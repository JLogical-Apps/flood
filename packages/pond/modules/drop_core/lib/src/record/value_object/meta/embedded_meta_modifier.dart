import 'package:drop_core/drop_core.dart';

class EmbeddedMetaModifier extends WrapperBehaviorMetaModifier<EmbeddedValueObjectProperty> {
  @override
  void Function(ValueObject valueObject)? getValueObjectInstantiator(EmbeddedValueObjectProperty behavior) {
    return behavior.instantiator();
  }
}
