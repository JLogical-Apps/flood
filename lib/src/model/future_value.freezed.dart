// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'future_value.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
class _$FutureValueTearOff {
  const _$FutureValueTearOff();

// ignore: unused_element
  FutureValueInitial<T> initial<T>() {
    return FutureValueInitial<T>();
  }

// ignore: unused_element
  FutureValueLoaded<T> loaded<T>({T model}) {
    return FutureValueLoaded<T>(
      model: model,
    );
  }

// ignore: unused_element
  FutureValueError<T> error<T>({dynamic error}) {
    return FutureValueError<T>(
      error: error,
    );
  }
}

/// @nodoc
// ignore: unused_element
const $FutureValue = _$FutureValueTearOff();

/// @nodoc
mixin _$FutureValue<T> {
  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required TResult initial(),
    @required TResult loaded(T model),
    @required TResult error(dynamic error),
  });
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult initial(),
    TResult loaded(T model),
    TResult error(dynamic error),
    @required TResult orElse(),
  });
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult initial(FutureValueInitial<T> value),
    @required TResult loaded(FutureValueLoaded<T> value),
    @required TResult error(FutureValueError<T> value),
  });
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult initial(FutureValueInitial<T> value),
    TResult loaded(FutureValueLoaded<T> value),
    TResult error(FutureValueError<T> value),
    @required TResult orElse(),
  });
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
class _$FutureValueInitial<T> implements FutureValueInitial<T> {
  const _$FutureValueInitial();

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
  TResult when<TResult extends Object>({
    @required TResult initial(),
    @required TResult loaded(T model),
    @required TResult error(dynamic error),
  }) {
    assert(initial != null);
    assert(loaded != null);
    assert(error != null);
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult initial(),
    TResult loaded(T model),
    TResult error(dynamic error),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult initial(FutureValueInitial<T> value),
    @required TResult loaded(FutureValueLoaded<T> value),
    @required TResult error(FutureValueError<T> value),
  }) {
    assert(initial != null);
    assert(loaded != null);
    assert(error != null);
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult initial(FutureValueInitial<T> value),
    TResult loaded(FutureValueLoaded<T> value),
    TResult error(FutureValueError<T> value),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class FutureValueInitial<T> implements FutureValue<T> {
  const factory FutureValueInitial() = _$FutureValueInitial<T>;
}

/// @nodoc
abstract class $FutureValueLoadedCopyWith<T, $Res> {
  factory $FutureValueLoadedCopyWith(FutureValueLoaded<T> value,
          $Res Function(FutureValueLoaded<T>) then) =
      _$FutureValueLoadedCopyWithImpl<T, $Res>;
  $Res call({T model});
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
    Object model = freezed,
  }) {
    return _then(FutureValueLoaded<T>(
      model: model == freezed ? _value.model : model as T,
    ));
  }
}

/// @nodoc
class _$FutureValueLoaded<T> implements FutureValueLoaded<T> {
  const _$FutureValueLoaded({this.model});

  @override
  final T model;

  @override
  String toString() {
    return 'FutureValue<$T>.loaded(model: $model)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is FutureValueLoaded<T> &&
            (identical(other.model, model) ||
                const DeepCollectionEquality().equals(other.model, model)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(model);

  @JsonKey(ignore: true)
  @override
  $FutureValueLoadedCopyWith<T, FutureValueLoaded<T>> get copyWith =>
      _$FutureValueLoadedCopyWithImpl<T, FutureValueLoaded<T>>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required TResult initial(),
    @required TResult loaded(T model),
    @required TResult error(dynamic error),
  }) {
    assert(initial != null);
    assert(loaded != null);
    assert(error != null);
    return loaded(model);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult initial(),
    TResult loaded(T model),
    TResult error(dynamic error),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (loaded != null) {
      return loaded(model);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult initial(FutureValueInitial<T> value),
    @required TResult loaded(FutureValueLoaded<T> value),
    @required TResult error(FutureValueError<T> value),
  }) {
    assert(initial != null);
    assert(loaded != null);
    assert(error != null);
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult initial(FutureValueInitial<T> value),
    TResult loaded(FutureValueLoaded<T> value),
    TResult error(FutureValueError<T> value),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class FutureValueLoaded<T> implements FutureValue<T> {
  const factory FutureValueLoaded({T model}) = _$FutureValueLoaded<T>;

  T get model;
  @JsonKey(ignore: true)
  $FutureValueLoadedCopyWith<T, FutureValueLoaded<T>> get copyWith;
}

/// @nodoc
abstract class $FutureValueErrorCopyWith<T, $Res> {
  factory $FutureValueErrorCopyWith(
          FutureValueError<T> value, $Res Function(FutureValueError<T>) then) =
      _$FutureValueErrorCopyWithImpl<T, $Res>;
  $Res call({dynamic error});
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
    Object error = freezed,
  }) {
    return _then(FutureValueError<T>(
      error: error == freezed ? _value.error : error as dynamic,
    ));
  }
}

/// @nodoc
class _$FutureValueError<T> implements FutureValueError<T> {
  const _$FutureValueError({this.error});

  @override
  final dynamic error;

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
  TResult when<TResult extends Object>({
    @required TResult initial(),
    @required TResult loaded(T model),
    @required TResult error(dynamic error),
  }) {
    assert(initial != null);
    assert(loaded != null);
    assert(error != null);
    return error(this.error);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult initial(),
    TResult loaded(T model),
    TResult error(dynamic error),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (error != null) {
      return error(this.error);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult initial(FutureValueInitial<T> value),
    @required TResult loaded(FutureValueLoaded<T> value),
    @required TResult error(FutureValueError<T> value),
  }) {
    assert(initial != null);
    assert(loaded != null);
    assert(error != null);
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult initial(FutureValueInitial<T> value),
    TResult loaded(FutureValueLoaded<T> value),
    TResult error(FutureValueError<T> value),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class FutureValueError<T> implements FutureValue<T> {
  const factory FutureValueError({dynamic error}) = _$FutureValueError<T>;

  dynamic get error;
  @JsonKey(ignore: true)
  $FutureValueErrorCopyWith<T, FutureValueError<T>> get copyWith;
}
