import 'package:example/pond/domain/envelope/envelope.dart';
import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class EnvelopeEntity extends Entity<Envelope> {
  @override
  Future<void> beforeSave() async {
    await _ensureColorSet();
  }

  static Future<int?> getEnvelopeColor({required String? envelopeId, required String? budgetId}) async {
    // In some old schema where the envelope does not have a budget, just return.
    if (budgetId == null) {
      return null;
    }

    final budgetEnvelopeStates =
        await Query.from<EnvelopeEntity>().where(Envelope.budgetField, isEqualTo: budgetId).all().raw().get();
    var index = budgetEnvelopeStates.map((state) => state.id).toList().indexOf(envelopeId);

    if (index == -1) {
      index = budgetEnvelopeStates.length;
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

    return orderedColors[index % orderedColors.length].value;
  }

  Future<void> _ensureColorSet() async {
    if (value.colorProperty.getUnvalidated() != null) {
      return;
    }

    final color = await EnvelopeEntity.getEnvelopeColor(envelopeId: id, budgetId: value.budgetProperty.value);
    value.colorProperty.value = color;
  }
}
