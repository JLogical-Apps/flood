import 'package:example/features/envelope_rule/envelope_rule.dart';
import 'package:example/presentation/widget/envelope_rule/envelope_card_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class NoneEnvelopeCardWrapper extends EnvelopeRuleCardWrapper<EnvelopeRule?> {
  @override
  String getName(EnvelopeRule? rule) {
    return 'None';
  }

  @override
  Widget getIcon(EnvelopeRule? rule) {
    return StyledIcon(Icons.block);
  }

  @override
  Widget getDescription(EnvelopeRule? rule) {
    return StyledMarkdown(
        'Valet will never add income to this envelope automatically, giving you total control over the money in this envelope. Use transactions or transfers to control the money in this envelope.');
  }

  @override
  Port<EnvelopeRule?> getPort({required CorePondContext context, EnvelopeRule? initialRule}) {
    return Port.empty();
  }

  @override
  Widget getPortBuilder(Port<EnvelopeRule?> port) {
    return Container();
  }
}
