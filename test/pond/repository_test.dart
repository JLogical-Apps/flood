import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:jlogical_utils/src/pond/repository/entity_repository.dart';
import 'package:jlogical_utils/src/pond/repository/local/with_local_entity_repository.dart';
import 'package:jlogical_utils/src/pond/repository/with_id_generator.dart';

import 'entities/envelope.dart';
import 'entities/envelope_entity.dart';

void main() {
  late LocalEnvelopeRepository envelopeRepository;
  setUp(() {
    AppContext.global = AppContext(
      entityRegistrations: [
        EntityRegistration<EnvelopeEntity, Envelope>((envelope) => EnvelopeEntity(initialEnvelope: envelope)),
      ],
      valueObjectRegistrations: [
        ValueObjectRegistration<Envelope, Envelope?>(() => Envelope()),
      ],
    );

    envelopeRepository = LocalEnvelopeRepository();
  });

  test('basic repository functions.', () async {
    final envelopeEntity = EnvelopeEntity(
        initialEnvelope: Envelope()
          ..nameProperty.value = 'Tithe'
          ..amountProperty.value = 24 * 100);

    await envelopeRepository.create(envelopeEntity);

    EnvelopeEntity? retrievedEnvelopeEntity = await envelopeRepository.get(envelopeEntity.id!);

    expect(envelopeEntity, equals(retrievedEnvelopeEntity));
    expect(envelopeEntity.state, equals(retrievedEnvelopeEntity.state));

    envelopeEntity.changeName('Giving');
    envelopeRepository.save(envelopeEntity);

    retrievedEnvelopeEntity = await envelopeRepository.get(envelopeEntity.id!);

    expect(envelopeEntity, equals(retrievedEnvelopeEntity));
    expect(envelopeEntity.state, equals(retrievedEnvelopeEntity.state));

    await envelopeRepository.delete(envelopeEntity.id!);

    retrievedEnvelopeEntity = await envelopeRepository.getOrNull(envelopeEntity.id!);
    expect(retrievedEnvelopeEntity, isNull);
  });

  test('get streams.', () async {
    expect(envelopeRepository.getXOrNull('abc'), isNull);

    final envelopeEntity = EnvelopeEntity(
        initialEnvelope: Envelope()
          ..nameProperty.value = 'Tithe'
          ..amountProperty.value = 24 * 100);

    await envelopeRepository.create(envelopeEntity);

    final envelopeId = envelopeEntity.id!;

    final envelopeX = envelopeRepository.getXOrNull(envelopeId)!;
    Future<EnvelopeEntity> getStreamValue() async {
      final completer = Completer();
      late EnvelopeEntity envelope;
      late StreamSubscription sub;
      sub = envelopeX.listen((event) {
        envelope = event.get();
        completer.complete();
        sub.cancel();
      });
      await completer.future;
      return envelope;
    }
    var retrievedEnvelope = await getStreamValue();

    expect(retrievedEnvelope, envelopeEntity);
    expect(retrievedEnvelope.state, envelopeEntity.state);

    envelopeEntity.changeName('Giving');
    await envelopeRepository.save(envelopeEntity);

    retrievedEnvelope = await getStreamValue();

    expect(retrievedEnvelope, envelopeEntity);
    expect(retrievedEnvelope.state, envelopeEntity.state);
  });
}

class LocalEnvelopeRepository = EntityRepository<EnvelopeEntity> with WithLocalEntityRepository, WithIdGenerator;
