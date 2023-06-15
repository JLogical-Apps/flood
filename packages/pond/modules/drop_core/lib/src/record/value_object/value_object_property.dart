import 'dart:async';

import 'package:drop_core/src/context/core_drop_context.dart';
import 'package:drop_core/src/record/entity.dart';
import 'package:drop_core/src/record/value_object.dart';
import 'package:drop_core/src/record/value_object/color_value_object_property.dart';
import 'package:drop_core/src/record/value_object/computed_value_object_property.dart';
import 'package:drop_core/src/record/value_object/currency_value_object_property.dart';
import 'package:drop_core/src/record/value_object/default_value_object_property.dart';
import 'package:drop_core/src/record/value_object/display_name_value_object_property.dart';
import 'package:drop_core/src/record/value_object/embedded_value_object_property.dart';
import 'package:drop_core/src/record/value_object/fallback_replacement_value_object_property.dart';
import 'package:drop_core/src/record/value_object/fallback_value_object_property.dart';
import 'package:drop_core/src/record/value_object/field_value_object_property.dart';
import 'package:drop_core/src/record/value_object/hidden_value_object_property.dart';
import 'package:drop_core/src/record/value_object/is_not_blank_value_object_property.dart';
import 'package:drop_core/src/record/value_object/list_value_object_property.dart';
import 'package:drop_core/src/record/value_object/map_value_object_property.dart';
import 'package:drop_core/src/record/value_object/multiline_value_object_property.dart';
import 'package:drop_core/src/record/value_object/null_if_blank_value_object_property.dart';
import 'package:drop_core/src/record/value_object/only_date_value_object_property.dart';
import 'package:drop_core/src/record/value_object/placeholder_value_object_property.dart';
import 'package:drop_core/src/record/value_object/reference_value_object_property.dart';
import 'package:drop_core/src/record/value_object/required_on_edit_value_object_property.dart';
import 'package:drop_core/src/record/value_object/required_value_object_property.dart';
import 'package:drop_core/src/record/value_object/time/creation_time_property.dart';
import 'package:drop_core/src/record/value_object/time/time_value_object_property.dart';
import 'package:drop_core/src/record/value_object/time/timestamp.dart';
import 'package:drop_core/src/record/value_object/validator_value_object_property.dart';
import 'package:drop_core/src/record/value_object/value_object_behavior.dart';
import 'package:drop_core/src/state/state.dart';
import 'package:utils_core/utils_core.dart';

abstract class ValueObjectProperty<G, S, L, V extends ValueObjectProperty<dynamic, dynamic, dynamic, dynamic>>
    implements ValueObjectBehavior {
  String get name;

  G get value;

  G? get valueOrNull;

  void set(S value);

  Future<L> load(CoreDropContext context);

  V copy();

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

  static CreationTimeProperty creationTime() {
    return CreationTimeProperty();
  }
}

mixin IsValueObjectProperty<G, S, L, V extends ValueObjectProperty> implements ValueObjectProperty<G, S, L, V> {
  @override
  G? get valueOrNull => value;

  @override
  void fromState(State state) {}

  @override
  State modifyState(State state) {
    return state;
  }

  @override
  Future<L> load(CoreDropContext context) {
    throw Exception('Load not supported!');
  }

  @override
  FutureOr<String?> onValidate(ValueObject data) async {
    return null;
  }

  @override
  String toString() {
    return '$runtimeType{$name, $valueOrNull}';
  }
}

extension ValueObjectPropertyExtensions<G, S, L, V extends ValueObjectProperty> on ValueObjectProperty<G, S, L, V> {
  Type get getterType => G;

  Type get setterType => S;

  Type get loadType => L;

  ValidatorValueObjectProperty<G, S, L> withValidator(Validator<G, String> validator) {
    return ValidatorValueObjectProperty(property: this, validator: validator);
  }

  RequiredOnEditValueObjectProperty<G, S, L> requiredOnEdit([bool requiredOnEdit = true]) {
    return RequiredOnEditValueObjectProperty<G, S, L>(property: this, requiredOnEdit: requiredOnEdit);
  }

  PlaceholderValueObjectProperty<G, S, L> withPlaceholder(G Function() placeholder) {
    return PlaceholderValueObjectProperty(property: this, placeholder: placeholder);
  }

  DefaultValueObjectProperty<G, S, L> withDefault(G Function() defaultValueGetter) {
    return DefaultValueObjectProperty(property: this, defaultValueGetter: defaultValueGetter);
  }

