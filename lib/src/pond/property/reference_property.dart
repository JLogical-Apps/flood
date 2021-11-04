import 'package:jlogical_utils/src/pond/export.dart';
import 'package:jlogical_utils/src/pond/property/property.dart';
import 'package:jlogical_utils/src/pond/property/validation/property_validator.dart';
import 'package:jlogical_utils/src/pond/record/has_id.dart';

class ReferenceProperty<R extends HasId> extends Property<String> with WithGlobalTypeSerializer {
  ReferenceProperty({required String name, R? initialValue, List<PropertyValidator<String>>? validators})
      : super(name: name, initialValue: initialValue?.id, validators: validators);

  set reference(R reference) {
    final id = reference.id;
    if (id == null) {
      throw Exception('Cannot set a property to reference something with a null id!');
    }
    value = id;
  }
}
