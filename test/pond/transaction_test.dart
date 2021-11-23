import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:jlogical_utils/src/pond/transaction/transaction_builder.dart';

import 'entities/envelope.dart';
import 'entities/envelope_entity.dart';

void main() {
  late LocalEnvelopeRepository envelopeRepository;
  setUp(() {
    envelopeRepository = LocalEnvelopeRepository();
  });
  test('basic repository actions.', () {
    final transaction = TransactionBuilder((t) async {
      final envelopeEntity = EnvelopeEntity(
          initialEnvelope: Envelope()
            ..nameProperty.value = 'Tithe'
            ..amountProperty.value = 24 * 100);

      await t.create(envelopeEntity);

      EnvelopeEntity? retrievedEnvelopeEntity = await t.get(envelopeEntity.id!);

      expect(envelopeEntity, equals(retrievedEnvelopeEntity));
      expect(envelopeEntity.state, equals(retrievedEnvelopeEntity.state));

      envelopeEntity.changeName('Giving');
      t.save(envelopeEntity);

      retrievedEnvelopeEntity = await t.getOrNull<EnvelopeEntity>(envelopeEntity.id!);

      expect(envelopeEntity, equals(retrievedEnvelopeEntity));
      expect(envelopeEntity.state, equals(retrievedEnvelopeEntity!.state));

      await t.delete(envelopeEntity.id!);

      retrievedEnvelopeEntity = await t.getOrNull<EnvelopeEntity>(envelopeEntity.id!);
      expect(retrievedEnvelopeEntity, isNull);
    }).build();

    envelopeRepository.executeTransaction(transaction);
  });

  test('locking', () async {
    final envelopeEntity = EnvelopeEntity(
        initialEnvelope: Envelope()
          ..nameProperty.value = 'Tithe'
          ..amountProperty.value = 24 * 100);

    await envelopeRepository.createIsolated(envelopeEntity);

    final envelopeId = envelopeEntity.id!;

    final transactionsCompleter = Completer();

    final transactionGiving = TransactionBuilder((t) async {
      final envelopeEntity = await t.get<EnvelopeEntity>(envelopeId);

      expect(envelopeEntity.value.nameProperty.value, 'Tithe');

      envelopeEntity.changeName('Giving');

      await Future.delayed(Duration(milliseconds: 100));

      await t.save(envelopeEntity);
    }).build();

    final transactionCar = TransactionBuilder((t) async {
      final envelopeEntity = await t.get<EnvelopeEntity>(envelopeId);

      expect(envelopeEntity.value.nameProperty.value, 'Giving');

      envelopeEntity.changeName('Car');

      await t.save(envelopeEntity);

      transactionsCompleter.complete();
    }).build();

    envelopeRepository.executeTransaction(transactionGiving);
    envelopeRepository.executeTransaction(transactionCar);

    await transactionsCompleter.future;

    expect(envelopeEntity.value.nameProperty.value, 'Car');
  });

  test('reverting on exception.', () async {
    var envelopeEntity = EnvelopeEntity(
        initialEnvelope: Envelope()
          ..nameProperty.value = 'Tithe'
          ..amountProperty.value = 24 * 100);

    await envelopeRepository.createIsolated(envelopeEntity);

    final envelopeId = envelopeEntity.id!;

    final transactionGiving = TransactionBuilder((t) async {
      final envelopeEntity = await t.get<EnvelopeEntity>(envelopeId);
      envelopeEntity.changeName('Giving');

      await t.save(envelopeEntity);

      expect(envelopeEntity.value.nameProperty.value, 'Giving');

      throw Exception('Force a revert');
    }).build();

    await envelopeRepository.executeTransaction(transactionGiving);

    envelopeEntity = await envelopeRepository.getIsolated(envelopeId);

    expect(envelopeEntity.value.nameProperty.value, 'Tithe');
  });
}

class LocalEnvelopeRepository = EntityRepository<EnvelopeEntity>
    with WithLocalEntityRepository, WithIdGenerator, WithKeySynchronizable<Transaction>;
