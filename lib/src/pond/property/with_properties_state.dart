import 'package:jlogical_utils/src/pond/export.dart';
import 'package:jlogical_utils/src/pond/property/property.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';
import 'package:jlogical_utils/src/pond/state/state.dart';
import 'package:jlogical_utils/src/utils/collection_extensions.dart';

mixin WithPropertiesState on Record {
  List<Property> get properties => [];

  State get state => State(
        values: properties.map((property) => MapEntry(property.name, property.toStateValue())).toMap(),
      );

  set state(State state) {
    properties
        .where((property) => state.values.containsKey(property.name))
        .forEach((property) => property.fromStateValue(state.values[property.name]));
  }

  List<Validator> get validators => [];
}
