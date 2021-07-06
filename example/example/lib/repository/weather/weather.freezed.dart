// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'weather.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Weather _$WeatherFromJson(Map<String, dynamic> json) {
  return _Weather.fromJson(json);
}

/// @nodoc
class _$WeatherTearOff {
  const _$WeatherTearOff();

  _Weather call(
      {required String location,
      required double degreesCelsius,
      required bool isRaining}) {
    return _Weather(
      location: location,
      degreesCelsius: degreesCelsius,
      isRaining: isRaining,
    );
  }

  Weather fromJson(Map<String, Object> json) {
    return Weather.fromJson(json);
  }
}

/// @nodoc
const $Weather = _$WeatherTearOff();

/// @nodoc
mixin _$Weather {
  String get location => throw _privateConstructorUsedError;
  double get degreesCelsius => throw _privateConstructorUsedError;
  bool get isRaining => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WeatherCopyWith<Weather> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WeatherCopyWith<$Res> {
  factory $WeatherCopyWith(Weather value, $Res Function(Weather) then) =
      _$WeatherCopyWithImpl<$Res>;
  $Res call({String location, double degreesCelsius, bool isRaining});
}

/// @nodoc
class _$WeatherCopyWithImpl<$Res> implements $WeatherCopyWith<$Res> {
  _$WeatherCopyWithImpl(this._value, this._then);

  final Weather _value;
  // ignore: unused_field
  final $Res Function(Weather) _then;

  @override
  $Res call({
    Object? location = freezed,
    Object? degreesCelsius = freezed,
    Object? isRaining = freezed,
  }) {
    return _then(_value.copyWith(
      location: location == freezed
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      degreesCelsius: degreesCelsius == freezed
          ? _value.degreesCelsius
          : degreesCelsius // ignore: cast_nullable_to_non_nullable
              as double,
      isRaining: isRaining == freezed
          ? _value.isRaining
          : isRaining // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
abstract class _$WeatherCopyWith<$Res> implements $WeatherCopyWith<$Res> {
  factory _$WeatherCopyWith(_Weather value, $Res Function(_Weather) then) =
      __$WeatherCopyWithImpl<$Res>;
  @override
  $Res call({String location, double degreesCelsius, bool isRaining});
}

/// @nodoc
class __$WeatherCopyWithImpl<$Res> extends _$WeatherCopyWithImpl<$Res>
    implements _$WeatherCopyWith<$Res> {
  __$WeatherCopyWithImpl(_Weather _value, $Res Function(_Weather) _then)
      : super(_value, (v) => _then(v as _Weather));

  @override
  _Weather get _value => super._value as _Weather;

  @override
  $Res call({
    Object? location = freezed,
    Object? degreesCelsius = freezed,
    Object? isRaining = freezed,
  }) {
    return _then(_Weather(
      location: location == freezed
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      degreesCelsius: degreesCelsius == freezed
          ? _value.degreesCelsius
          : degreesCelsius // ignore: cast_nullable_to_non_nullable
              as double,
      isRaining: isRaining == freezed
          ? _value.isRaining
          : isRaining // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Weather implements _Weather {
  const _$_Weather(
      {required this.location,
      required this.degreesCelsius,
      required this.isRaining});

  factory _$_Weather.fromJson(Map<String, dynamic> json) =>
      _$_$_WeatherFromJson(json);

  @override
  final String location;
  @override
  final double degreesCelsius;
  @override
  final bool isRaining;

  @override
  String toString() {
    return 'Weather(location: $location, degreesCelsius: $degreesCelsius, isRaining: $isRaining)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _Weather &&
            (identical(other.location, location) ||
                const DeepCollectionEquality()
                    .equals(other.location, location)) &&
            (identical(other.degreesCelsius, degreesCelsius) ||
                const DeepCollectionEquality()
                    .equals(other.degreesCelsius, degreesCelsius)) &&
            (identical(other.isRaining, isRaining) ||
                const DeepCollectionEquality()
                    .equals(other.isRaining, isRaining)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(location) ^
      const DeepCollectionEquality().hash(degreesCelsius) ^
      const DeepCollectionEquality().hash(isRaining);

  @JsonKey(ignore: true)
  @override
  _$WeatherCopyWith<_Weather> get copyWith =>
      __$WeatherCopyWithImpl<_Weather>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_WeatherToJson(this);
  }
}

abstract class _Weather implements Weather {
  const factory _Weather(
      {required String location,
      required double degreesCelsius,
      required bool isRaining}) = _$_Weather;

  factory _Weather.fromJson(Map<String, dynamic> json) = _$_Weather.fromJson;

  @override
  String get location => throw _privateConstructorUsedError;
  @override
  double get degreesCelsius => throw _privateConstructorUsedError;
  @override
  bool get isRaining => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$WeatherCopyWith<_Weather> get copyWith =>
      throw _privateConstructorUsedError;
}
