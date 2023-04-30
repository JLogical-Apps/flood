import 'dart:async';

import 'package:example/features/envelope/envelope.dart';
import 'package:example/presentation/style.dart';
import 'package:example/presentation/widget/envelope_rule/envelope_card_modifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class EnvelopeCard extends HookWidget {
  final Envelope envelope;

  final FutureOr Function()? onPressed;

  const EnvelopeCard({super.key, required this.envelope, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final envelopeRuleCardWrapper = EnvelopeRuleCardModifier.getModifier(envelope.ruleProperty.value);
    return StyledCard(
      leading: envelopeRuleCardWrapper.getIcon(envelope.ruleProperty.value, color: Color(envelope.colorProperty.value)),
      title: StyledText.h6.withColor(Color(envelope.colorProperty.value))(envelope.nameProperty.value),
      body: StyledText.body.withColor(getCentsColor(envelope.amountCentsProperty.value))(
          envelope.amountCentsProperty.value.formatCentsAsCurrency()),
      onPressed: onPressed,
    );
  }
}
