import 'package:jlogical_utils/src/pond/context/app_context.dart';
import 'package:jlogical_utils/src/pond/context/registration/app_registration.dart';
import 'package:jlogical_utils/src/pond/query/query.dart';
import 'package:jlogical_utils/src/pond/record/value_object.dart';
import 'package:jlogical_utils/src/pond/state/state.dart';
import 'package:jlogical_utils/src/pond/type_state_serializers/type_state_serializer.dart';
import 'package:jlogical_utils/src/utils/export_core.dart';

class NullableValueObjectTypeStateSerializer extends TypeStateSerializer<ValueObject?> {
  @override
  serialize(ValueObject? value) {
    if (value == null) {
      return null;
    }

    final state = value.state;
    return {
      Query.type: state.type,
      ...state.values.entries.where((entry) => entry.value != null).toMap(),
    };
  }

  @override
  ValueObject? deserialize(dynamic value) {
    return State.extractFromOrNull(value)
        .mapIfNonNull((state) => AppContext.global.constructValueObjectFromState(state));
  }

  @override
  bool matchesType(Type type) {
    return AppContext.global.isSubtype(type, getRuntimeType<ValueObject?>());
  }

  @override
  bool matchesSerializing(value) {
    return value is ValueObject?;
  }

  @override
  bool matchesDeserializing(value) {
    return false;
  }
}
