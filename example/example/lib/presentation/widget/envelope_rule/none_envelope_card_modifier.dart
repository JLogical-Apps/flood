import 'package:example/presentation/widget/envelope_rule/envelope_card_modifier.dart';
import 'package:example_core/example_core.dart';
import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class NoneEnvelopeCardModifier extends EnvelopeRuleCardModifier<EnvelopeRule?> {
  @override
  Widget getIcon(EnvelopeRule? rule, {Color? color}) {
    return StyledIcon(Icons.block, color: color);
  }

  @override
  Widget getDescription(EnvelopeRule? rule) {
    return StyledMarkdown(
        'Valet will never add income to this envelope automatically, giving you total control over the money in this envelope. Use transactions or transfers to control the money in this envelope.');
  }
}
