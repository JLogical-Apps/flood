import 'package:example/features/envelope_rule/surplus_envelope_rule.dart';
import 'package:example/presentation/widget/envelope_rule/envelope_card_modifier.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class SurplusEnvelopeCardModifier extends EnvelopeRuleCardModifier<SurplusEnvelopeRule> {
  @override
  String getName(SurplusEnvelopeRule rule) {
    return 'Surplus';
  }

  @override
  Widget getIcon(SurplusEnvelopeRule rule) {
    return StyledIcon(FontAwesomeIcons.filter);
  }

  @override
  Widget getDescription(SurplusEnvelopeRule rule) {
    return StyledMarkdown(
      'Valet will add `${rule.percentProperty.value.formatIntOrDouble()}`% of any remaining income after your goals are complete to this envelope.',
    );
  }

  @override
  Port<SurplusEnvelopeRule> getPort({required CorePondContext context, SurplusEnvelopeRule? initialRule}) {
    throw UnimplementedError();
  }

  @override
  Widget getPortBuilder(Port<SurplusEnvelopeRule> port) {
    throw UnimplementedError();
  }
}
