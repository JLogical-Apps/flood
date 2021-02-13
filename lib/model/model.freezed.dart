// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
class _$ModelTearOff {
  const _$ModelTearOff();

// ignore: unused_element
  _InitialModel<T> initial<T>() {
    return _InitialModel<T>();
  }

// ignore: unused_element
  _LoadedModel<T> loaded<T>({T model, bool isLoading}) {
    return _LoadedModel<T>(
      model: model,
      isLoading: isLoading,
    );
  }

// ignore: unused_element
  _ErrorModel<T> error<T>({dynamic error}) {
    return _ErrorModel<T>(
      error: error,
    );
  }
}

/// @nodoc
// ignore: unused_element
const $Model = _$ModelTearOff();

/// @nodoc
mixin _$Model<T> {
  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required TResult initial(),
    @required TResult loaded(T model, bool isLoading),
    @required TResult error(dynamic error),
  });
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult initial(),
    TResult loaded(T model, bool isLoading),
    TResult error(dynamic error),
    @required TResult orElse(),
  });
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult initial(_InitialModel<T> value),
    @required TResult loaded(_LoadedModel<T> value),
    @required TResult error(_ErrorModel<T> value),
  });
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult initial(_InitialModel<T> value),
    TResult loaded(_LoadedModel<T> value),
    TResult error(_ErrorModel<T> value),
    @required TResult orElse(),
  });
}

/// @nodoc
abstract class $ModelCopyWith<T, $Res> {
  factory $ModelCopyWith(Model<T> value, $Res Function(Model<T>) then) =
      _$ModelCopyWithImpl<T, $Res>;
}

/// @nodoc
class _$ModelCopyWithImpl<T, $Res> implements $ModelCopyWith<T, $Res> {
  _$ModelCopyWithImpl(this._value, this._then);

  final Model<T> _value;
  // ignore: unused_field
  final $Res Function(Model<T>) _then;
}

/// @nodoc
abstract class _$InitialModelCopyWith<T, $Res> {
  factory _$InitialModelCopyWith(
          _InitialModel<T> value, $Res Function(_InitialModel<T>) then) =
      __$InitialModelCopyWithImpl<T, $Res>;
}

/// @nodoc
class __$InitialModelCopyWithImpl<T, $Res> extends _$ModelCopyWithImpl<T, $Res>
    implements _$InitialModelCopyWith<T, $Res> {
  __$InitialModelCopyWithImpl(
      _InitialModel<T> _value, $Res Function(_InitialModel<T>) _then)
      : super(_value, (v) => _then(v as _InitialModel<T>));

  @override
  _InitialModel<T> get _value => super._value as _InitialModel<T>;
}

/// @nodoc
class _$_InitialModel<T> implements _InitialModel<T> {
  const _$_InitialModel();

