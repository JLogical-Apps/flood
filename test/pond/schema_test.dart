import 'package:flutter_test/flutter_test.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

import 'entities/color.dart';
import 'entities/user_avatar.dart';

void main() {
  test('schema matcher matches a state to the right schema.', () {
    final schema1 = Schema(
      data: {
        'name': SchemaField.string.required,
        'cents': SchemaField.int.required,
      },
    );

    final schema2 = Schema(
      data: {
        'name': SchemaField.string.required,
        'cents': SchemaField.int.required,
        'color': SchemaField.int.present,
      },
      previousSchema: schema1,
      migrator: (state) {
        state['color'] = 0x000000;
      },
    );

    final schema1State = State(values: {
      'name': 'Tithe',
      'cents': 23 * 100,
    });
    expect(schema2.findMatchingSchema(schema1State), schema1);

    final schema2State = State(values: {
      'name': 'Tithe',
      'cents': 23 * 100,
      'color': 0x000000,
    });
    expect(schema2.findMatchingSchema(schema2State), schema2);

    final schema2StateWithPresentField = State(values: {
      'name': 'Tithe',
      'cents': 23 * 100,
      'color': null,
    });
    expect(schema2.findMatchingSchema(schema2StateWithPresentField), schema2);

    final schema2StateWithExtraField = State(values: {
      'name': 'Tithe',
      'cents': 23 * 100,
      'color': 0x000000,
      'notes': 'These are some notes',
    });
    expect(schema2.findMatchingSchema(schema2StateWithExtraField), schema2);

    final noSchemaState = State(values: {
      'name': null,
      'cents': 23 * 100,
      'color': 0x000000,
    });
    expect(schema2.findMatchingSchema(noSchemaState), null);

    final noSchemaMismatchingTypeState = State(values: {
      'name': 35,
      'cents': 23 * 100,
      'color': 0x000000,
    });
    expect(schema2.findMatchingSchema(noSchemaMismatchingTypeState), null);
  });

  test('schema migrator.', () async {
    final schema1 = Schema(
      data: {
        'name': SchemaField.string.required,
        'cents': SchemaField.int.required,
      },
    );

    final schema2 = Schema(
      data: {
        'name': SchemaField.string.required,
        'cents': SchemaField.int.required,
        'color': SchemaField.int.present,
      },
      previousSchema: schema1,
      migrator: (state) {
        state['color'] = 0x000000;
      },
    );

    final state = State(values: {
      'name': 'Tithe',
      'cents': 23 * 100,
    });

    final migrated = await SchemaMigrator(schema: schema2).migrate(state);

    expect(migrated, isTrue);
    expect(state['color'], isNotNull);
  });

  test('schema migrator when intermediary schema does no migration.', () async {
    final schema1 = Schema(
      data: {
        'name': SchemaField.string.required,
        'cents': SchemaField.int.required,
      },
    );

    final schema2 = Schema(
      data: {
        'name': SchemaField.string.required,
        'cents': SchemaField.int.required,
        'notes': SchemaField.string,
      },
      previousSchema: schema1,
    );

    final schema3 = Schema(
      data: {
        'name': SchemaField.string.required,
        'cents': SchemaField.int.required,
        'notes': SchemaField.string,
        'color': SchemaField.int.present,
      },
      migrator: (state) {
        state['color'] = 0x000000;
      },
      previousSchema: schema2,
    );

    final state = State(values: {
      'name': 'Tithe',
      'cents': 23 * 100,
    });

    final migrated = await SchemaMigrator(schema: schema3).migrate(state);

    expect(migrated, isTrue);
    expect(state['color'], isNotNull);
  });

  test('list schema.', () {
    final listSchema = Schema(
      data: {
        'name': SchemaField.string.required,
        'envelopes': SchemaField.list(SchemaField.string).present,
      },
    );

    final passingState = State(values: {
      'name': 'Budget',
      'envelopes': ['e1', 'e2'],
    });
    expect(listSchema.matches(passingState), isTrue);

    final passingStateEmptyList = State(values: {
      'name': 'Budget',
      'envelopes': [],
    });
    expect(listSchema.matches(passingStateEmptyList), isTrue);

    final failingStateWrongType = State(values: {
      'name': 'Budget',
      'envelopes': [1, 2, 3],
    });
    expect(listSchema.matches(failingStateWrongType), isFalse);

    final failingStateNotPresent = State(values: {'name': 'Budget'});
    expect(listSchema.matches(failingStateNotPresent), isFalse);
  });

  test('embedded value objects.', () {
    AppContext.global = AppContext.createForTesting()
      ..registerForTesting()
      ..register(SimpleAppModule(valueObjectRegistrations: [
        ValueObjectRegistration<UserAvatar, UserAvatar?>(() => UserAvatar()),
        ValueObjectRegistration<Color, Color?>(() => Color()),
      ]));

    final userAvatarSchema = Schema(
      data: {
        'color': SchemaField.embedded<Color>().required,
      },
    );

    final passingState = State(values: {
      'color': {
        '_type': '$Color',
        'rgb': {
          'r': 1,
          'g': 3,
          'b': 3,
        }
      }
    });
    expect(userAvatarSchema.matches(passingState), isTrue);

    final failingStateIncompatibleType = State(values: {
      'color': {
        'asdf': 3,
      }
    });
    expect(userAvatarSchema.matches(failingStateIncompatibleType), isFalse);

    final failingStateMissing = State(values: {'name': 'Jeff!'});
    expect(userAvatarSchema.matches(failingStateMissing), isFalse);
  });
}
