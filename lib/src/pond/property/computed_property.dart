import 'package:jlogical_utils/src/pond/property/property.dart';
import 'package:jlogical_utils/src/pond/property/with_global_type_serializer.dart';

class ComputedProperty<T> extends Property<T> with WithGlobalTypeSerializer {
  final T Function() computation;

  ComputedProperty({required String name, required this.computation}) : super(name: name);

  @override
  T? getUnvalidated() {
    return computation();
  }

  @override
  void setUnvalidated(T value) {
    // do nothing.
  }

  @override
  void validate() {}
}
