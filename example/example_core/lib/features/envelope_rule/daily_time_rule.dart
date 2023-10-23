import 'package:example_core/features/envelope_rule/time_rule.dart';
import 'package:jlogical_utils_core/jlogical_utils_core.dart';

class DailyTimeRule extends TimeRule {
  static const daysField = 'days';
  late final daysProperty = field<int>(name: daysField)
      .withDisplayName('Period (Days)')
      .required()
      .withDefault(() => 7)
      .isPositive();

  @override
  late final List<ValueObjectBehavior> behaviors = [
    ValueObjectBehavior.displayName('Periodic'),
    daysProperty,
    creationTime(),
  ];

  @override
  int getPeriodsBetween(DateTime date1, DateTime date2) {
    final duration = date1.difference(date2).abs();

    return (duration.inDays / daysProperty.value).floor();
  }

  @override
  DateTime getStartOfPeriod(DateTime date, DateTime lastAppliedDate) {
    while (lastAppliedDate.isBefore(date)) {
      lastAppliedDate = lastAppliedDate.add(Duration(days: daysProperty.value));
    }
    return lastAppliedDate.subtract(Duration(days: daysProperty.value));
  }
}
