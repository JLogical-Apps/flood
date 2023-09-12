import 'package:example_core/features/envelope/envelope.dart';
import 'package:example_core/features/envelope/envelope_change.dart';
import 'package:example_core/features/envelope_rule/envelope_rule.dart';
import 'package:example_core/features/envelope_rule/firstfruit_envelope_rule.dart';
import 'package:example_core/features/envelope_rule/monthly_time_rule.dart';
import 'package:example_core/features/envelope_rule/time_rule.dart';
import 'package:jlogical_utils_core/jlogical_utils_core.dart';

class RepeatingGoalEnvelopeRule extends EnvelopeRule {
  static const rulePriority = FirstfruitEnvelopeRule.rulePriority + 1;

  static const goalCentsField = 'goalCents';
  late final goalCentsProperty = field<int>(name: goalCentsField)
      .withDisplayName('Goal (\$)')
      .currency()
      .required()
      .withValidator(Validator.isPositive().cast<int>());

  /// The remaining amount of cents needed before the goal is completed.
  /// Will never be negative.
  static const remainingGoalCentsField = 'remainingGoalCents';
  late final remainingGoalCentsProperty = field<int>(name: remainingGoalCentsField)
      .withDisplayName('Remaining (\$)')
      .currency()
      .withFallbackReplacement(() => goalCentsProperty.value);

  static const timeRuleField = 'timeRule';
  late final timeRuleProperty = field<TimeRule>(name: timeRuleField)
      .embedded()
      .withDisplayName('Timing')
      .required()
      .withDefault(() => MonthlyTimeRule());

  static const lastAppliedDateField = 'lastApplied';
  late final lastAppliedDateProperty = field<Timestamp>(name: lastAppliedDateField)
      .time()
      .onlyDate()
      .withFallbackReplacement(() => Timestamp.now())
      .hidden();

  @override
  late final List<ValueObjectBehavior> behaviors = [
    ValueObjectBehavior.displayName('Repeating Goal'),
    goalCentsProperty,
    remainingGoalCentsProperty,
    timeRuleProperty,
    lastAppliedDateProperty,
    creationTime(),
  ];

  @override
  int get priority => rulePriority;

  @override
  int requestIncome(
    DropCoreContext context, {
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
  EnvelopeChange? onAddIncome(
    DropCoreContext context, {
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
        ..remainingGoalCentsProperty.set(newRemainingCents),
    );
  }

  @override
  EnvelopeChange? onInitialize(DropCoreContext context) {
    // Handle adjustment on new months.
    final now = DateTime.now();
    final adjustedRemainingGoalCents = _getAdjustedRemainingGoalCents(now);

    if (adjustedRemainingGoalCents == remainingGoalCentsProperty.value) {
      return null;
    }

    final startOfCurrentPeriod = timeRuleProperty.value.getStartOfPeriod(now, lastAppliedDateProperty.value.time);

    return EnvelopeChange(
      ruleChange: RepeatingGoalEnvelopeRule()
        ..copyFrom(context, this)
        ..remainingGoalCentsProperty.set(adjustedRemainingGoalCents)
        ..lastAppliedDateProperty.set(Timestamp.of(startOfCurrentPeriod)),
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