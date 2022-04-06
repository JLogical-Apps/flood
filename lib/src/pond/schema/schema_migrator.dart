import 'package:jlogical_utils/src/pond/schema/schema.dart';
import 'package:jlogical_utils/src/pond/state/state.dart';

class SchemaMigrator {
  final Schema schema;

  const SchemaMigrator({required this.schema});

  /// Returns whether the [state] was migrated.
  Future<bool> migrate(State state) async {
    if (schema.matches(state)) {
      return false;
    }

    if (schema.findMatchingSchema(state) == null) {
      throw Exception('Invalid schema for state [$state]');
    }

    await schema.migrate(state);

    return true;
  }
}
