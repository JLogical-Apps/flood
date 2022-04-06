import 'dart:async';

import '../state/state.dart';
import 'field/schema_field.dart';
import 'package:collection/collection.dart';

class Schema {
  final Map<String, SchemaField> data;
  final Schema? previousSchema;
  final FutureOr Function(State state)? migrator;

  const Schema({required this.data, this.previousSchema, this.migrator});

  /// Returns the first matching schema in the subset of schemas that match [state].
  Schema? findMatchingSchema(State state) {
    return getSchemaChain().firstWhereOrNull((schema) => schema.matches(state));
  }

  Future<void> migrate(State state) async {
    if (matches(state)) {
      return;
    }

    final originalState = state.copyWith();

    final previousSchema = this.previousSchema ?? (throw Exception('Invalid schema for state: [$state]'));
    await previousSchema.migrate(state);
    await migrator?.call(state);

    if (!matches(state)) {
      throw Exception(
          'Schema migration failed! Schema is [$this] which migrated a state from [$originalState] to [$state], which does not match the schema!');
    }
  }

  /// Returns whether [state] matches this schema.
  bool matches(State state) {
    return data.entries.every((schemaEntry) {
      final key = schemaEntry.key;

      final stateFieldExists = state.fullValues.containsKey(key);
      final stateValue = state[key];

      return schemaEntry.value.matches(stateFieldExists, stateValue);
    });
  }

  List<Schema> getSchemaChain() {
    var chain = <Schema>[];

    Schema? schema = this;
    while (schema != null) {
      chain.add(schema);
      schema = schema.previousSchema;
    }

    return chain;
  }
}
