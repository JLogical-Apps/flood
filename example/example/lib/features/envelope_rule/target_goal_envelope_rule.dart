import 'package:example/features/envelope_rule/percent_rule.dart';
import 'package:example/features/envelope_rule/repeating_goal_envelope_rule.dart';
import 'package:jlogical_utils_core/jlogical_utils_core.dart';

class TargetGoalEnvelopeRule extends PercentRule {
  static const rulePriority = RepeatingGoalEnvelopeRule.rulePriority + 1;

  @override
  int get priority => rulePriority;

  @override
  bool get isMaximumCentsHidden => false;

  @override
  List<ValueObjectBehavior> get behaviors =>
      super.behaviors +
      [
        ValueObjectBehavior.displayName('Target Goal'),
      ];
}
