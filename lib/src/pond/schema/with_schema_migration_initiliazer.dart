import 'package:jlogical_utils/src/pond/schema/schema.dart';
import 'package:jlogical_utils/src/pond/schema/schema_migrator.dart';

import '../record/entity.dart';
import '../record/value_object.dart';

mixin WithSchemaMigrationInitializer<V extends ValueObject> on Entity<V> {
  Schema get schema;

  @override
  Future<void> onInitialize() async {
    final _state = state;
    final migrated = await SchemaMigrator(schema: schema).migrate(_state);
    if (migrated) {
      state = _state;
      await save();
    }
  }
}
