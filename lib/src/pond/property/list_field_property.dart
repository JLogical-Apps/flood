import 'package:jlogical_utils/src/pond/context/app_context.dart';
import 'package:jlogical_utils/src/pond/type_state_serializers/type_state_serializer.dart';
import 'package:jlogical_utils/src/utils/util.dart';

import 'field_property.dart';

class ListFieldProperty<T> extends FieldProperty<List<T>> {
  ListFieldProperty({required String name, List<T>? initialValue}) : super(name: name, initialValue: initialValue);

  @override
  TypeStateSerializer<List<T>> get typeStateSerializer => ListTypeStateSerializer<T>();
}

class ListTypeStateSerializer<T> extends TypeStateSerializer<List<T>> {
  TypeStateSerializer itemTypeStateSerializer =
      AppContext.global.appRegistration.getTypeStateSerializerByTypeRuntime(T);

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
