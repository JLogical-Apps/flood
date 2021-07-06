// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Weather _$_$_WeatherFromJson(Map<String, dynamic> json) {
  return _$_Weather(
    location: json['location'] as String,
    degreesCelsius: (json['degreesCelsius'] as num).toDouble(),
    isRaining: json['isRaining'] as bool,
  );
}

Map<String, dynamic> _$_$_WeatherToJson(_$_Weather instance) =>
    <String, dynamic>{
      'location': instance.location,
      'degreesCelsius': instance.degreesCelsius,
      'isRaining': instance.isRaining,
    };
