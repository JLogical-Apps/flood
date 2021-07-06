import 'package:example/repository/weather/weather_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

import 'weather.dart';

/// Page that shows weather data from a WeatherRepository.
class WeatherPage extends HookWidget {
  final WeatherRepository weatherRepository;

  const WeatherPage({Key? key, required this.weatherRepository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var weatherByIdX = useObservable(() => <String, Weather>{});

    // In a production environment, would be using Models instead of loading directly in a page.
    useOneTimeEffect(() {
      loadWeathers().then((weathers) => weatherByIdX.value = weathers);
    });

    return RefreshScaffold(
      appBar: AppBar(
        title: Text('WEATHER'),
      ),
      body: ScrollColumn.withScrollbar(
        children: [
          CategoryCard(
            category: Text('Weathers'),
            leading: Icon(Icons.map),
            children: [
              ...weatherByIdX.value.entries.map((entry) {
                var id = entry.key;
                var weather = entry.value;
                return ListTile(
                  title: Text(weather.location),
                  subtitle: Text('${weather.degreesCelsius.formatIntOrDouble()} degrees'),
                  leading: weather.isRaining ? Icon(Icons.water) : Icon(Icons.wb_sunny),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      await weatherRepository.delete(id);
                      loadWeathers().then((weathers) => weatherByIdX.value = weathers);
                    },
                  ),
                );
              }),
              ElevatedButton(
                child: Text('ADD LOCATION'),
                onPressed: () async {
                  var result = await Popup.smartForm(
                    context,
                    builder: (context) => ScrollColumn.withScrollbar(
                      children: [
                        SmartTextField(
                          name: 'location',
                          label: 'Location',
                          validators: [Validation.required()],
                        ),
                        SmartTextField(
                          name: 'degrees',
                          label: 'Degrees (celsius)',
                          validators: [
                            Validation.required(),
                            Validation.isDouble(),
                          ],
                        ),
                        SmartBoolField(
                          name: 'isRaining',
                          child: Text('Is Raining?'),
                        ),
                      ],
                    ),
                    title: 'Add Location',
                  );
                  if (result == null) return;

                  String location = result['location'];
                  double degrees = double.parse(result['degrees']);
                  bool isRaining = result['isRaining'];

                  var weather = Weather(location: location, degreesCelsius: degrees, isRaining: isRaining);

                  await weatherRepository.create(weather);
                  loadWeathers().then((weathers) => weatherByIdX.value = weathers);
                },
              ),
            ],
          ),
        ],
      ),
      onRefresh: () async {
        loadWeathers().then((weathers) => weatherByIdX.value = weathers);
      },
    );
  }

  // Load the weathers from the weather repository.
  Future<Map<String, Weather>> loadWeathers() async {
    var weatherEntries = await weatherRepository.getAll();
    return weatherEntries.results;
  }
}
