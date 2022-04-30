import 'package:jlogical_utils/src/pond/type_state_serializers/list_type_state_serializer.dart';

import '../type_state_serializers/type_state_serializer.dart';
import 'computed_property.dart';

class ListComputedProperty<T> extends ComputedProperty<List<T>> {
  ListComputedProperty({required String name, required List<T> Function() computation})
      : super(
          name: name,
          computation: computation,
        );

  @override
  TypeStateSerializer get typeStateSerializer => ListTypeStateSerializer<T>();
}
