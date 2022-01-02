import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:jlogical_utils/src/pond/type_state_serializers/list_type_state_serializer.dart';

class ListComputedProperty<T> extends ComputedProperty<List<T>> {
  ListComputedProperty({required String name, required List<T> Function() computation})
      : super(
          name: name,
          computation: computation,
        );

  @override
  TypeStateSerializer get typeStateSerializer => ListTypeStateSerializer<T>();
}