  @override
  String toString() {
    return 'Model<$T>.initial()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is _InitialModel<T>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required TResult initial(),
    @required TResult loaded(T model, bool isLoading),
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
    TResult loaded(T model, bool isLoading),
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
    @required TResult initial(_InitialModel<T> value),
    @required TResult loaded(_LoadedModel<T> value),
    @required TResult error(_ErrorModel<T> value),
  }) {
    assert(initial != null);
    assert(loaded != null);
    assert(error != null);
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult initial(_InitialModel<T> value),
    TResult loaded(_LoadedModel<T> value),
    TResult error(_ErrorModel<T> value),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _InitialModel<T> implements Model<T> {
  const factory _InitialModel() = _$_InitialModel<T>;
}

/// @nodoc
abstract class _$LoadedModelCopyWith<T, $Res> {
  factory _$LoadedModelCopyWith(
          _LoadedModel<T> value, $Res Function(_LoadedModel<T>) then) =
      __$LoadedModelCopyWithImpl<T, $Res>;
  $Res call({T model, bool isLoading});
}

/// @nodoc
class __$LoadedModelCopyWithImpl<T, $Res> extends _$ModelCopyWithImpl<T, $Res>
    implements _$LoadedModelCopyWith<T, $Res> {
  __$LoadedModelCopyWithImpl(
      _LoadedModel<T> _value, $Res Function(_LoadedModel<T>) _then)
      : super(_value, (v) => _then(v as _LoadedModel<T>));

  @override
  _LoadedModel<T> get _value => super._value as _LoadedModel<T>;

  @override
  $Res call({
    Object model = freezed,
    Object isLoading = freezed,
  }) {
    return _then(_LoadedModel<T>(
      model: model == freezed ? _value.model : model as T,
      isLoading: isLoading == freezed ? _value.isLoading : isLoading as bool,
    ));
  }
}

/// @nodoc
class _$_LoadedModel<T> implements _LoadedModel<T> {
  const _$_LoadedModel({this.model, this.isLoading});

  @override
  final T model;
  @override
  final bool isLoading;

  @override
  String toString() {
    return 'Model<$T>.loaded(model: $model, isLoading: $isLoading)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _LoadedModel<T> &&
            (identical(other.model, model) ||
                const DeepCollectionEquality().equals(other.model, model)) &&
            (identical(other.isLoading, isLoading) ||
                const DeepCollectionEquality()
                    .equals(other.isLoading, isLoading)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(model) ^
      const DeepCollectionEquality().hash(isLoading);

  @JsonKey(ignore: true)
  @override
  _$LoadedModelCopyWith<T, _LoadedModel<T>> get copyWith =>
      __$LoadedModelCopyWithImpl<T, _LoadedModel<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required TResult initial(),
    @required TResult loaded(T model, bool isLoading),
    @required TResult error(dynamic error),
  }) {
    assert(initial != null);
    assert(loaded != null);
    assert(error != null);
    return loaded(model, isLoading);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult initial(),
    TResult loaded(T model, bool isLoading),
    TResult error(dynamic error),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (loaded != null) {
      return loaded(model, isLoading);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult initial(_InitialModel<T> value),
    @required TResult loaded(_LoadedModel<T> value),
    @required TResult error(_ErrorModel<T> value),
  }) {
    assert(initial != null);
    assert(loaded != null);
    assert(error != null);
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult initial(_InitialModel<T> value),
    TResult loaded(_LoadedModel<T> value),
    TResult error(_ErrorModel<T> value),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class _LoadedModel<T> implements Model<T> {
  const factory _LoadedModel({T model, bool isLoading}) = _$_LoadedModel<T>;

  T get model;
  bool get isLoading;
  @JsonKey(ignore: true)
  _$LoadedModelCopyWith<T, _LoadedModel<T>> get copyWith;
}

/// @nodoc
abstract class _$ErrorModelCopyWith<T, $Res> {
  factory _$ErrorModelCopyWith(
          _ErrorModel<T> value, $Res Function(_ErrorModel<T>) then) =
      __$ErrorModelCopyWithImpl<T, $Res>;
  $Res call({dynamic error});
}

/// @nodoc
class __$ErrorModelCopyWithImpl<T, $Res> extends _$ModelCopyWithImpl<T, $Res>
    implements _$ErrorModelCopyWith<T, $Res> {
  __$ErrorModelCopyWithImpl(
      _ErrorModel<T> _value, $Res Function(_ErrorModel<T>) _then)
      : super(_value, (v) => _then(v as _ErrorModel<T>));

  @override
  _ErrorModel<T> get _value => super._value as _ErrorModel<T>;

  @override
  $Res call({
    Object error = freezed,
  }) {
    return _then(_ErrorModel<T>(
      error: error == freezed ? _value.error : error as dynamic,
    ));
  }
}

/// @nodoc
class _$_ErrorModel<T> implements _ErrorModel<T> {
  const _$_ErrorModel({this.error});

  @override
  final dynamic error;

  @override
  String toString() {
    return 'Model<$T>.error(error: $error)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _ErrorModel<T> &&
            (identical(other.error, error) ||
                const DeepCollectionEquality().equals(other.error, error)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(error);

  @JsonKey(ignore: true)
  @override
  _$ErrorModelCopyWith<T, _ErrorModel<T>> get copyWith =>
      __$ErrorModelCopyWithImpl<T, _ErrorModel<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required TResult initial(),
    @required TResult loaded(T model, bool isLoading),
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
    TResult loaded(T model, bool isLoading),
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
    @required TResult initial(_InitialModel<T> value),
    @required TResult loaded(_LoadedModel<T> value),
    @required TResult error(_ErrorModel<T> value),
  }) {
    assert(initial != null);
    assert(loaded != null);
    assert(error != null);
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult initial(_InitialModel<T> value),
    TResult loaded(_LoadedModel<T> value),
    TResult error(_ErrorModel<T> value),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _ErrorModel<T> implements Model<T> {
  const factory _ErrorModel({dynamic error}) = _$_ErrorModel<T>;

  dynamic get error;
  @JsonKey(ignore: true)
  _$ErrorModelCopyWith<T, _ErrorModel<T>> get copyWith;
}
