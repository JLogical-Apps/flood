import 'package:jlogical_utils/src/pond/context/app_context.dart';
import 'package:jlogical_utils/src/pond/property/property.dart';
import 'package:jlogical_utils/src/pond/property/validation/property_validator.dart';
import 'package:jlogical_utils/src/pond/type_state_serializers/type_state_serializer.dart';
import 'package:jlogical_utils/src/utils/util.dart';

class ListProperty<T> extends Property<List<T>> {
  ListProperty({
    required String name,
    List<T>? initialValue,
    List<PropertyValidator<List<T>>>? validators,
  }) : super(name: name, initialValue: initialValue, validators: validators);

  @override
  TypeStateSerializer<List<T>> get typeStateSerializer => ListTypeStateSerializer<T>();
}

class ListTypeStateSerializer<T> extends TypeStateSerializer<List<T>> {
  TypeStateSerializer itemTypeStateSerializer = AppContext.global.getTypeStateSerializerByRuntimeType(T);

  @override
  dynamic onSerialize(List<T> value) {
    return value.map((element) => itemTypeStateSerializer.onSerialize(element)).toList();
  }

  @override
  List<T> onDeserialize(dynamic value) {
    Object? object = value;

    return object.mapIfNonNull((object) => object.as<List>()).mapIfNonNull(
            (list) => list.map((element) => itemTypeStateSerializer.onDeserialize(element) as T).toList()) ??
        (throw Exception('Cannot deserialize list from $value'));
  }
}
