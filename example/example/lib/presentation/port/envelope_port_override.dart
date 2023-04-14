import 'package:example/features/envelope/envelope.dart';
import 'package:example/features/envelope_rule/envelope_rule.dart';
import 'package:example/presentation/widget/envelope_rule/envelope_card_modifier.dart';
import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class EnvelopePortOverride with IsStyledObjectPortOverride<Envelope> {
  final AppPondContext context;

  EnvelopePortOverride({required this.context});

  @override
  Widget build(Port port) {
    return StyledObjectPortBuilder(
      port: port,
      overrides: {
        Envelope.ruleField: StyledStagePortField(
          fieldName: Envelope.ruleField,
          labelText: 'Rule',
          beforeBuilder: (StagePortField<RuntimeType?, dynamic> stagePortField, RuntimeType? value) {
            final envelopeRule = stagePortField.toValueObject<EnvelopeRule>(
              context: context.find<PortDropCoreComponent>(),
              value: value,
            );

            return EnvelopeRuleCardModifier.getModifier(envelopeRule).getDescription(envelopeRule);
          },
          valueWidgetMapper: (StagePortField<RuntimeType?, dynamic> stagePortField, RuntimeType? value) {
            final envelopeRule = stagePortField.toValueObject<EnvelopeRule>(
              context: context.find<PortDropCoreComponent>(),
              value: value,
            );
            return StyledList.row(
              children: [
                EnvelopeRuleCardModifier.getModifier(envelopeRule).getIcon(envelopeRule),
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
