import 'package:jlogical_utils/src/pond/property/property.dart';
import 'package:jlogical_utils/src/pond/type_state_serializers/type_state_serializer.dart';

class FallbackProperty<T> extends Property<T> {
  final Property<T?> parent;
  final T Function() fallback;

  FallbackProperty({required this.parent, required this.fallback}) : super(name: parent.name, initialValue: parent.getUnvalidated());

  @override
  T? getUnvalidated() {
    return parent.getUnvalidated() ?? fallback();
  }

  @override
  void setUnvalidated(T value) {
    parent.setUnvalidated(value);
  }

  @override
  TypeStateSerializer get typeStateSerializer => parent.typeStateSerializer;
}
