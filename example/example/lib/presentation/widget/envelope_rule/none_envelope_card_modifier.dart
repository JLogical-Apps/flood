import 'package:example/presentation/widget/envelope_rule/envelope_card_modifier.dart';
import 'package:example_core/features/envelope_rule/envelope_rule.dart';
import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class NoneEnvelopeCardModifier extends EnvelopeRuleCardModifier<EnvelopeRule?> {
  @override
  Widget getIcon(EnvelopeRule? rule, {Color? color, double? size}) {
    return StyledIcon(Icons.block, color: color, size: size);
  }

  @override
  Widget getDescription(EnvelopeRule? rule) {
    return StyledMarkdown(
        'Valet will never add income to this envelope automatically, giving you total control over the money in this envelope. Use transactions or transfers to control the money in this envelope.');
  }
}
