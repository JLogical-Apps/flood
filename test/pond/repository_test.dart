import 'dart:async';

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

    await AppContext.global.create<EnvelopeEntity>(envelopeEntity);

    EnvelopeEntity? retrievedEnvelopeEntity = await AppContext.global.get<EnvelopeEntity>(envelopeEntity.id!);

    expect(envelopeEntity, equals(retrievedEnvelopeEntity));
    expect(envelopeEntity.state, equals(retrievedEnvelopeEntity.state));

    envelopeEntity.changeName('Giving');
    AppContext.global.save(envelopeEntity);

    retrievedEnvelopeEntity = await AppContext.global.get<EnvelopeEntity>(envelopeEntity.id!);

    expect(envelopeEntity, equals(retrievedEnvelopeEntity));
    expect(envelopeEntity.state, equals(retrievedEnvelopeEntity.state));

    await AppContext.global.delete<EnvelopeEntity>(envelopeEntity.id!);

    retrievedEnvelopeEntity = await AppContext.global.getOrNull<EnvelopeEntity>(envelopeEntity.id!);
    expect(retrievedEnvelopeEntity, isNull);
  });

  test('get streams.', () async {
    expect(AppContext.global.getXOrNull<EnvelopeEntity>('abc'), isNull);

    final envelopeEntity = EnvelopeEntity(
        initialEnvelope: Envelope()
          ..nameProperty.value = 'Tithe'
          ..amountProperty.value = 24 * 100);

    await AppContext.global.create(envelopeEntity);

    final envelopeId = envelopeEntity.id!;

    final envelopeX = AppContext.global.getXOrNull<EnvelopeEntity>(envelopeId)!;
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
    await AppContext.global.save<EnvelopeEntity>(envelopeEntity);

    retrievedEnvelope = await getStreamValue();

    expect(retrievedEnvelope, envelopeEntity);
    expect(retrievedEnvelope.state, envelopeEntity.state);
  });
}

class LocalEnvelopeRepository extends EntityRepository<EnvelopeEntity>
    with WithLocalEntityRepository, WithIdGenerator, WithDomainRegistrationsProvider<Envelope, EnvelopeEntity>
    implements RegistrationsProvider {
  @override
  EnvelopeEntity createEntity(Envelope initialValue) => EnvelopeEntity(initialEnvelope: initialValue);

  @override
  Envelope createValueObject() => Envelope();
}
