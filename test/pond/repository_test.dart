import 'package:flutter_test/flutter_test.dart';
import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:jlogical_utils/src/pond/repository/local/default_local_repository.dart';

import 'entities/envelope.dart';
import 'entities/envelope_entity.dart';

void main() {
  setUp(() {
    AppContext.global = AppContext(
      registration: DatabaseAppRegistration(repositories: [
        LocalEnvelopeRepository(),
      ]),
    );
  });

  test('basic repository functions.', () async {
    final envelopeEntity = EnvelopeEntity()
      ..value = (Envelope()
        ..nameProperty.value = 'Tithe'
        ..amountProperty.value = 24 * 100);

    await envelopeEntity.create();

    EnvelopeEntity? retrievedEnvelopeEntity = await AppContext.global.get<EnvelopeEntity>(envelopeEntity.id!);

    expect(envelopeEntity, equals(retrievedEnvelopeEntity));
    expect(envelopeEntity.state, equals(retrievedEnvelopeEntity.state));

    envelopeEntity.changeName('Giving');
    await envelopeEntity.save();

    retrievedEnvelopeEntity = await AppContext.global.get<EnvelopeEntity>(envelopeEntity.id!);

    expect(envelopeEntity, equals(retrievedEnvelopeEntity));
    expect(envelopeEntity.state, equals(retrievedEnvelopeEntity.state));

    await envelopeEntity.delete();

    retrievedEnvelopeEntity = await AppContext.global.getOrNull<EnvelopeEntity>(envelopeEntity.id!);
    expect(retrievedEnvelopeEntity, isNull);
  });

  test('get streams.', () async {
    final envelopeEntity = EnvelopeEntity()
      ..value = (Envelope()
        ..nameProperty.value = 'Tithe'
        ..amountProperty.value = 24 * 100);

    await envelopeEntity.create();

    final envelopeId = envelopeEntity.id!;

    final envelopeX = AppContext.global.getXOrNull<EnvelopeEntity>(envelopeId);
    var retrievedEnvelope = (await envelopeX.getCurrentValue()).get();

    expect(retrievedEnvelope, envelopeEntity);
    expect(retrievedEnvelope.state, envelopeEntity.state);

    envelopeEntity.changeName('Giving');
    await envelopeEntity.save();

    retrievedEnvelope = (await envelopeX.getCurrentValue()).get();

    expect(retrievedEnvelope, envelopeEntity);
    expect(retrievedEnvelope.state, envelopeEntity.state);
  });
}

class LocalEnvelopeRepository extends DefaultLocalRepository<EnvelopeEntity, Envelope> {
  @override
  EnvelopeEntity createEntity() => EnvelopeEntity();

  @override
  Envelope createValueObject() => Envelope();
}
