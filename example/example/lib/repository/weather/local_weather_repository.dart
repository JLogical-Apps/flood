import 'package:example/repository/weather/weather.dart';
import 'package:example/repository/weather/weather_repository.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class LocalWeatherRepository extends LocalRepository<Weather, String> implements WeatherRepository<String> {
  LocalWeatherRepository({required List<Weather> initialValues}) : super(initialValues: initialValues, idGenerator: MapperIdGenerator((weather) => weather.location));
}
