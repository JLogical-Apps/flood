import 'package:jlogical_utils/src/pond/type_state_serializers/type_state_serializer.dart';

import '../type_state_serializers/map_type_state_serializer.dart';
import 'field_property.dart';

class MapFieldProperty<K, V> extends FieldProperty<Map<K, V>> {
  MapFieldProperty({required String name, Map<K, V>? initialValue}) : super(name: name, initialValue: initialValue);

  @override
  TypeStateSerializer<Map<K, V>> get typeStateSerializer => MapTypeStateSerializer();
}
