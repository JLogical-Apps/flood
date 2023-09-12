import 'package:example/presentation/widget/time_rule/time_rule_card_modifier.dart';
import 'package:example_core/features/envelope_rule/repeating_goal_envelope_rule.dart';
import 'package:example_core/features/envelope_rule/time_rule.dart';
import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class RepeatingGoalStyledPortOverride with IsStyledObjectPortOverride<RepeatingGoalEnvelopeRule> {
  final AppPondContext context;

  RepeatingGoalStyledPortOverride({required this.context});

  @override
  Widget build(Port port) {
    return StyledObjectPortBuilder(
      port: port,
      overrides: {
        RepeatingGoalEnvelopeRule.timeRuleField: StyledStagePortField(
          fieldName: RepeatingGoalEnvelopeRule.timeRuleField,
          labelText: 'Timing',
          valueWidgetMapper: (StagePortField<RuntimeType?, dynamic> stagePortField, RuntimeType? value) {
            final timeRule = stagePortField.toValueObject<TimeRule>(
              context: context.find<PortDropCoreComponent>(),
              value: value,
            );

            final timeRuleWrapper = TimeRuleCardModifier.getModifierOrNull(timeRule);

            return StyledList.row(
              children: [
                if (timeRuleWrapper != null) timeRuleWrapper.getIcon(timeRule),
                Expanded(
                  child: StyledText.button(value == null ? 'None' : stagePortField.getDisplayName(value) ?? 'None'),
                ),
              ],
            );
          },
        ),
      },
    );
  }
}