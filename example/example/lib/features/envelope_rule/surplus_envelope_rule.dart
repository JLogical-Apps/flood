import 'package:example/features/envelope_rule/percent_rule.dart';
import 'package:example/features/envelope_rule/target_goal_envelope_rule.dart';
import 'package:jlogical_utils_core/jlogical_utils_core.dart';

class SurplusEnvelopeRule extends PercentRule {
  static const rulePriority = TargetGoalEnvelopeRule.rulePriority + 1;

  @override
  int get priority => rulePriority;

  @override
  List<ValueObjectBehavior> get behaviors =>
      super.behaviors +
      [
        ValueObjectBehavior.displayName('Surplus'),
      ];
}
