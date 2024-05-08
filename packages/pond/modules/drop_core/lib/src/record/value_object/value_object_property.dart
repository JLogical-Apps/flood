import 'dart:async';

import 'package:drop_core/src/context/drop_core_context.dart';
import 'package:drop_core/src/query/query.dart';
import 'package:drop_core/src/record/entity.dart';
import 'package:drop_core/src/record/value_object.dart';
import 'package:drop_core/src/record/value_object/async_fallback_value_object_property.dart';
import 'package:drop_core/src/record/value_object/color_value_object_property.dart';
import 'package:drop_core/src/record/value_object/computed_value_object_property.dart';
import 'package:drop_core/src/record/value_object/currency_value_object_property.dart';
import 'package:drop_core/src/record/value_object/default_value_object_property.dart';
import 'package:drop_core/src/record/value_object/display_name_value_object_property.dart';
import 'package:drop_core/src/record/value_object/embedded_value_object_property.dart';
import 'package:drop_core/src/record/value_object/fallback_replacement_value_object_property.dart';
import 'package:drop_core/src/record/value_object/fallback_value_object_property.dart';
import 'package:drop_core/src/record/value_object/fallback_without_replacement_value_object_property.dart';
import 'package:drop_core/src/record/value_object/field_value_object_property.dart';
import 'package:drop_core/src/record/value_object/hidden_value_object_property.dart';
import 'package:drop_core/src/record/value_object/indexed_value_object_property.dart';
import 'package:drop_core/src/record/value_object/is_email_value_object_property.dart';
import 'package:drop_core/src/record/value_object/is_name_value_object_property.dart';
import 'package:drop_core/src/record/value_object/is_not_blank_value_object_property.dart';
import 'package:drop_core/src/record/value_object/is_phone_value_object_property.dart';
import 'package:drop_core/src/record/value_object/list_embedded_value_object_property.dart';
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

typedef SimpleValueObjectProperty<T> = ValueObjectProperty<T, dynamic, ValueObjectProperty>;

abstract class ValueObjectProperty<G, S, V extends ValueObjectProperty<dynamic, dynamic, dynamic>>
    implements ValueObjectBehavior {
  String get name;

  Type get getterType;

  Type get setterType;

  G get value;

  G? get valueOrNull;

  void set(S value);

  V copy();

  static FieldValueObjectProperty<T> field<T>({required String name}) {
    return FieldValueObjectProperty(name: name);
  }

  static ReferenceValueObjectProperty<E> reference<E extends Entity>({
    required String name,
    FutureOr<Query<E>> Function(DropCoreContext context)? searchQueryGetter,
    FutureOr<List<E>> Function(DropCoreContext context, List<E> results)? searchResultsFilter,
  }) {
    return ReferenceValueObjectProperty(
      name: name,
      searchQueryGetter: searchQueryGetter,
      searchResultsFilter: searchResultsFilter,
    );
  }

  static ComputedValueObjectProperty<T> computed<T>({
    required String name,
    required T Function() computation,
  }) {
    return ComputedValueObjectProperty(name: name, computation: computation);
  }

  static CreationTimeProperty creationTime() {
    return CreationTimeProperty();
  }
}

