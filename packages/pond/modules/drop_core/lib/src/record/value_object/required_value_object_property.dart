import 'dart:async';

import 'package:drop_core/src/record/value_object.dart';
import 'package:drop_core/src/record/value_object/value_object_property.dart';
import 'package:utils_core/utils_core.dart';

class RequiredValueObjectProperty<T, S> with IsValueObjectPropertyWrapper<T, S, RequiredValueObjectProperty<T, S>> {
  @override
  final ValueObjectProperty<T, S, dynamic> property;

  @override
  final Type getterType;

  @override
  final Type setterType;

  RequiredValueObjectProperty({required this.property})
      : getterType = T,
        setterType = S;

  RequiredValueObjectProperty.fromProperty({required ValueObjectProperty<T?, S?, ValueObjectProperty> property})
      : property = property.withMapper<T, S>(
          getMapper: (value) => value ?? (throw Exception('Required property [$property]!')),
          setMapper: (value) => value ?? (throw Exception('Required property [$property]!')),
        ),
        getterType = T,
        setterType = S;

  @override
  T? get valueOrNull => guard(() => property.value);

  @override
  RequiredValueObjectProperty<T, S> copy() {
    return RequiredValueObjectProperty<T, S>(property: property.copy());
  }

  @override
  FutureOr<String?> onValidate(ValueObject data) {
    if (valueOrNull == null) {
      return 'Required property [$property]!';
    }

    return property.validate(data);
  }
}
