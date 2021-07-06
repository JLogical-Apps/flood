import 'dart:io';

import 'package:example/repository/weather/file_weather_repository.dart';
import 'package:example/repository/weather/local_weather_repository.dart';
import 'package:example/repository/weather/weather_page.dart';
import 'package:example/repository/weather/weather_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:path/path.dart';

import 'weather/weather.dart';

/// Page to provide an example of using Repositories.
class RepositoryPage extends HookWidget {
  const RepositoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CHOOSE REPOSITORY'),
      ),
      body: ScrollColumn(
        children: [
          NavigationCard(
            title: Text('Local'),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => WeatherPage(weatherRepository: localRepository))),
          ),
          NavigationCard(
            title: Text('File'),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => WeatherPage(weatherRepository: fileRepository))),
          ),
        ],
      ),
    );
  }

  WeatherRepository get localRepository => LocalWeatherRepository(initialValues: [
        Weather(location: 'New York', degreesCelsius: 12, isRaining: false),
        Weather(location: 'Sacramento', degreesCelsius: 21, isRaining: true),
      ]);

  WeatherRepository get fileRepository => FileWeatherRepository(parentDirectory: Directory(join(Directory.systemTemp.path, 'weathers')));
}
