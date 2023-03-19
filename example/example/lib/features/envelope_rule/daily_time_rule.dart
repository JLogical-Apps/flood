import 'package:example/features/envelope_rule/time_rule.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class DailyTimeRule extends TimeRule {
  static const daysField = 'days';
  late final daysProperty = field<int>(name: daysField).required();

  @override
  List<ValueObjectBehavior> get behaviors => [daysProperty];

  @override
  int getPeriodsBetween(DateTime date1, DateTime date2) {
    final duration = date1.difference(date2).abs();

    return (duration.inDays / daysProperty.value).floor();
  }
}
