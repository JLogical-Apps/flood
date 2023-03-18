import 'package:example/features/envelope_rule/time_rule.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class DailyTimeRule extends TimeRule {
  static const daysField = 'days';
  late final daysProperty = field<int>(name: daysField).required();

  static const centsRemainingField = 'centsRemaining';
  late final centsRemainingProperty = field<int>(name: centsRemainingField).required();

  @override
  int getCentsRemaining({required DateTime now}) {
    throw Exception();
  }
}
