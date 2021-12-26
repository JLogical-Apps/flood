import 'package:jlogical_utils/src/pond/context/app_context.dart';
import 'package:jlogical_utils/src/pond/database/database.dart';
import 'package:jlogical_utils/src/pond/property/field_property.dart';
import 'package:jlogical_utils/src/pond/property/with_global_type_serializer.dart';
import 'package:jlogical_utils/src/pond/record/entity.dart';
import 'package:jlogical_utils/src/pond/utils/resolvable.dart';

class ReferenceFieldProperty<E extends Entity> extends FieldProperty<String>
    with WithGlobalTypeSerializer
    implements Resolvable {
  ReferenceFieldProperty({
    required String name,
    E? initialReference,
    String? initialValue,
  }) : super(name: name, initialValue: initialReference?.id ?? initialValue);

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
    _reference = await entityRepository.getOrNull(referenceId) as E;
  }
}
