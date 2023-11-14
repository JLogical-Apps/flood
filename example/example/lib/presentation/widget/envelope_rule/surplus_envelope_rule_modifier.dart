import 'package:example/presentation/widget/envelope_rule/envelope_card_modifier.dart';
import 'package:example_core/features/envelope_rule/surplus_envelope_rule.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class SurplusEnvelopeCardModifier extends EnvelopeRuleCardModifier<SurplusEnvelopeRule> {
  @override
  Widget getIcon(SurplusEnvelopeRule rule, {Color? color, double? size}) {
    return StyledIcon(FontAwesomeIcons.filter, color: color, size: size);
  }

  @override
  Widget getDescription(SurplusEnvelopeRule rule) {
    return StyledMarkdown(
      'Valet will add `${rule.percentProperty.valueOrNull?.formatIntOrDouble() ?? '?'}`% of any remaining income after your goals are complete to this envelope.',
    );
  }
}
