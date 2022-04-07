import 'package:jlogical_utils/jlogical_utils.dart';

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
      state['color'] = await EnvelopeEntity.getEnvelopeColor(envelopeId: state.id, budgetId: budgetId);
    },
  );

  static Schema _v1Schema = Schema(data: {
    'name': SchemaField.string.required,
    'budget': SchemaField.string.required,
    'amount': SchemaField.int,
  });
}
