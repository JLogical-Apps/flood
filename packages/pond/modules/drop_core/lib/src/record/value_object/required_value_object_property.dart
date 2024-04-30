import 'dart:async';

import 'package:drop_core/src/record/value_object.dart';
import 'package:drop_core/src/record/value_object/value_object_property.dart';
import 'package:drop_core/src/state/state.dart';
import 'package:utils_core/utils_core.dart';

class RequiredValueObjectProperty<T, S> with IsValueObjectProperty<T, S, RequiredValueObjectProperty<T, S>> {
  final ValueObjectProperty<T?, S?, dynamic> property;

  @override
  final Type getterType;
  @override
  final Type setterType;

  RequiredValueObjectProperty({required this.property})
      : getterType = T,
        setterType = S;

  @override
  State modifyState(State state) {
    return property.modifyState(state);
  }

  @override
  void fromState(State state) {
    property.fromState(state);
  }

  @override
  T get value => property.value ?? (throw Exception('Required property [$property]!'));

  @override
  T? get valueOrNull => property.valueOrNull;

  @override
  void set(S value) => property.set(value ?? (throw Exception('Required property [$property]!')));

  @override
  FutureOr<String?> onValidate(ValueObject data) {
    if (property.value == null) {
      return 'Required property [$property]!';
    }

    return property.validate(data);
  }

  @override
  RequiredValueObjectProperty<T, S> copy() {
    return RequiredValueObjectProperty<T, S>(property: property.copy());
  }

  @override
  String get name => property.name;
}
