import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

import 'envelope.dart';
import 'envelope_entity.dart';

class EnvelopeSchema {
  static Schema schema = Schema(
    data: {
      'name': SchemaField.string.required,
      'budget': SchemaField.string.required,
      'amount': SchemaField.int,
      'color': SchemaField.int.required,
    },
    previousSchema: _v1Schema,
    migrator: (state) async {
      String budgetId = state['budget'];
      final budgetEnvelopeStates =
          await Query.from<EnvelopeEntity>().where(Envelope.budgetField, isEqualTo: budgetId).all().raw().get();

      var index = budgetEnvelopeStates.indexWhere((envelopeState) => envelopeState.id == state.id);

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

      state['color'] = orderedColors[index].value;
    },
  );

  static Schema _v1Schema = Schema(data: {
    'name': SchemaField.string.required,
    'budget': SchemaField.string.required,
    'amount': SchemaField.int,
  });
}
