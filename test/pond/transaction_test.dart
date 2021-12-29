import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:jlogical_utils/src/pond/repository/local/default_local_repository.dart';

import 'entities/envelope.dart';
import 'entities/envelope_entity.dart';

void main() {
  late LocalEnvelopeRepository envelopeRepository;
  setUp(() {
    envelopeRepository = LocalEnvelopeRepository();
    AppContext.global = AppContext(
      registration: ExplicitAppRegistration(
        entityRegistrations: [
          EntityRegistration<EnvelopeEntity, Envelope>(() => EnvelopeEntity()),
        ],
        valueObjectRegistrations: [
          ValueObjectRegistration<Envelope, Envelope?>(() => Envelope()),
        ],
      ),
    );
  });
  test('basic repository actions.', () {
    final transaction = Transaction((t) async {
      final envelopeEntity = EnvelopeEntity()
        ..value = (Envelope()
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
    });

    envelopeRepository.executeTransaction(transaction);
  });

  test('locking', () async {
    var envelopeEntity = EnvelopeEntity()
      ..value = (Envelope()
        ..nameProperty.value = 'Tithe'
        ..amountProperty.value = 24 * 100);

    await envelopeRepository.create(envelopeEntity);

    final envelopeId = envelopeEntity.id!;

    final transactionsCompleter = Completer();

    final transactionGiving = Transaction((t) async {
      final envelopeEntity = await t.get<EnvelopeEntity>(envelopeId);

      expect(envelopeEntity.value.nameProperty.value, 'Tithe');

      envelopeEntity.changeName('Giving');

      await Future.delayed(Duration(milliseconds: 100));

      await t.save(envelopeEntity);
    });

    final transactionCar = Transaction((t) async {
      final envelopeEntity = await t.get<EnvelopeEntity>(envelopeId);

      expect(envelopeEntity.value.nameProperty.value, 'Giving');

      envelopeEntity.changeName('Car');

      await t.save(envelopeEntity);

      transactionsCompleter.complete();
    });

    await Future.wait([
      envelopeRepository.executeTransaction(transactionGiving),
      envelopeRepository.executeTransaction(transactionCar),
    ]);

    await transactionsCompleter.future;

    envelopeEntity = await envelopeRepository.get(envelopeId) as EnvelopeEntity;

    expect(envelopeEntity.value.nameProperty.value, 'Car');
  });

  test('reverting on exception.', () async {
    var envelopeEntity = EnvelopeEntity()
      ..value = (Envelope()
        ..nameProperty.value = 'Tithe'
        ..amountProperty.value = 24 * 100);

    await envelopeRepository.create(envelopeEntity);

    final envelopeId = envelopeEntity.id!;

    final transactionGiving = Transaction((t) async {
      final envelopeEntity = await t.get<EnvelopeEntity>(envelopeId);
      envelopeEntity.changeName('Giving');

      await t.save(envelopeEntity);

      expect(envelopeEntity.value.nameProperty.value, 'Giving');

      throw Exception('Force a revert');
    });

    try {
      await envelopeRepository.executeTransaction(transactionGiving);
    } on Exception {}

    envelopeEntity = await envelopeRepository.get(envelopeId) as EnvelopeEntity;

    expect(envelopeEntity.value.nameProperty.value, 'Tithe');
  });

  test('budget_transaction commit saves when done.', () async {
    final transactionCreate = Transaction((t) async {
      final envelopeEntity = EnvelopeEntity()
        ..value = (Envelope()
          ..nameProperty.value = 'Tithe'
          ..amountProperty.value = 24 * 100);

      await t.create(envelopeEntity);

      return envelopeEntity.id;
    });

    final envelopeId = await envelopeRepository.executeTransaction(transactionCreate);

    final envelopeEntity = await envelopeRepository.get(envelopeId!);

    expect(envelopeEntity, isNotNull);
  });

  test('simultaneous read/write while budget_transaction running.', () async {
    final otherStuffCompleter = Completer();

    final titheEnvelopeEntity = EnvelopeEntity()
      ..value = (Envelope()
        ..nameProperty.value = 'Tithe'
        ..amountProperty.value = 24 * 100);

    await envelopeRepository.create(titheEnvelopeEntity);

    final titheEnvelopeId = titheEnvelopeEntity.id!;

    final deleteTitheTransaction = Transaction((t) async {
      await t.delete(titheEnvelopeId);

      await otherStuffCompleter.future;

      final transactionEnvelope = await t.getOrNull<EnvelopeEntity>(titheEnvelopeId);
      expect(transactionEnvelope, isNull);

      final repositoryEnvelope = await envelopeRepository.get(titheEnvelopeId) as EnvelopeEntity;
      expect(repositoryEnvelope.value.nameProperty.value, 'Giving');
    });

    Future modifyTitheEnvelope() async {
      final envelopeEntity = await envelopeRepository.get(titheEnvelopeId) as EnvelopeEntity;
      envelopeEntity.changeName('Giving');
      await envelopeRepository.save(envelopeEntity);

      otherStuffCompleter.complete();
    }

    await Future.wait([envelopeRepository.executeTransaction(deleteTitheTransaction), modifyTitheEnvelope()]);

    final titheEnvelope = await envelopeRepository.getOrNull(titheEnvelopeId);
    expect(titheEnvelope, isNull);
  });

  test('query in budget_transaction.', () async {
    final titheEnvelopeEntity = EnvelopeEntity()
      ..value = (Envelope()
        ..nameProperty.value = 'Tithe'
        ..amountProperty.value = 24 * 100);

    await envelopeRepository.create(titheEnvelopeEntity);

    final modifyTitheTransaction = Transaction((t) async {
      final envelopesQuery = Query.from<EnvelopeEntity>().all();
      var envelopes = await t.executeQuery(envelopesQuery);
      var titheEnvelope = envelopes.first;

      expect(titheEnvelope, isNotNull);

      titheEnvelope.changeName('Giving');
      t.save(titheEnvelope);

      envelopes = await t.executeQuery(envelopesQuery);
      titheEnvelope = envelopes.first;

      expect(titheEnvelope.value.nameProperty.value, 'Giving');
    });

    await envelopeRepository.executeTransaction(modifyTitheTransaction);
  });
}

class LocalEnvelopeRepository extends DefaultLocalRepository<EnvelopeEntity, Envelope> {
  @override
  EnvelopeEntity createEntity() => EnvelopeEntity();

  @override
  Envelope createValueObject() => Envelope();
}
