import 'dart:async';

import 'package:drop_core/src/record/value_object.dart';
import 'package:drop_core/src/record/value_object/value_object_property.dart';
import 'package:drop_core/src/state/state.dart';
import 'package:utils_core/utils_core.dart';

class IsNotBlankValueObjectProperty with IsValueObjectProperty<String, String, IsNotBlankValueObjectProperty> {
  final ValueObjectProperty<String?, String?, dynamic> property;

  IsNotBlankValueObjectProperty({required this.property});

  @override
  Type get getterType => String;

  @override
  Type get setterType => String;

  @override
  State modifyState(State state) {
    return property.modifyState(state);
  }

  @override
  void fromState(State state) {
    property.fromState(state);
  }

  @override
  FutureOr<String?> onValidate(ValueObject data) {
    if (property.value == null || property.value!.isBlank) {
      return 'Cannot be blank! [$property]';
    }

    return property.validate(data);
  }

  @override
  String get value => property.value == null || property.value!.isBlank
      ? (throw Exception('Cannot be blank! [$property]'))
      : property.value!;

  @override
  String? get valueOrNull => property.valueOrNull;

  @override
  void set(String value) => property.set(value.nullIfBlank ?? (throw Exception('Cannot be blank! [$property]')));

  @override
  IsNotBlankValueObjectProperty copy() {
    return IsNotBlankValueObjectProperty(property: property.copy());
  }

  @override
  String get name => property.name;
}
