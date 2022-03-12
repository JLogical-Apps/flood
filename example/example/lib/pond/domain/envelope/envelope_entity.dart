import 'package:example/pond/domain/envelope/envelope.dart';
import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class EnvelopeEntity extends Entity<Envelope> {
  @override
  Future<void> onInitialize() async {
    _ensureColorIsSet();
  }

  Future<void> _ensureColorIsSet() async {
    if (value.colorProperty.value == null) {
      final budgetId = value.budgetProperty.value;
      final budgetEnvelopes =
          await Query.from<EnvelopeEntity>().where(Envelope.budgetField, isEqualTo: budgetId).all().get();
      var index = budgetEnvelopes.indexOf(this);

      if (index == -1) {
        index = budgetEnvelopes.length;
      }

      final orderedColors = [
        Colors.blue,
        Colors.orange,
        Colors.green,
        Color(0xFFb0d266),
        Colors.pink,
        Colors.purpleAccent,
        Colors.deepPurpleAccent,
        Color(0xFFcc9900),
        Colors.teal,
      ];

      value = Envelope()
        ..copyFrom(value)
        ..colorProperty.value = orderedColors[index % orderedColors.length].value;
    }
  }
}
