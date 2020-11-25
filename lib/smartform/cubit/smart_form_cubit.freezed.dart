// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'smart_form_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
class _$SmartFormStateTearOff {
  const _$SmartFormStateTearOff();

// ignore: unused_element
  _SmartFormState call(
      {@required Map<String, dynamic> nameToValueMap,
      @required Map<String, dynamic> nameToInitialValueMap,
      @required Map<String, String> nameToErrorMap,
      @required Map<String, Validator> nameToValidatorMap}) {
    return _SmartFormState(
      nameToValueMap: nameToValueMap,
      nameToInitialValueMap: nameToInitialValueMap,
      nameToErrorMap: nameToErrorMap,
      nameToValidatorMap: nameToValidatorMap,
    );
  }
}

/// @nodoc
// ignore: unused_element
const $SmartFormState = _$SmartFormStateTearOff();

/// @nodoc
mixin _$SmartFormState {
  /// Maps the [name] of a field to its value.
  Map<String, dynamic> get nameToValueMap;

  /// Maps the [name] of a field to its initial value.
  Map<String, dynamic> get nameToInitialValueMap;

  /// Maps the [name] of a field to its error.
  Map<String, String> get nameToErrorMap;

  /// Maps the [name] of a field to its validator.
  Map<String, Validator> get nameToValidatorMap;

  $SmartFormStateCopyWith<SmartFormState> get copyWith;
}

/// @nodoc
abstract class $SmartFormStateCopyWith<$Res> {
  factory $SmartFormStateCopyWith(
          SmartFormState value, $Res Function(SmartFormState) then) =
      _$SmartFormStateCopyWithImpl<$Res>;
  $Res call(
      {Map<String, dynamic> nameToValueMap,
      Map<String, dynamic> nameToInitialValueMap,
      Map<String, String> nameToErrorMap,
      Map<String, Validator> nameToValidatorMap});
}

/// @nodoc
class _$SmartFormStateCopyWithImpl<$Res>
    implements $SmartFormStateCopyWith<$Res> {
  _$SmartFormStateCopyWithImpl(this._value, this._then);

  final SmartFormState _value;
  // ignore: unused_field
  final $Res Function(SmartFormState) _then;

  @override
  $Res call({
    Object nameToValueMap = freezed,
    Object nameToInitialValueMap = freezed,
    Object nameToErrorMap = freezed,
    Object nameToValidatorMap = freezed,
  }) {
    return _then(_value.copyWith(
      nameToValueMap: nameToValueMap == freezed
          ? _value.nameToValueMap
          : nameToValueMap as Map<String, dynamic>,
      nameToInitialValueMap: nameToInitialValueMap == freezed
          ? _value.nameToInitialValueMap
          : nameToInitialValueMap as Map<String, dynamic>,
      nameToErrorMap: nameToErrorMap == freezed
          ? _value.nameToErrorMap
          : nameToErrorMap as Map<String, String>,
      nameToValidatorMap: nameToValidatorMap == freezed
          ? _value.nameToValidatorMap
          : nameToValidatorMap as Map<String, Validator>,
    ));
  }
}

/// @nodoc
abstract class _$SmartFormStateCopyWith<$Res>
    implements $SmartFormStateCopyWith<$Res> {
  factory _$SmartFormStateCopyWith(
          _SmartFormState value, $Res Function(_SmartFormState) then) =
      __$SmartFormStateCopyWithImpl<$Res>;
  @override
  $Res call(
      {Map<String, dynamic> nameToValueMap,
      Map<String, dynamic> nameToInitialValueMap,
      Map<String, String> nameToErrorMap,
      Map<String, Validator> nameToValidatorMap});
}