  DisplayNameValueObjectProperty<G, S, L> withDisplayName(String? displayName) {
    return DisplayNameValueObjectProperty(property: this, displayNameGetter: () => displayName);
  }

  DisplayNameValueObjectProperty<G, S, L> withDynamicDisplayName(String? Function() displayNameGetter) {
    return DisplayNameValueObjectProperty(property: this, displayNameGetter: displayNameGetter);
  }

  HiddenValueObjectProperty<G, S, L> hidden([bool Function()? isHiddenGetter]) {
    return HiddenValueObjectProperty(property: this, isHiddenGetter: isHiddenGetter);
  }
}

extension GetterSetterNullabeValueObjectPropertyExtensions<G, S, L, V extends ValueObjectProperty>
    on ValueObjectProperty<G?, S?, L, V> {
  RequiredValueObjectProperty<G, S, L> required() {
    return RequiredValueObjectProperty(property: this);
  }
}

extension GetterNullableValueObjectPropertyExtensions<G, S, L, V extends ValueObjectProperty>
    on ValueObjectProperty<G?, S, L, V> {
  FallbackValueObjectProperty<G, S, L> withFallback(G Function() fallback) {
    return FallbackValueObjectProperty(property: this, fallback: fallback);
  }
}

extension NullableStringValueObjectPropertyExtensions<G extends String?, S extends String?, L,
    V extends ValueObjectProperty> on ValueObjectProperty<G, S, L, V> {
  IsNotBlankValueObjectProperty<L> isNotBlank() {
    return IsNotBlankValueObjectProperty<L>(property: this);
  }

  MultilineValueObjectProperty<G, S, L> multiline([bool isMultiline = true]) {
    return MultilineValueObjectProperty<G, S, L>(property: this, isMultiline: isMultiline);
  }

  NullIfBlankValueObjectProperty<G, S, L> nullIfBlank() {
    return NullIfBlankValueObjectProperty<G, S, L>(property: this);
  }
}

extension TimestampValueObjectPropertyExtensions<G extends Timestamp?, S extends Timestamp?, L,
    V extends ValueObjectProperty> on ValueObjectProperty<G, S, L, V> {
  TimeValueObjectProperty<G, S, L> time() {
    return TimeValueObjectProperty<G, S, L>(property: this);
  }

  OnlyDateValueObjectProperty<G, S, L> onlyDate([bool onlyDate = true]) {
    return OnlyDateValueObjectProperty(property: this, onlyDate: onlyDate);
  }
}

extension ValueObjectValueObjectPropertyExtensions<G extends ValueObject?, S extends ValueObject?, L,
    V extends ValueObjectProperty> on ValueObjectProperty<G, S, L, V> {
  EmbeddedValueObjectProperty<G, S, L> embedded() {
    return EmbeddedValueObjectProperty<G, S, L>(property: this);
  }
}

extension NullableIntValueObjectPropertyExtensions<G extends int?, S extends int?, L, V extends ValueObjectProperty>
    on ValueObjectProperty<G, S, L, V> {
  CurrencyValueObjectProperty<G, S, L> currency([bool isCurrency = true]) {
    return CurrencyValueObjectProperty<G, S, L>(property: this, isCurrency: isCurrency);
  }

  ColorValueObjectProperty<G, S, L> color([bool isColor = true]) {
    return ColorValueObjectProperty<G, S, L>(property: this, isColor: isColor);
  }
}

extension SameNullableGetterSetterValueObjectPropertyExtensions<T, L, V extends ValueObjectProperty>
    on ValueObjectProperty<T?, T?, L, V> {
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

abstract class ValueObjectPropertyWrapper<G, S, L, V extends ValueObjectProperty>
    implements ValueObjectProperty<G, S, L, V> {
  ValueObjectProperty<G, S, L, dynamic> get property;
}

mixin IsValueObjectPropertyWrapper<G, S, L, V extends ValueObjectProperty<G, S, L, V>>
    implements ValueObjectPropertyWrapper<G, S, L, V> {
  @override
  String get name => property.name;

  @override
  G get value => property.value;

  @override
  G? get valueOrNull => property.valueOrNull;

  @override
  void set(S value) => property.set(value);

  @override
  void fromState(State state) => property.fromState(state);

  @override
  State modifyState(State state) => property.modifyState(state);

  @override
  Future<L> load(CoreDropContext context) => property.load(context);

  @override
  FutureOr<String?> onValidate(ValueObject data) => property.validate(data);

  @override
  String toString() {
    return '$runtimeType{$name, $valueOrNull}';
  }
}
