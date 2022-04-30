import 'package:flutter_test/flutter_test.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

import 'entities/envelope.dart';
import 'entities/envelope_entity.dart';

void main() {
  setUp(() {
    AppContext.global = AppContext.createForTesting()
      ..registerForTesting()
      ..register(LocalEnvelopeRepository());
  });

  test('basic repository functions.', () async {
    final envelopeEntity = EnvelopeEntity()
      ..value = (Envelope()
        ..nameProperty.value = 'Tithe'
        ..amountProperty.value = 24 * 100);

    await envelopeEntity.create();

    var retrievedEnvelopeEntity = await Query.getById<EnvelopeEntity>(envelopeEntity.id!).get();

    expect(envelopeEntity, equals(retrievedEnvelopeEntity));
    expect(envelopeEntity.state, equals(retrievedEnvelopeEntity!.state));

    envelopeEntity.changeName('Giving');
    await envelopeEntity.save();

    retrievedEnvelopeEntity = await Query.getById<EnvelopeEntity>(envelopeEntity.id!).get();

    expect(envelopeEntity, equals(retrievedEnvelopeEntity));
    expect(envelopeEntity.state, equals(retrievedEnvelopeEntity!.state));

    await envelopeEntity.delete();

    retrievedEnvelopeEntity = await Query.getById<EnvelopeEntity>(envelopeEntity.id!).get();
    expect(retrievedEnvelopeEntity, isNull);
  });

  test('get streams.', () async {
    final envelopeEntity = EnvelopeEntity()
      ..value = (Envelope()
        ..nameProperty.value = 'Tithe'
        ..amountProperty.value = 24 * 100);

    await envelopeEntity.create();

    final envelopeId = envelopeEntity.id!;

    final envelopeX = AppContext.global.executeQueryX(Query.getById<EnvelopeEntity>(envelopeId));
    var retrievedEnvelope = (await envelopeX.getCurrentValue()).get()!;

    expect(retrievedEnvelope, envelopeEntity);
    expect(retrievedEnvelope.state, envelopeEntity.state);

    envelopeEntity.changeName('Giving');
    await envelopeEntity.save();

    retrievedEnvelope = (await envelopeX.getCurrentValue()).get()!;

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
