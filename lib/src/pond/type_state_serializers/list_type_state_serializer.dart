import 'package:jlogical_utils/src/pond/context/app_context.dart';
import 'package:jlogical_utils/src/pond/type_state_serializers/type_state_serializer.dart';
import 'package:jlogical_utils/src/utils/export_core.dart';

class ListTypeStateSerializer<T> extends TypeStateSerializer<List<T>> {
  TypeStateSerializer itemTypeStateSerializer = AppContext.global.getTypeStateSerializerByTypeRuntime(T);

  @override
  dynamic serialize(List<T> value) {
    return value.map((element) => itemTypeStateSerializer.serialize(element)).toList();
  }

  @override
  List<T> deserialize(dynamic value) {
    Object? object = value;

    return object.mapIfNonNull((object) => object.as<List>()).mapIfNonNull(
            (list) => list.map((element) => itemTypeStateSerializer.deserialize(element) as T).toList()) ??
        (throw Exception('Cannot deserialize list from $value'));
  }
}
