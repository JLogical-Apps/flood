import 'package:flutter_test/flutter_test.dart';
import 'package:jlogical_utils/src/pond/repository/entity_repository.dart';
import 'package:jlogical_utils/src/pond/repository/with_id_generator.dart';
import 'package:jlogical_utils/src/pond/repository/local/with_local_entity_repository.dart';

import 'entities/envelope.dart';
import 'entities/envelope_entity.dart';

void main() {
  test('basic repository functions.', () async {
    final envelopeRepository = LocalEnvelopeRepository();
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
}

class LocalEnvelopeRepository = EntityRepository<EnvelopeEntity> with WithLocalEntityRepository, WithIdGenerator;
