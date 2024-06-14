import 'package:drop_core/drop_core.dart';

class ListEmbeddedMetaModifier extends WrapperBehaviorMetaModifier<ListEmbeddedValueObjectProperty> {
  @override
  void Function(ValueObject valueObject)? getValueObjectInstantiator(ListEmbeddedValueObjectProperty behavior) {
    return (valueObject) => valueObject.entity = behavior.valueObject.entity;
  }
}
