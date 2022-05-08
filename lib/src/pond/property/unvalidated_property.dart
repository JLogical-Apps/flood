import 'package:jlogical_utils/src/pond/type_state_serializers/type_state_serializer.dart';

import 'property.dart';

class UnvalidatedProperty<T> extends Property<T?> {
  final Property<T?> parentProperty;

  UnvalidatedProperty({required this.parentProperty}) : super(name: parentProperty.name);

  @override
  T? getUnvalidated() {
    return parentProperty.getUnvalidated();
  }

  @override
  T? get value {
    return parentProperty.getUnvalidated();
  }

  @override
  void setUnvalidated(T? value) {
    parentProperty.setUnvalidated(value);
  }

  @override
  TypeStateSerializer get typeStateSerializer => parentProperty.typeStateSerializer;

  @override
  void onValidateSync(void empty) {
    return;
  }
}