/// @nodoc
class __$SmartFormStateCopyWithImpl<$Res>
    extends _$SmartFormStateCopyWithImpl<$Res>
    implements _$SmartFormStateCopyWith<$Res> {
  __$SmartFormStateCopyWithImpl(
      _SmartFormState _value, $Res Function(_SmartFormState) _then)
      : super(_value, (v) => _then(v as _SmartFormState));

  @override
  _SmartFormState get _value => super._value as _SmartFormState;

  @override
  $Res call({
    Object nameToValueMap = freezed,
    Object nameToInitialValueMap = freezed,
    Object nameToErrorMap = freezed,
    Object nameToValidatorMap = freezed,
  }) {
    return _then(_SmartFormState(
      nameToValueMap: nameToValueMap == freezed
          ? _value.nameToValueMap
          : nameToValueMap as Map<String, dynamic>,
      nameToInitialValueMap: nameToInitialValueMap == freezed
          ? _value.nameToInitialValueMap
          : nameToInitialValueMap as Map<String, dynamic>,
      nameToErrorMap: nameToErrorMap == freezed
          ? _value.nameToErrorMap
          : nameToErrorMap as Map<String, String>,
      nameToValidatorMap: nameToValidatorMap == freezed
          ? _value.nameToValidatorMap
          : nameToValidatorMap as Map<String, Validator>,
    ));
  }
}

/// @nodoc
class _$_SmartFormState implements _SmartFormState {
  const _$_SmartFormState(
      {@required this.nameToValueMap,
      @required this.nameToInitialValueMap,
      @required this.nameToErrorMap,
      @required this.nameToValidatorMap})
      : assert(nameToValueMap != null),
        assert(nameToInitialValueMap != null),
        assert(nameToErrorMap != null),
        assert(nameToValidatorMap != null);

  @override

  /// Maps the [name] of a field to its value.
  final Map<String, dynamic> nameToValueMap;
  @override

  /// Maps the [name] of a field to its initial value.
  final Map<String, dynamic> nameToInitialValueMap;
  @override

  /// Maps the [name] of a field to its error.
  final Map<String, String> nameToErrorMap;
  @override

  /// Maps the [name] of a field to its validator.
  final Map<String, Validator> nameToValidatorMap;

  @override
  String toString() {
    return 'SmartFormState(nameToValueMap: $nameToValueMap, nameToInitialValueMap: $nameToInitialValueMap, nameToErrorMap: $nameToErrorMap, nameToValidatorMap: $nameToValidatorMap)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _SmartFormState &&
            (identical(other.nameToValueMap, nameToValueMap) ||
                const DeepCollectionEquality()
                    .equals(other.nameToValueMap, nameToValueMap)) &&
            (identical(other.nameToInitialValueMap, nameToInitialValueMap) ||
                const DeepCollectionEquality().equals(
                    other.nameToInitialValueMap, nameToInitialValueMap)) &&
            (identical(other.nameToErrorMap, nameToErrorMap) ||
                const DeepCollectionEquality()
                    .equals(other.nameToErrorMap, nameToErrorMap)) &&
            (identical(other.nameToValidatorMap, nameToValidatorMap) ||
                const DeepCollectionEquality()
                    .equals(other.nameToValidatorMap, nameToValidatorMap)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(nameToValueMap) ^
      const DeepCollectionEquality().hash(nameToInitialValueMap) ^
      const DeepCollectionEquality().hash(nameToErrorMap) ^
      const DeepCollectionEquality().hash(nameToValidatorMap);

  @override
  _$SmartFormStateCopyWith<_SmartFormState> get copyWith =>
      __$SmartFormStateCopyWithImpl<_SmartFormState>(this, _$identity);
}

abstract class _SmartFormState implements SmartFormState {
  const factory _SmartFormState(
      {@required Map<String, dynamic> nameToValueMap,
      @required Map<String, dynamic> nameToInitialValueMap,
      @required Map<String, String> nameToErrorMap,
      @required Map<String, Validator> nameToValidatorMap}) = _$_SmartFormState;

  @override

  /// Maps the [name] of a field to its value.
  Map<String, dynamic> get nameToValueMap;
  @override

  /// Maps the [name] of a field to its initial value.
  Map<String, dynamic> get nameToInitialValueMap;
  @override

  /// Maps the [name] of a field to its error.
  Map<String, String> get nameToErrorMap;
  @override

  /// Maps the [name] of a field to its validator.
  Map<String, Validator> get nameToValidatorMap;
  @override
  _$SmartFormStateCopyWith<_SmartFormState> get copyWith;
}
