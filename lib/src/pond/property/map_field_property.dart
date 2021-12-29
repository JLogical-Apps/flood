import 'package:jlogical_utils/src/pond/context/app_context.dart';
import 'package:jlogical_utils/src/pond/type_state_serializers/type_state_serializer.dart';
import 'package:jlogical_utils/src/utils/util.dart';

import 'field_property.dart';

class MapFieldProperty<K, V> extends FieldProperty<Map<K, V>> {
  MapFieldProperty({required String name, Map<K, V>? initialValue}) : super(name: name, initialValue: initialValue);

  @override
  TypeStateSerializer<Map<K, V>> get typeStateSerializer => MapTypeStateSerializer();
}

class MapTypeStateSerializer<K, V> extends TypeStateSerializer<Map<K, V>> {
  final TypeStateSerializer keyTypeStateSerializer = AppContext.global.getTypeStateSerializerByTypeRuntime(K);
  final TypeStateSerializer valueTypeStateSerializer = AppContext.global.getTypeStateSerializerByTypeRuntime(V);

  @override
  dynamic serialize(Map<K, V> value) {
    return value.map((key, value) {
      final serializedKey = keyTypeStateSerializer.serialize(key);
      final serializedValue = valueTypeStateSerializer.serialize(value);
      return MapEntry(serializedKey, serializedValue);
    });
  }

  @override
  Map<K, V> deserialize(dynamic value) {
    Object? object = value;

    return object.mapIfNonNull((object) => object.as<Map>()).mapIfNonNull((list) => list.map((key, value) =>
            MapEntry(keyTypeStateSerializer.deserialize(key), valueTypeStateSerializer.deserialize(value)))) ??
        (throw Exception('Cannot deserialize map from $value'));
  }
}
