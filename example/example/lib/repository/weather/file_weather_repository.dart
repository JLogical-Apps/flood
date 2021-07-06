import 'dart:convert';
import 'dart:io';

import 'package:example/repository/weather/weather_repository.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

import 'weather.dart';

class FileWeatherRepository extends JsonFileRepository<Weather> implements WeatherRepository<String> {
  FileWeatherRepository({
    required Directory parentDirectory,
  }) : super(
          parentDirectory: parentDirectory,
          idGenerator: MapperIdGenerator((weather) => weather.location),
          toJson: (weather) => json.encode(weather.toJson()),
          fromJson: (_json) => Weather.fromJson(json.decode(_json)),
        );
}
