import 'package:example/features/envelope/envelope.dart';
import 'package:example/features/envelope_rule/envelope_rule.dart';
import 'package:example/features/envelope_rule/repeating_goal_envelope_rule.dart';
import 'package:jlogical_utils_core/jlogical_utils_core.dart';

class TargetGoalEnvelopeRule extends EnvelopeRule {
  static const rulePriority = RepeatingGoalEnvelopeRule.rulePriority + 1;

  static const goalField = 'goal';
  late final goalCentsProperty = field<int>(name: goalField).required();

  static const percentField = 'percent';
  late final percentProperty = field<double>(name: percentField).required();

  @override
  List<ValueObjectBehavior> get behaviors => [goalCentsProperty];

  @override
  int get priority => rulePriority;

  @override
  int requestIncome(Envelope envelope, int incomeCents, bool isExtraIncome) {
    throw UnimplementedError();
  }
}
