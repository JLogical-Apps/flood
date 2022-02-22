import 'package:jlogical_utils/src/pond/context/date/date_time_provider.dart';

mixin WithDateTimeDelegator implements DateTimeProvider {
  DateTimeProvider get dateTimeProvider;

  @override
  DateTime getNow() => dateTimeProvider.getNow();
}
