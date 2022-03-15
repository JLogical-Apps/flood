import 'package:flutter_test/flutter_test.dart';
import 'package:jlogical_utils/src/pond/export.dart';
import 'package:jlogical_utils/src/pond/record/immutability_violation_error.dart';
import 'package:rxdart/rxdart.dart';

import 'entities/color.dart';
import 'entities/envelope.dart';
import 'entities/envelope_entity.dart';

void main() {
  final now = DateTime.now();
  setUp(() async {
    AppContext.global = AppContext.createForTesting(now: now);
  });

  test('simple value object has proper state.', () {
    final envelope = Envelope()
      ..nameProperty.value = 'Tithe'
      ..amountProperty.value = 24 * 100;

    expect(
      envelope.state,
      State(
        type: '$Envelope',
        values: {
          'name': 'Tithe',
          'amount': 24 * 100,
          'timeCreated': now.millisecondsSinceEpoch,
        },
      ),
    );
  });

  test('equality of ValueObjects is their state.', () {
    final white = Color()..rgbProperty.value = {'r': 0, 'g': 0, 'b': 0};

    final white2 = Color()..rgbProperty.value = {'r': 0, 'g': 0, 'b': 0};

    final black = Color()..rgbProperty.value = {'r': 255, 'g': 255, 'b': 255};

    expect(white, equals(white2));
    expect(white, isNot(equals(black)));
  });

  test('equality of Entities is their id.', () {
    final originalEnvelope = EnvelopeEntity()
      ..value = (Envelope()
        ..nameProperty.value = 'A'
        ..amountProperty.value = 204 * 100)
      ..id = 'envelope';

    final envelopeWithSameIdDifferentContent = EnvelopeEntity()
      ..value = (Envelope()
        ..nameProperty.value = 'B'
        ..amountProperty.value = 24 * 100)
      ..id = 'envelope';

    final envelopeWithDifferentIdSameContent = EnvelopeEntity()
      ..value = (Envelope()
        ..nameProperty.value = 'A'
        ..amountProperty.value = 204 * 100)
      ..id = 'something_different';

    expect(originalEnvelope, equals(envelopeWithSameIdDifferentContent));
    expect(originalEnvelope, isNot(equals(envelopeWithDifferentIdSameContent)));
  });

  test('can change properties of Entity after validation.', () {
    final envelope = EnvelopeEntity()
      ..value = (Envelope()
        ..nameProperty.value = 'Tithe'
        ..amountProperty.value = 25 * 100);

    expect(() => envelope.changeName('Giving'), returnsNormally);
  });

  test('cannot change properties of ValueObjects once validated.', () {
    final color = Color()
      ..rgbProperty.value = {
        'r': 255,
        'g': 255,
        'b': 255,
      }
      ..validate();

    expect(
      () => color.rgbProperty.value = {'r': 0, 'g': 0, 'b': 0},
      throwsA(isA<ImmutabilityViolationError>()),
    );
  });

  test('lifecycle events', () async {
    AppContext.global = AppContext.createForTesting()..register(LifecycleRepository());
    final lifecycleEntity = LifecycleEntity()..value = Lifecycle();

    var onInitialize = false;
    var afterCreate = false;
    var beforeSave = false;
    var afterSave = false;
    var beforeDelete = false;

    lifecycleEntity.onInitializeX.listen((_) => onInitialize = true);
    lifecycleEntity.afterCreateX.listen((_) => afterCreate = true);
    lifecycleEntity.beforeSaveX.listen((_) => beforeSave = true);
    lifecycleEntity.afterSaveX.listen((_) => afterSave = true);
    lifecycleEntity.beforeDeleteX.listen((_) => beforeDelete = true);

    await lifecycleEntity.create();

    expect(onInitialize, true);
    expect(afterCreate, true);
    expect(beforeSave, true);
    expect(afterSave, true);
    expect(beforeDelete, false);

    afterCreate = false;
    beforeSave = false;
    afterSave = false;
    beforeDelete = false;

    await lifecycleEntity.save();

    expect(afterCreate, false);
    expect(beforeSave, true);
    expect(afterSave, true);
    expect(beforeDelete, false);

    afterCreate = false;
    beforeSave = false;
    afterSave = false;
    beforeDelete = false;

    await lifecycleEntity.delete();

    expect(afterCreate, false);
    expect(beforeSave, false);
    expect(afterSave, false);
    expect(beforeDelete, true);
  });

  test('copying ValueObjects', () {
    final envelope = Envelope()
      ..nameProperty.value = 'Tithe'
      ..amountProperty.value = 12 * 100;

    final envelopeCopy = envelope.copy();
    expect(envelopeCopy, envelope);

    final envelopeModification = envelope.copy()..nameProperty.value = 'Giving';

    expect(envelopeModification.nameProperty.value, 'Giving');
    expect(envelopeModification.amountProperty.value, 12 * 100);
  });
}

class Lifecycle extends ValueObject {}

class LifecycleEntity extends Entity<Lifecycle> {
  final BehaviorSubject onInitializeX = BehaviorSubject();
  final BehaviorSubject afterCreateX = BehaviorSubject();
  final BehaviorSubject beforeSaveX = BehaviorSubject();
  final BehaviorSubject afterSaveX = BehaviorSubject();
  final BehaviorSubject beforeDeleteX = BehaviorSubject();

  @override
  Future<void> onInitialize() {
    onInitializeX.value = 0;
    return super.onInitialize();
  }

  @override
  Future<void> afterCreate() {
    afterCreateX.value = 0;
    return super.afterCreate();
  }

  @override
  Future<void> beforeSave() {
    beforeSaveX.value = 0;
    return super.beforeSave();
  }

  @override
  Future<void> afterSave() {
    afterSaveX.value = 0;
    return super.afterSave();
  }

  @override
  Future<void> beforeDelete() {
    beforeDeleteX.value = 0;
    return super.beforeDelete();
  }
}

class LifecycleRepository extends DefaultLocalRepository<LifecycleEntity, Lifecycle> {
  @override
  LifecycleEntity createEntity() {
    return LifecycleEntity();
  }

  @override
  Lifecycle createValueObject() {
    return Lifecycle();
  }
}
