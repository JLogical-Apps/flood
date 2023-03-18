import 'package:example/features/envelope/envelope.dart';
import 'package:example/features/envelope_rule/envelope_rule.dart';
import 'package:example/features/envelope_rule/firstfruit_envelope_rule.dart';
import 'package:example/features/envelope_rule/time_rule.dart';
import 'package:jlogical_utils_core/jlogical_utils_core.dart';

class RepeatingGoalEnvelopeRule extends EnvelopeRule {
  static const rulePriority = FirstfruitEnvelopeRule.rulePriority + 1;

  static const goalField = 'goal';
  late final goalCentsProperty = field<int>(name: goalField).required();

  static const timeRuleField = 'timeRule';
  late final timeRuleProperty = field<TimeRule>(name: timeRuleField).required();

  @override
  List<ValueObjectBehavior> get behaviors => [goalCentsProperty];

  @override
  int get priority => rulePriority;

  @override
  int requestIncome(Envelope envelope, int incomeCents, bool isExtraIncome) {
    throw UnimplementedError();
  }
}
