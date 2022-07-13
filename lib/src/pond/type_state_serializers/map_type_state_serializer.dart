import 'package:jlogical_utils/src/utils/export_core.dart';

import '../context/app_context.dart';
import 'type_state_serializer.dart';

class MapTypeStateSerializer<K, V> extends TypeStateSerializer<Map<K, V>> {
  @override
  dynamic serialize(Map<K, V> value) {
    return value.map((key, value) {
      final serializedKey = AppContext.global.getTypeStateSerializerByTypeRuntime(K).serialize(key);
      final serializedValue = AppContext.global.getTypeStateSerializerByTypeRuntime(V).serialize(value);
      return MapEntry(serializedKey, serializedValue);
    });
  }

  @override
  Map<K, V> deserialize(dynamic value) {
    Object? object = value;

    return object.mapIfNonNull((object) => object.as<Map>()).mapIfNonNull((map) => map.map((key, value) => MapEntry(
              AppContext.global.getTypeStateSerializerByTypeRuntime(K).deserialize(key) as K,
              AppContext.global.getTypeStateSerializerByTypeRuntime(V).deserialize(value) as V,
            ))) ??
        (throw Exception('Cannot deserialize map from $value'));
  }

  @override
  bool matchesDeserializing(value) {
    return value is Map;
  }
}
