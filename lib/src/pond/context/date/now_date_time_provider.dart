import 'package:jlogical_utils/src/pond/context/date/date_time_provider.dart';

class NowDateTimeProvider implements DateTimeProvider {
  @override
  DateTime getNow() => DateTime.now();
}
