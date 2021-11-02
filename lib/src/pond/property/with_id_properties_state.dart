import 'package:jlogical_utils/src/pond/export.dart';
import 'package:jlogical_utils/src/utils/collection_extensions.dart';

mixin WithIdPropertiesState on Entity {
  List<Property> get properties => [];

  State get state => State(
        id: id,
        values: properties.map((property) => MapEntry(property.name, property.toStateValue())).toMap(),
      );

  set state(State state) {
    properties
        .where((property) => state.values.containsKey(property.name))
        .forEach((property) => property.fromStateValue(state.values[property.name]));
  }
}
