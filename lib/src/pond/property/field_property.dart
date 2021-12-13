import 'package:jlogical_utils/src/pond/property/property.dart';
import 'package:jlogical_utils/src/pond/property/validation/property_validator.dart';
import 'package:jlogical_utils/src/pond/property/with_global_type_serializer.dart';

class FieldProperty<T> extends Property<T?> with WithGlobalTypeSerializer {
  T? _value;

  FieldProperty({required String name, List<PropertyValidator<T>>? validators, T? initialValue})
      : super(name: name, initialValue: initialValue, validators: validators);

  @override
  T? getUnvalidated() {
    return _value;
  }

  @override
  void setUnvalidated(T? value) {
    _value = value;
  }
}
