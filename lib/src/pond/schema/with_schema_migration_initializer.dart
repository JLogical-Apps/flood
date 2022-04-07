import 'package:jlogical_utils/src/pond/schema/schema.dart';
import 'package:jlogical_utils/src/pond/schema/schema_migrator.dart';

import '../repository/entity_repository.dart';
import '../state/state.dart';

mixin WithSchemaMigrationStateInitializer on EntityRepository {
  Schema get schema;

  @override
  Future<void> initializeState(State state) async {
    final _state = state;
    final migrated = await SchemaMigrator(schema: schema).migrate(_state);
    if (migrated) {
      state = _state;
      await saveState(state);
    }
  }
}
