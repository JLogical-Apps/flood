import 'package:example/presentation/widget/envelope_rule/envelope_card_modifier.dart';
import 'package:example_core/features/envelope/envelope.dart';
import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class EnvelopeChip extends StatelessWidget {
  final Envelope envelope;
  final Function()? onPressed;

  const EnvelopeChip({super.key, required this.envelope, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final envelopeRuleCardModifier = EnvelopeRuleCardModifier.getModifier(envelope.ruleProperty.value);
    final envelopeColor = Color(envelope.colorProperty.value);
    return StyledChip(
      label: StyledText.body.withColor(envelopeColor)(envelope.nameProperty.value),
      icon: envelopeRuleCardModifier.getIcon(envelope.ruleProperty.value, color: envelopeColor, size: 16),
      onPressed: onPressed,
      foregroundColor: envelopeColor,
    );
  }
}
