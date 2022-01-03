import 'package:jlogical_utils/src/pond/type_state_serializers/list_type_state_serializer.dart';
import 'package:jlogical_utils/src/pond/type_state_serializers/type_state_serializer.dart';

import 'field_property.dart';

class ListFieldProperty<T> extends FieldProperty<List<T>> {
  ListFieldProperty({required String name, List<T>? initialValue}) : super(name: name, initialValue: initialValue);

  @override
  TypeStateSerializer<List<T>> get typeStateSerializer => ListTypeStateSerializer<T>();
}
