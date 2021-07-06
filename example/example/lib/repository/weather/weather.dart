import 'package:freezed_annotation/freezed_annotation.dart';

part 'weather.freezed.dart';
part 'weather.g.dart';

/// Data about weather at a location.
@freezed
class Weather with _$Weather {
  const factory Weather({
    required String location,
    required double degreesCelsius,
    required bool isRaining,
  }) = _Weather;

  factory Weather.fromJson(Map<String, dynamic> json) => _$WeatherFromJson(json);
}
