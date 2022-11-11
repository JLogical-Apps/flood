import 'package:drop_core/drop_core.dart';
import 'package:drop_core/src/record/value_object/field_value_object_property.dart';
import 'package:drop_core/src/record/value_object/required_value_object_property.dart';
import 'package:drop_core/src/record/value_object/value_object_behavior.dart';
import 'package:drop_core/src/state/state.dart';

abstract class ValueObjectProperty<T> extends ValueObjectBehavior {
  T get value;

  set value(T value);

  @override
  void fromState(State state);

  @override
  State modifyState(State state);

  static FieldValueObjectProperty<T> field<T>({required String name}) {
    return FieldValueObjectProperty(name: name);
  }
}

mixin IsValueObjectProperty<T> implements ValueObjectProperty<T> {}

extension NullableValueObjectProperty<T> on ValueObjectProperty<T?> {
  RequiredValueObjectProperty<T> required() {
    return RequiredValueObjectProperty(property: this);
  }
}

abstract class ValueObjectPropertyWrapper<T> implements ValueObjectProperty<T> {
  ValueObjectProperty<T> get property;
}

mixin IsValueObjectPropertyWrapper<T> implements ValueObjectPropertyWrapper<T> {
  @override
  T get value => property.value;

  @override
  set value(T value) => property.value = value;

  @override
  void fromState(State state) => property.fromState(state);

  @override
  State modifyState(State state) => property.modifyState(state);
}
