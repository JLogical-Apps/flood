import 'package:flutter_test/flutter_test.dart';
import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:jlogical_utils/src/pond/context/registration/database_app_registration.dart';
import 'package:jlogical_utils/src/pond/context/registration/registrations_provider.dart';
import 'package:jlogical_utils/src/pond/context/registration/with_domain_registrations_provider.dart';
import 'package:jlogical_utils/src/pond/repository/entity_repository.dart';
import 'package:jlogical_utils/src/pond/repository/local/with_local_entity_repository.dart';
import 'package:jlogical_utils/src/pond/repository/with_id_generator.dart';

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
    final envelopeEntity = EnvelopeEntity(
        initialEnvelope: Envelope()
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
    expect(AppContext.global.getXOrNull<EnvelopeEntity>('abc'), isNull);

    final envelopeEntity = EnvelopeEntity(
        initialEnvelope: Envelope()
          ..nameProperty.value = 'Tithe'
          ..amountProperty.value = 24 * 100);

    await envelopeEntity.create();

    final envelopeId = envelopeEntity.id!;

    final envelopeX = AppContext.global.getXOrNull<EnvelopeEntity>(envelopeId)!;
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

class LocalEnvelopeRepository extends EntityRepository
    with
        WithMonoEntityRepository<EnvelopeEntity>,
        WithLocalEntityRepository,
        WithIdGenerator,
        WithDomainRegistrationsProvider<Envelope, EnvelopeEntity>
    implements RegistrationsProvider {
  @override
  EnvelopeEntity createEntity(Envelope initialValue) => EnvelopeEntity(initialEnvelope: initialValue);

  @override
  Envelope createValueObject() => Envelope();
}