mixin IsValueObjectProperty<G, S, V extends ValueObjectProperty> implements ValueObjectProperty<G, S, V> {
  @override
  G? get valueOrNull => value;

  @override
  void fromState(DropCoreContext context, State state) {}

  @override
  State modifyState(DropCoreContext context, State state) {
    return state;
  }

  @override
  Future<State> modifyStateForRepository(DropCoreContext context, State state) async {
    return state;
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

extension ValueObjectPropertyExtensions<G, S, V extends ValueObjectProperty> on ValueObjectProperty<G, S, V> {
  void update(S Function(G value) updater) {
    set(updater(value));
  }

  ValidatorValueObjectProperty<G, S> withValidator(Validator<G, String> validator) {
    return ValidatorValueObjectProperty(property: this, validator: validator);
  }

  RequiredOnEditValueObjectProperty<G, S> requiredOnEdit([bool requiredOnEdit = true]) {
    return RequiredOnEditValueObjectProperty<G, S>(property: this, requiredOnEdit: requiredOnEdit);
  }

  PlaceholderValueObjectProperty<G, S> withPlaceholder(G Function() placeholder) {
    return PlaceholderValueObjectProperty(property: this, placeholder: placeholder);
  }

  DefaultValueObjectProperty<G, S> withDefault(G Function() defaultValueGetter) {
    return DefaultValueObjectProperty(property: this, defaultValueGetter: defaultValueGetter);
  }

  DisplayNameValueObjectProperty<G, S> withDisplayName(String? displayName) {
    return DisplayNameValueObjectProperty(property: this, displayNameGetter: () => displayName);
  }

  DisplayNameValueObjectProperty<G, S> withDynamicDisplayName(String? Function() displayNameGetter) {
    return DisplayNameValueObjectProperty(property: this, displayNameGetter: displayNameGetter);
  }

  HiddenValueObjectProperty<G, S> hidden([bool Function()? isHiddenGetter]) {
    return HiddenValueObjectProperty(property: this, isHiddenGetter: isHiddenGetter);
  }

  IndexedValueObjectProperty<G, S> indexed([bool Function()? isIndexedGetter]) {
    return IndexedValueObjectProperty(property: this, isIndexedGetter: isIndexedGetter);
  }
}

extension GetterSetterNullabeValueObjectPropertyExtensions<G, S, V extends ValueObjectProperty>
    on ValueObjectProperty<G?, S?, V> {
  RequiredValueObjectProperty<G, S> required() {
    return RequiredValueObjectProperty(property: this);
  }
}

extension GetterNullableValueObjectPropertyExtensions<G, S, V extends ValueObjectProperty>
    on ValueObjectProperty<G?, S, V> {
  FallbackValueObjectProperty<G, S> withFallback(G Function() fallback) {
    return FallbackValueObjectProperty(property: this, fallback: fallback);
  }

  FallbackWithoutReplacementValueObjectProperty<G, S> withFallbackWithoutReplacement(G Function() fallback) {
    return FallbackWithoutReplacementValueObjectProperty(property: this, fallback: fallback);
  }
}

extension NullableStringValueObjectPropertyExtensions<G extends String?, S extends String?,
    V extends ValueObjectProperty> on ValueObjectProperty<G, S, V> {
  IsNotBlankValueObjectProperty isNotBlank() {
    return IsNotBlankValueObjectProperty(property: this);
  }

  IsNameValueObjectProperty<G, S> isName() {
    return IsNameValueObjectProperty<G, S>(property: this);
  }

  IsEmailValueObjectProperty<G, S> isEmail() {
    return IsEmailValueObjectProperty<G, S>(property: this);
  }

  IsPhoneValueObjectProperty<G, S> isPhone() {
    return IsPhoneValueObjectProperty<G, S>(property: this);
  }

  MultilineValueObjectProperty<G, S> multiline([bool isMultiline = true]) {
    return MultilineValueObjectProperty<G, S>(property: this, isMultiline: isMultiline);
  }

  NullIfBlankValueObjectProperty<G, S> nullIfBlank() {
    return NullIfBlankValueObjectProperty<G, S>(property: this);
  }
}

extension TimestampValueObjectPropertyExtensions<G extends Timestamp?, S extends Timestamp?,
    V extends ValueObjectProperty> on ValueObjectProperty<G, S, V> {
  TimeValueObjectProperty<G, S> time() {
    return TimeValueObjectProperty<G, S>(property: this);
  }

  OnlyDateValueObjectProperty<G, S> onlyDate([bool onlyDate = true]) {
    return OnlyDateValueObjectProperty(property: this, onlyDate: onlyDate);
  }
}

extension ValueObjectValueObjectPropertyExtensions<G extends ValueObject?, S extends ValueObject?,
    V extends ValueObjectProperty> on ValueObjectProperty<G, S, V> {
  EmbeddedValueObjectProperty<G, S> embedded() {
    return EmbeddedValueObjectProperty<G, S>(property: this);
  }
}

extension NullableNumValueObjectPropertyExtensions<G extends num?, S extends num?, V extends ValueObjectProperty>
    on ValueObjectProperty<G, S, V> {
  ValidatorValueObjectProperty<G, S> isGreaterThan(num number) {
    return withValidator(Validator.isGreaterThan<G>(number).mapError((_) => 'Must be greater than [$number]!'));
  }

  ValidatorValueObjectProperty<G, S> isLessThan(num number) {
    return withValidator(Validator.isLessThan<G>(number).mapError((_) => 'Must be less than [$number]!'));
  }

  ValidatorValueObjectProperty<G, S> isGreaterThanOrEqualTo(num number) {
    return withValidator(
        Validator.isGreaterThanOrEqualTo<G>(number).mapError((_) => 'Must be greater than or equal to [$number]!'));
  }

  ValidatorValueObjectProperty<G, S> isLessThanOrEqualTo(num number) {
    return withValidator(Validator.isLessThanOrEqualTo<G>(number).mapError((_) => 'Must be less than [$number]!'));
  }

  ValidatorValueObjectProperty<G, S> isPositive() {
    return withValidator(Validator.isPositive<G>().mapError((_) => 'Must be positive!'));
  }

  ValidatorValueObjectProperty<G, S> isNegative() {
    return withValidator(Validator.isNegative<G>().mapError((_) => 'Must be negative!'));
  }

  ValidatorValueObjectProperty<G, S> isNonPositive() {
    return withValidator(Validator.isNonPositive<G>().mapError((_) => 'Cannot be positive!'));
  }

  ValidatorValueObjectProperty<G, S> isNonNegative() {
    return withValidator(Validator.isNonNegative<G>().mapError((_) => 'Cannot be negative!'));
  }
}

extension NullableIntValueObjectPropertyExtensions<G extends int?, S extends int?, V extends ValueObjectProperty>
    on ValueObjectProperty<G, S, V> {
  CurrencyValueObjectProperty<G, S> currency([bool isCurrency = true]) {
    return CurrencyValueObjectProperty<G, S>(property: this, isCurrency: isCurrency);
  }

  ColorValueObjectProperty<G, S> color([bool isColor = true]) {
    return ColorValueObjectProperty<G, S>(property: this, isColor: isColor);
  }
}

extension SameNullableGetterSetterValueObjectPropertyExtensions<T, V extends ValueObjectProperty>
    on ValueObjectProperty<T?, T?, V> {
  FallbackReplacementValueObjectProperty<T> withFallbackReplacement(T Function() fallbackReplacement) {
    return FallbackReplacementValueObjectProperty(property: this, fallbackReplacement: fallbackReplacement);
  }
}

extension SameGetterSetterValueObjectPropertyExtensions<T, V extends ValueObjectProperty>
    on ValueObjectProperty<T, T, V> {
  AsyncFallbackValueObjectProperty<T> withAsyncFallback(FutureOr<T> Function(DropCoreContext context) fallback) {
    return AsyncFallbackValueObjectProperty(property: this, fallback: fallback);
  }
}

extension FieldValueObjectPropertyExtensions<T> on FieldValueObjectProperty<T> {
  ListValueObjectProperty<T> list() {
    return ListValueObjectProperty(property: this);
  }

  MapValueObjectProperty<T, V> mapTo<V>() {
    return MapValueObjectProperty(property: this);
  }
}

extension ValueObjectListValueObjectPropertyExtensions<T extends ValueObject> on ListValueObjectProperty<T> {
  ListEmbeddedValueObjectProperty<T> embedded() {
    return ListEmbeddedValueObjectProperty<T>(property: this);
  }
}

abstract class ValueObjectPropertyWrapper<G, S, V extends ValueObjectProperty> implements ValueObjectProperty<G, S, V> {
  ValueObjectProperty<G, S, dynamic> get property;
}

mixin IsValueObjectPropertyWrapper<G, S, V extends ValueObjectProperty<G, S, V>>
    implements ValueObjectPropertyWrapper<G, S, V> {
  @override
  String get name => property.name;

  @override
  Type get getterType => property.getterType;

  @override
  Type get setterType => property.setterType;

  @override
  G get value => property.value;

  @override
  G? get valueOrNull => property.valueOrNull;

  @override
  void set(S value) => property.set(value);

  @override
  void fromState(DropCoreContext context, State state) => property.fromState(context, state);

  @override
  State modifyState(DropCoreContext context, State state) => property.modifyState(context, state);

  @override
  Future<State> modifyStateForRepository(DropCoreContext context, State state) =>
      property.modifyStateForRepository(context, state);

  @override
  FutureOr<String?> onValidate(ValueObject data) => property.validate(data);

  @override
  String toString() {
    return '$runtimeType{$name, $valueOrNull}';
  }
}
