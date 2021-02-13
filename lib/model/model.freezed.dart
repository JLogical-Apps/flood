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
  ModelInitial<T> initial<T>() {
    return ModelInitial<T>();
  }

// ignore: unused_element
  ModelLoaded<T> loaded<T>({T model, bool isLoading}) {
    return ModelLoaded<T>(
      model: model,
      isLoading: isLoading,
    );
  }

// ignore: unused_element
  ModelError<T> error<T>({dynamic error}) {
    return ModelError<T>(
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
    @required TResult initial(ModelInitial<T> value),
    @required TResult loaded(ModelLoaded<T> value),
    @required TResult error(ModelError<T> value),
  });
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult initial(ModelInitial<T> value),
    TResult loaded(ModelLoaded<T> value),
    TResult error(ModelError<T> value),
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
abstract class $ModelInitialCopyWith<T, $Res> {
  factory $ModelInitialCopyWith(
          ModelInitial<T> value, $Res Function(ModelInitial<T>) then) =
      _$ModelInitialCopyWithImpl<T, $Res>;
}

/// @nodoc
class _$ModelInitialCopyWithImpl<T, $Res> extends _$ModelCopyWithImpl<T, $Res>
    implements $ModelInitialCopyWith<T, $Res> {
  _$ModelInitialCopyWithImpl(
      ModelInitial<T> _value, $Res Function(ModelInitial<T>) _then)
      : super(_value, (v) => _then(v as ModelInitial<T>));

  @override
  ModelInitial<T> get _value => super._value as ModelInitial<T>;
}

/// @nodoc
class _$ModelInitial<T> implements ModelInitial<T> {
  const _$ModelInitial();

  @override
  String toString() {
    return 'Model<$T>.initial()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is ModelInitial<T>);
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
    @required TResult initial(ModelInitial<T> value),
    @required TResult loaded(ModelLoaded<T> value),
    @required TResult error(ModelError<T> value),
  }) {
    assert(initial != null);
    assert(loaded != null);
    assert(error != null);
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult initial(ModelInitial<T> value),
    TResult loaded(ModelLoaded<T> value),
    TResult error(ModelError<T> value),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class ModelInitial<T> implements Model<T> {
  const factory ModelInitial() = _$ModelInitial<T>;
}

/// @nodoc
abstract class $ModelLoadedCopyWith<T, $Res> {
  factory $ModelLoadedCopyWith(
          ModelLoaded<T> value, $Res Function(ModelLoaded<T>) then) =
      _$ModelLoadedCopyWithImpl<T, $Res>;
  $Res call({T model, bool isLoading});
}

/// @nodoc
class _$ModelLoadedCopyWithImpl<T, $Res> extends _$ModelCopyWithImpl<T, $Res>
    implements $ModelLoadedCopyWith<T, $Res> {
  _$ModelLoadedCopyWithImpl(
      ModelLoaded<T> _value, $Res Function(ModelLoaded<T>) _then)
      : super(_value, (v) => _then(v as ModelLoaded<T>));

  @override
  ModelLoaded<T> get _value => super._value as ModelLoaded<T>;

  @override
  $Res call({
    Object model = freezed,
    Object isLoading = freezed,
  }) {
    return _then(ModelLoaded<T>(
      model: model == freezed ? _value.model : model as T,
      isLoading: isLoading == freezed ? _value.isLoading : isLoading as bool,
    ));
  }
}

/// @nodoc
class _$ModelLoaded<T> implements ModelLoaded<T> {
  const _$ModelLoaded({this.model, this.isLoading});

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
        (other is ModelLoaded<T> &&
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
  $ModelLoadedCopyWith<T, ModelLoaded<T>> get copyWith =>
      _$ModelLoadedCopyWithImpl<T, ModelLoaded<T>>(this, _$identity);

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
    @required TResult initial(ModelInitial<T> value),
    @required TResult loaded(ModelLoaded<T> value),
    @required TResult error(ModelError<T> value),
  }) {
    assert(initial != null);
    assert(loaded != null);
    assert(error != null);
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult initial(ModelInitial<T> value),
    TResult loaded(ModelLoaded<T> value),
    TResult error(ModelError<T> value),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class ModelLoaded<T> implements Model<T> {
  const factory ModelLoaded({T model, bool isLoading}) = _$ModelLoaded<T>;

  T get model;
  bool get isLoading;
  @JsonKey(ignore: true)
  $ModelLoadedCopyWith<T, ModelLoaded<T>> get copyWith;
}

/// @nodoc
abstract class $ModelErrorCopyWith<T, $Res> {
  factory $ModelErrorCopyWith(
          ModelError<T> value, $Res Function(ModelError<T>) then) =
      _$ModelErrorCopyWithImpl<T, $Res>;
  $Res call({dynamic error});
}

/// @nodoc
class _$ModelErrorCopyWithImpl<T, $Res> extends _$ModelCopyWithImpl<T, $Res>
    implements $ModelErrorCopyWith<T, $Res> {
  _$ModelErrorCopyWithImpl(
      ModelError<T> _value, $Res Function(ModelError<T>) _then)
      : super(_value, (v) => _then(v as ModelError<T>));

  @override
  ModelError<T> get _value => super._value as ModelError<T>;

  @override
  $Res call({
    Object error = freezed,
  }) {
    return _then(ModelError<T>(
      error: error == freezed ? _value.error : error as dynamic,
    ));
  }
}

/// @nodoc
class _$ModelError<T> implements ModelError<T> {
  const _$ModelError({this.error});

  @override
  final dynamic error;

  @override
  String toString() {
    return 'Model<$T>.error(error: $error)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is ModelError<T> &&
            (identical(other.error, error) ||
                const DeepCollectionEquality().equals(other.error, error)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(error);

  @JsonKey(ignore: true)
  @override
  $ModelErrorCopyWith<T, ModelError<T>> get copyWith =>
      _$ModelErrorCopyWithImpl<T, ModelError<T>>(this, _$identity);

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
    @required TResult initial(ModelInitial<T> value),
    @required TResult loaded(ModelLoaded<T> value),
    @required TResult error(ModelError<T> value),
  }) {
    assert(initial != null);
    assert(loaded != null);
    assert(error != null);
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult initial(ModelInitial<T> value),
    TResult loaded(ModelLoaded<T> value),
    TResult error(ModelError<T> value),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class ModelError<T> implements Model<T> {
  const factory ModelError({dynamic error}) = _$ModelError<T>;

  dynamic get error;
  @JsonKey(ignore: true)
  $ModelErrorCopyWith<T, ModelError<T>> get copyWith;
}
