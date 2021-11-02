import 'package:jlogical_utils/src/pond/context/app_context.dart';
import 'package:jlogical_utils/src/pond/property/property.dart';
import 'package:jlogical_utils/src/pond/type_state_serializers/type_state_serializer.dart';
import 'package:jlogical_utils/src/utils/util.dart';

class MapProperty<K, V> extends Property<Map<K, V>> {
  MapProperty({required String name, Map<K, V>? initialValue}) : super(name: name, initialValue: initialValue);

  @override
  TypeStateSerializer<Map<K, V>> get typeStateSerializer => MapTypeStateSerializer();
}

class MapTypeStateSerializer<K, V> extends TypeStateSerializer<Map<K, V>> {
  final TypeStateSerializer<K> keyTypeStateSerializer = AppContext.global.getTypeStateSerializerByType<K>();
  final TypeStateSerializer<V> valueTypeStateSerializer = AppContext.global.getTypeStateSerializerByType<V>();

  @override
  dynamic onSerialize(Map<K, V> value) {
    return value.map((key, value) {
      final serializedKey = keyTypeStateSerializer.onSerialize(key);
      final serializedValue = valueTypeStateSerializer.onSerialize(value);
      return MapEntry(serializedKey, serializedValue);
    });
  }

  @override
  Map<K, V>? onDeserialize(dynamic value) {
    Object? object = value;

    return object.mapIfNonNull((object) => object.as<Map>()).mapIfNonNull((list) => list.map((key, value) =>
        MapEntry(keyTypeStateSerializer.onDeserialize(key)!, valueTypeStateSerializer.onDeserialize(value)!)));
  }
}
