import 'package:example/features/envelope/envelope.dart';
import 'package:example/features/envelope/envelope_change.dart';
import 'package:example/features/envelope_rule/envelope_rule.dart';
import 'package:example/features/envelope_rule/firstfruit_envelope_rule.dart';
import 'package:example/features/envelope_rule/time_rule.dart';
import 'package:jlogical_utils_core/jlogical_utils_core.dart';

class RepeatingGoalEnvelopeRule extends EnvelopeRule {
  static const rulePriority = FirstfruitEnvelopeRule.rulePriority + 1;

  static const goalCentsField = 'goalCents';
  late final goalCentsProperty = field<int>(name: goalCentsField).withDisplayName('Goal (\$)').currency().required();

  /// The remaining amount of cents needed before the goal is completed.
  /// Will never be negative.
  static const remainingGoalCentsField = 'remainingGoalCents';
  late final remainingGoalCentsProperty = field<int>(name: remainingGoalCentsField)
      .withDisplayName('Remaining (\$)')
      .currency()
      .withFallbackReplacement(() {
    return goalCentsProperty.value;
  });

  static const timeRuleField = 'timeRule';
  late final timeRuleProperty = field<TimeRule>(name: timeRuleField).withDisplayName('Timing').required();

  static const lastAppliedDateField = 'lastApplied';
  late final lastAppliedDateProperty =
      field<DateTime>(name: lastAppliedDateField).withFallbackReplacement(() => DateTime.now()).hidden();

  @override
  List<ValueObjectBehavior> get behaviors => [
        ValueObjectBehavior.displayName('Repeating Goal'),
        goalCentsProperty,
        remainingGoalCentsProperty,
        timeRuleProperty,
        lastAppliedDateProperty,
      ];

  @override
  int get priority => rulePriority;

  @override
  int requestIncome({
    required DropCoreContext context,
    required Envelope envelope,
    required int incomeCents,
    required bool isExtraIncome,
  }) {
    // If the income is extra income, then all other goal rules have been satisfied.
    // So, each goal rule should collect extra in proportion to its monthly goal.
    if (isExtraIncome) {
      return goalCentsProperty.value;
    }

    // Always request the remaining goal cents.
    final adjustedRemainingGoalCents = _getAdjustedRemainingGoalCents(DateTime.now());
    return adjustedRemainingGoalCents < 0 ? 0 : adjustedRemainingGoalCents;
  }

  @override
  EnvelopeChange? onAddIncome({
    required DropCoreContext context,
    required Envelope envelope,
    required int incomeCents,
  }) {
    // Handle adjustment on new months.
    final now = DateTime.now();
    final adjustedRemainingGoalCents = _getAdjustedRemainingGoalCents(now);

    final newRemainingCents = adjustedRemainingGoalCents - incomeCents;

    return EnvelopeChange(
      ruleChange: RepeatingGoalEnvelopeRule()
        ..copyFrom(context, this)
        ..remainingGoalCentsProperty.set(newRemainingCents)
        ..lastAppliedDateProperty.set(now),
    );
  }

  @override
  EnvelopeChange? onInitialize({required DropCoreContext context}) {
    // Handle adjustment on new months.
    final now = DateTime.now();
    final adjustedRemainingGoalCents = _getAdjustedRemainingGoalCents(now);

    if (adjustedRemainingGoalCents == remainingGoalCentsProperty.value) {
      return null;
    }

    return EnvelopeChange(
      ruleChange: RepeatingGoalEnvelopeRule()
        ..copyFrom(context, this)
        ..remainingGoalCentsProperty.set(adjustedRemainingGoalCents)
        ..lastAppliedDateProperty.set(now),
    );
  }

  /// Returns the adjusted remaining goal cents depending on the date.
  /// If the current date is one month later than the last applied date, it adds the monthly goal cents to the remainingGoalCents.
  int _getAdjustedRemainingGoalCents(DateTime now) {
    return timeRuleProperty.value.getCentsRemaining(
      rule: this,
      now: now,
    );
  }
}
