import 'date_time_provider.dart';

class PresetDateTimeProvider implements DateTimeProvider {
  final DateTime presetNow;

  PresetDateTimeProvider(this.presetNow);

  DateTime getNow() {
    return presetNow;
  }
}
