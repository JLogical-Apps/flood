// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'future_value.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$FutureValueTearOff {
  const _$FutureValueTearOff();

  FutureValueInitial<T> initial<T>() {
    return FutureValueInitial<T>();
  }

  FutureValueLoaded<T> loaded<T>({required T value}) {
    return FutureValueLoaded<T>(
      value: value,
    );
  }

  FutureValueError<T> error<T>({Object? error}) {
    return FutureValueError<T>(
      error: error,
    );
  }
}

/// @nodoc
const $FutureValue = _$FutureValueTearOff();

/// @nodoc
mixin _$FutureValue<T> {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(T value) loaded,
    required TResult Function(Object? error) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(T value)? loaded,
    TResult Function(Object? error)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FutureValueInitial<T> value) initial,
    required TResult Function(FutureValueLoaded<T> value) loaded,
    required TResult Function(FutureValueError<T> value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FutureValueInitial<T> value)? initial,
    TResult Function(FutureValueLoaded<T> value)? loaded,
    TResult Function(FutureValueError<T> value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FutureValueCopyWith<T, $Res> {
  factory $FutureValueCopyWith(
          FutureValue<T> value, $Res Function(FutureValue<T>) then) =
      _$FutureValueCopyWithImpl<T, $Res>;
}

/// @nodoc
class _$FutureValueCopyWithImpl<T, $Res>
    implements $FutureValueCopyWith<T, $Res> {
  _$FutureValueCopyWithImpl(this._value, this._then);

  final FutureValue<T> _value;
  // ignore: unused_field
  final $Res Function(FutureValue<T>) _then;
}

/// @nodoc
abstract class $FutureValueInitialCopyWith<T, $Res> {
  factory $FutureValueInitialCopyWith(FutureValueInitial<T> value,
          $Res Function(FutureValueInitial<T>) then) =
      _$FutureValueInitialCopyWithImpl<T, $Res>;
}

/// @nodoc
class _$FutureValueInitialCopyWithImpl<T, $Res>
    extends _$FutureValueCopyWithImpl<T, $Res>
    implements $FutureValueInitialCopyWith<T, $Res> {
  _$FutureValueInitialCopyWithImpl(
      FutureValueInitial<T> _value, $Res Function(FutureValueInitial<T>) _then)
      : super(_value, (v) => _then(v as FutureValueInitial<T>));

  @override
  FutureValueInitial<T> get _value => super._value as FutureValueInitial<T>;
}

/// @nodoc
class _$FutureValueInitial<T> extends FutureValueInitial<T> {
  const _$FutureValueInitial() : super._();

  @override
  String toString() {
    return 'FutureValue<$T>.initial()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is FutureValueInitial<T>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(T value) loaded,
    required TResult Function(Object? error) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(T value)? loaded,
    TResult Function(Object? error)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FutureValueInitial<T> value) initial,
    required TResult Function(FutureValueLoaded<T> value) loaded,
    required TResult Function(FutureValueError<T> value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FutureValueInitial<T> value)? initial,
    TResult Function(FutureValueLoaded<T> value)? loaded,
    TResult Function(FutureValueError<T> value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class FutureValueInitial<T> extends FutureValue<T> {
  const factory FutureValueInitial() = _$FutureValueInitial<T>;
  const FutureValueInitial._() : super._();
}

/// @nodoc
abstract class $FutureValueLoadedCopyWith<T, $Res> {
  factory $FutureValueLoadedCopyWith(FutureValueLoaded<T> value,
          $Res Function(FutureValueLoaded<T>) then) =
      _$FutureValueLoadedCopyWithImpl<T, $Res>;
  $Res call({T value});
}

/// @nodoc
class _$FutureValueLoadedCopyWithImpl<T, $Res>
    extends _$FutureValueCopyWithImpl<T, $Res>
    implements $FutureValueLoadedCopyWith<T, $Res> {
  _$FutureValueLoadedCopyWithImpl(
      FutureValueLoaded<T> _value, $Res Function(FutureValueLoaded<T>) _then)
      : super(_value, (v) => _then(v as FutureValueLoaded<T>));

  @override
  FutureValueLoaded<T> get _value => super._value as FutureValueLoaded<T>;

  @override
  $Res call({
    Object? value = freezed,
  }) {
    return _then(FutureValueLoaded<T>(
      value: value == freezed
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as T,
    ));
  }
}

/// @nodoc
class _$FutureValueLoaded<T> extends FutureValueLoaded<T> {
  const _$FutureValueLoaded({required this.value}) : super._();

  @override
  final T value;

  @override
  String toString() {
    return 'FutureValue<$T>.loaded(value: $value)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is FutureValueLoaded<T> &&
            (identical(other.value, value) ||
                const DeepCollectionEquality().equals(other.value, value)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(value);

  @JsonKey(ignore: true)
  @override
  $FutureValueLoadedCopyWith<T, FutureValueLoaded<T>> get copyWith =>
      _$FutureValueLoadedCopyWithImpl<T, FutureValueLoaded<T>>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(T value) loaded,
    required TResult Function(Object? error) error,
  }) {
    return loaded(value);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(T value)? loaded,
    TResult Function(Object? error)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(value);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FutureValueInitial<T> value) initial,
    required TResult Function(FutureValueLoaded<T> value) loaded,
    required TResult Function(FutureValueError<T> value) error,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FutureValueInitial<T> value)? initial,
    TResult Function(FutureValueLoaded<T> value)? loaded,
    TResult Function(FutureValueError<T> value)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class FutureValueLoaded<T> extends FutureValue<T> {
  const factory FutureValueLoaded({required T value}) = _$FutureValueLoaded<T>;
  const FutureValueLoaded._() : super._();

  T get value => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FutureValueLoadedCopyWith<T, FutureValueLoaded<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FutureValueErrorCopyWith<T, $Res> {
  factory $FutureValueErrorCopyWith(
          FutureValueError<T> value, $Res Function(FutureValueError<T>) then) =
      _$FutureValueErrorCopyWithImpl<T, $Res>;
  $Res call({Object? error});
}

/// @nodoc
class _$FutureValueErrorCopyWithImpl<T, $Res>
    extends _$FutureValueCopyWithImpl<T, $Res>
    implements $FutureValueErrorCopyWith<T, $Res> {
  _$FutureValueErrorCopyWithImpl(
      FutureValueError<T> _value, $Res Function(FutureValueError<T>) _then)
      : super(_value, (v) => _then(v as FutureValueError<T>));

  @override
  FutureValueError<T> get _value => super._value as FutureValueError<T>;

  @override
  $Res call({
    Object? error = freezed,
  }) {
    return _then(FutureValueError<T>(
      error: error == freezed ? _value.error : error,
    ));
  }
}

/// @nodoc
class _$FutureValueError<T> extends FutureValueError<T> {
  const _$FutureValueError({this.error}) : super._();

  @override
  final Object? error;

  @override
  String toString() {
    return 'FutureValue<$T>.error(error: $error)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is FutureValueError<T> &&
            (identical(other.error, error) ||
                const DeepCollectionEquality().equals(other.error, error)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(error);

  @JsonKey(ignore: true)
  @override
  $FutureValueErrorCopyWith<T, FutureValueError<T>> get copyWith =>
      _$FutureValueErrorCopyWithImpl<T, FutureValueError<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(T value) loaded,
    required TResult Function(Object? error) error,
  }) {
    return error(this.error);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(T value)? loaded,
    TResult Function(Object? error)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this.error);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FutureValueInitial<T> value) initial,
    required TResult Function(FutureValueLoaded<T> value) loaded,
    required TResult Function(FutureValueError<T> value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FutureValueInitial<T> value)? initial,
    TResult Function(FutureValueLoaded<T> value)? loaded,
    TResult Function(FutureValueError<T> value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class FutureValueError<T> extends FutureValue<T> {
  const factory FutureValueError({Object? error}) = _$FutureValueError<T>;
  const FutureValueError._() : super._();

  Object? get error => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FutureValueErrorCopyWith<T, FutureValueError<T>> get copyWith =>
      throw _privateConstructorUsedError;
}
