import 'package:jlogical_utils/src/pond/property/property.dart';
import 'package:jlogical_utils/src/pond/state/state.dart';
import 'package:jlogical_utils/src/utils/collection_extensions.dart';

mixin WithPropertiesState {
  List<Property> get properties => [];

  State generatePropertiesState(String? id) => State(
        id: id,
        values: properties.map((property) => MapEntry(property.name, property.toStateValue())).toMap(),
      );

  void inflateProperties(State state) {
    properties
        .where((property) => state.values.containsKey(property.name))
        .forEach((property) => property.fromStateValue(state.values[property.name]));
  }
}
