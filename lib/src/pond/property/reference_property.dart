import 'package:jlogical_utils/src/pond/utils/resolvable.dart';
import 'package:jlogical_utils/src/pond/export.dart';
import 'package:jlogical_utils/src/pond/property/property.dart';
import 'package:jlogical_utils/src/pond/property/validation/property_validator.dart';

class ReferenceProperty<E extends Entity> extends Property<String> with WithGlobalTypeSerializer implements Resolvable {
  ReferenceProperty({
    required String name,
    E? initialReference,
    String? initialValue,
    List<PropertyValidator<String>>? validators,
  }) : super(name: name, initialValue: initialReference?.id ?? initialValue, validators: validators);

  E? _reference;

  E? get reference => _reference;

  set reference(E? reference) {
    if (reference != null && reference.id == null) {
      throw Exception('Cannot set a property to reference an entity with a null id!');
    }

    _reference = reference;
    value = reference?.id;
  }

  Future resolve(AppContext context) async {
    final referenceId = value;
    if (referenceId == null) {
      return;
    }

    final entityRepository = context.database.getRepository<E>();
    _reference = await entityRepository.getOrNull(referenceId);
  }
}
