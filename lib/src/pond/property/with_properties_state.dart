import 'package:collection/collection.dart';
import 'package:jlogical_utils/src/patterns/export_core.dart';
import 'package:jlogical_utils/src/pond/property/property.dart';
import 'package:jlogical_utils/src/pond/record/record.dart';
import 'package:jlogical_utils/src/pond/state/state.dart';
import 'package:jlogical_utils/src/pond/utils/resolvable.dart';
import 'package:jlogical_utils/src/utils/export_core.dart';

mixin WithPropertiesState on Record {
  List<Property> get properties => [];
  Map<String, dynamic> extraValues = {};

  State get state => State(
        values: {
          ...extraValues,
          ...properties.map((property) => MapEntry(property.name, property.toStateValue())).toMap(),
        },
        type: '$runtimeType',
      );

  set state(State state) {
    extraValues.clear();
    state.values.forEach((key, value) {
      final property = properties.firstWhereOrNull((property) => property.name == key);
      if (property == null) {
        extraValues[key] = value;
      } else {
        property.fromStateValue(value);
      }
    });
  }

  @override
  void validateRecord() {
    properties.forEach((element) => element.validateSync(null));
  }

  Future resolve() async {
    return Future.wait(properties
        .where((property) => property is Resolvable)
        .map((property) => property as Resolvable)
        .map((resolvableProperty) => resolvableProperty.resolve()));
  }
}
