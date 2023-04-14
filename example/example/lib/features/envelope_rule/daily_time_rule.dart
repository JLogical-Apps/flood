import 'package:example/features/envelope_rule/time_rule.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class DailyTimeRule extends TimeRule {
  static const daysField = 'days';
  late final daysProperty =
      field<int>(name: daysField).withDisplayName('Period (Days)').required().withDefault(() => 7);

  @override
  List<ValueObjectBehavior> get behaviors => [
        ValueObjectBehavior.displayName('Periodic'),
        daysProperty,
      ];

  @override
  int getPeriodsBetween(DateTime date1, DateTime date2) {
    final duration = date1.difference(date2).abs();

    return (duration.inDays / daysProperty.value).floor();
  }
}
