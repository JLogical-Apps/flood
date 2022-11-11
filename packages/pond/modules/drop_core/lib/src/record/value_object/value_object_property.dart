import 'package:drop_core/src/record/value_object/fallback_value_object_property.dart';
import 'package:drop_core/src/record/value_object/field_value_object_property.dart';
import 'package:drop_core/src/record/value_object/required_value_object_property.dart';
import 'package:drop_core/src/record/value_object/value_object_behavior.dart';
import 'package:drop_core/src/state/state.dart';

abstract class ValueObjectProperty<G, S> extends ValueObjectBehavior {
  G get value;

  void set(S value);

  @override
  void fromState(State state);

  @override
  State modifyState(State state);

  static FieldValueObjectProperty<T> field<T>({required String name}) {
    return FieldValueObjectProperty(name: name);
  }
}

mixin IsValueObjectProperty<G, S> implements ValueObjectProperty<G, S> {}

extension NullableValueObjectProperty<G, S> on ValueObjectProperty<G?, S> {
  RequiredValueObjectProperty<G, S> required() {
    return RequiredValueObjectProperty(property: this);
  }

  FallbackValueObjectProperty<G, S> withFallback(G Function() fallback) {
    return FallbackValueObjectProperty(property: this, fallback: fallback);
  }
}

abstract class ValueObjectPropertyWrapper<G, S> implements ValueObjectProperty<G, S> {
  ValueObjectProperty<G, S> get property;
}

mixin IsValueObjectPropertyWrapper<G, S> implements ValueObjectPropertyWrapper<G, S> {
  @override
  G get value => property.value;

  @override
  void set(S value) => property.set(value);

  @override
  void fromState(State state) => property.fromState(state);

  @override
  State modifyState(State state) => property.modifyState(state);
}
