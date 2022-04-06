import 'package:jlogical_utils/src/pond/schema/field/schema_field.dart';
import 'package:jlogical_utils/src/pond/state/state.dart';
import 'package:jlogical_utils/src/pond/validation/validator.dart';

import '../../record/value_object.dart';

class EmbeddedSchemaField<V extends ValueObject> extends SchemaField {
  @override
  bool matches(bool exists, value) {
    if (value == null) {
      return true;
    }

    final state = State.extractFromOrNull(value);
    if (state == null) {
      return false;
    }

    final valueObject = ValueObject.fromStateOrNull<V>(state);
    if (valueObject == null || !valueObject.isValid()) {
      return false;
    }

    return true;
  }
}
