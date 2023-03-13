import 'package:drop_core/src/context/drop_core_context.dart';
import 'package:drop_core/src/record/entity.dart';
import 'package:drop_core/src/record/value_object/computed_value_object_property.dart';
import 'package:drop_core/src/record/value_object/fallback_replacement_value_object_property.dart';
import 'package:drop_core/src/record/value_object/fallback_value_object_property.dart';
import 'package:drop_core/src/record/value_object/field_value_object_property.dart';
import 'package:drop_core/src/record/value_object/is_not_blank_value_object_property.dart';
import 'package:drop_core/src/record/value_object/list_value_object_property.dart';
import 'package:drop_core/src/record/value_object/map_value_object_property.dart';
import 'package:drop_core/src/record/value_object/placeholder_value_object_property.dart';
import 'package:drop_core/src/record/value_object/reference_value_object_property.dart';
import 'package:drop_core/src/record/value_object/required_value_object_property.dart';
import 'package:drop_core/src/record/value_object/value_object_behavior.dart';
import 'package:drop_core/src/state/state.dart';

abstract class ValueObjectProperty<G, S, L> extends ValueObjectBehavior {
  G get value;

  void set(S value);

  Future<L> load(DropCoreContext context);

  static FieldValueObjectProperty<T, dynamic> field<T>({required String name}) {
    return FieldValueObjectProperty(name: name);
  }

  static ReferenceValueObjectProperty<E> reference<E extends Entity>({required String name}) {
    return ReferenceValueObjectProperty(name: name);
  }

  static ComputedValueObjectProperty<T, dynamic> computed<T>({
    required String name,
    required T Function() computation,
  }) {
    return ComputedValueObjectProperty(name: name, computation: computation);
  }
}

mixin IsValueObjectProperty<G, S, L> implements ValueObjectProperty<G, S, L> {
  @override
  Future<L> load(DropCoreContext context) {
    throw Exception('Load not supported!');
  }

  @override
  State modifyStateUnsafe(State state) {
    return modifyState(state);
  }
}

extension ValueObjectPropertyExtensions<G, S, L> on ValueObjectProperty<G, S, L> {
  PlaceholderValueObjectProperty<G, S, L> withPlaceholder(G Function() placeholder) {
    return PlaceholderValueObjectProperty(property: this, placeholder: placeholder);
  }
}

extension NullableValueObjectPropertyExtensions<G, S, L> on ValueObjectProperty<G?, S, L> {
  RequiredValueObjectProperty<G, S, L> required() {
    return RequiredValueObjectProperty(property: this);
  }

  FallbackValueObjectProperty<G, S, L> withFallback(G Function() fallback) {
    return FallbackValueObjectProperty(property: this, fallback: fallback);
  }
}

extension NullableStringValueObjectPropertyExtensions<L> on ValueObjectProperty<String?, String?, L> {
  IsNotBlankValueObjectProperty<L> isNotBlank() {
    return IsNotBlankValueObjectProperty(property: this);
  }
}

extension SameGetterSetterValueObjectPropertyExtensions<T, L> on ValueObjectProperty<T, T, L> {
  FallbackReplacementValueObjectProperty<T, L> withFallbackReplacement(T Function() fallbackReplacement) {
    return FallbackReplacementValueObjectProperty(property: this, fallbackReplacement: fallbackReplacement);
  }
}

extension FieldValueObjectPropertyExtensions<T, L> on FieldValueObjectProperty<T, L> {
  ListValueObjectProperty<T, L> list() {
    return ListValueObjectProperty(property: this);
  }

  MapValueObjectProperty<T, V, L> mapTo<V>() {
    return MapValueObjectProperty(property: this);
  }
}

abstract class ValueObjectPropertyWrapper<G, S, L> implements ValueObjectProperty<G, S, L> {
  ValueObjectProperty<G, S, L> get property;
}

mixin IsValueObjectPropertyWrapper<G, S, L> implements ValueObjectPropertyWrapper<G, S, L> {
  @override
  G get value => property.value;

  @override
  void set(S value) => property.set(value);

  @override
  void fromState(State state) => property.fromState(state);

  @override
  State modifyState(State state) => property.modifyState(state);

  @override
  State modifyStateUnsafe(State state) => property.modifyStateUnsafe(state);
}
