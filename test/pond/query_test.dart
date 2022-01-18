import 'package:flutter_test/flutter_test.dart';
import 'package:jlogical_utils/src/model/future_value.dart';
import 'package:jlogical_utils/src/pond/context/registration/entity_registration.dart';
import 'package:jlogical_utils/src/pond/context/registration/value_object_registration.dart';
import 'package:jlogical_utils/src/pond/export.dart';
import 'package:jlogical_utils/src/utils/stream_extensions.dart';

import 'entities/budget.dart';
import 'entities/budget_entity.dart';
import 'entities/budget_transaction.dart';
import 'entities/budget_transaction_entity.dart';
import 'entities/envelope.dart';
import 'entities/envelope_entity.dart';
import 'entities/envelope_transaction.dart';
import 'entities/envelope_transaction_entity.dart';
import 'entities/lucky_numbers.dart';
import 'entities/lucky_numbers_entity.dart';
import 'entities/transfer_transaction.dart';
import 'entities/transfer_transaction_entity.dart';

late DateTime now = DateTime.now();

late List<Envelope> envelopes = [
  Envelope()
    ..nameProperty.value = 'Tithe'
    ..amountProperty.value = 24 * 100
    ..timeCreatedProperty.value = now,
  Envelope()
    ..nameProperty.value = 'Investing'
    ..amountProperty.value = 81 * 100
    ..timeCreatedProperty.value = now.subtract(Duration(minutes: 1)),
  Envelope()
    ..nameProperty.value = 'Car'
    ..amountProperty.value = 0
    ..timeCreatedProperty.value = now.subtract(Duration(minutes: 2)),
  Envelope()
    ..nameProperty.value = 'House'
    ..amountProperty.value = 0
    ..timeCreatedProperty.value = now.subtract(Duration(minutes: 3)),
];

List<Budget> budgets = [
  Budget()
    ..nameProperty.value = 'Budget A'
    ..ownerProperty.value = 'Jake',
];

void main() {
  setUp(() async {
    AppContext.global = AppContext()
      ..register(LocalEnvelopeRepository())
      ..register(LocalBudgetRepository());

    await _populateRepositories();
  });

  test('all from a type.', () async {
    final allEnvelopesQuery = Query.from<EnvelopeEntity>().all();
    final resultEnvelopeEntities = await AppContext.global.executeQuery(allEnvelopesQuery);
    final resultEnvelopeValueObjects = resultEnvelopeEntities.map((envelopeEntity) => envelopeEntity.value).toList();
    expect(resultEnvelopeValueObjects, envelopes);

    final allBudgetsQuery = Query.from<BudgetEntity>().all();
    final resultBudgetEntities = await AppContext.global.executeQuery(allBudgetsQuery);
    final resultBudgetValueObjects = resultBudgetEntities.map((budgetEntity) => budgetEntity.value).toList();
    expect(resultBudgetValueObjects, budgets);
  });

  test('with condition', () async {
    final emptyEnvelopesQuery = Query.from<EnvelopeEntity>().where(Envelope.amountField, isEqualTo: 0).all();
    final resultEnvelopeEntities = await AppContext.global.executeQuery(emptyEnvelopesQuery);
    final resultEnvelopeValueObjects = resultEnvelopeEntities.map((envelopeEntity) => envelopeEntity.value).toList();
    expect(resultEnvelopeValueObjects, envelopes.where((envelope) => envelope.amountProperty.value == 0).toList());
  });

  test('as stream', () async {
    final emptyEnvelopesQuery = Query.from<EnvelopeEntity>().where(Envelope.amountField, isEqualTo: 0).all();
    final resultEnvelopeEntitiesX = AppContext.global.executeQueryX(emptyEnvelopesQuery);
    expect(resultEnvelopeEntitiesX.value, FutureValue<List<EnvelopeEntity>>.initial());

    await expectLater(
      resultEnvelopeEntitiesX
          .mapWithValue((value) => value.getOrNull()?.map((envelopeEntity) => envelopeEntity.value).toList())
          .where((value) => value != null)
          .map((value) => value!),
      emits(envelopes.where((envelope) => envelope.amountProperty.value == 0).toList()),
    );

    final emptyEnvelopes = (await resultEnvelopeEntitiesX.getCurrentValue()).get();
    final emptyEnvelope = emptyEnvelopes.first;

    emptyEnvelope.changeAmount(2 * 100); // Not empty anymore.

    await emptyEnvelope.save();

    await expectLater(
      resultEnvelopeEntitiesX
          .mapWithValue((value) => value.getOrNull()?.map((envelopeEntity) => envelopeEntity.value).toList())
          .where((value) => value != null)
          .map((value) => value!.length),
      emitsThrough(1), // Use emitsThrough instead of emits because of async issue.
    );
  });

  test('from id', () async {
    final firstEnvelope = await AppContext.global.executeQuery(Query.from<EnvelopeEntity>().firstOrNull());

    final queryById = Query.from<EnvelopeEntity>().where(Query.id, isEqualTo: firstEnvelope!.id).firstOrNull();
    final firstEnvelopeById = await AppContext.global.executeQuery(queryById);

    expect(firstEnvelopeById, firstEnvelope);
  });

  test('pagination', () async {
    final envelopePages = await AppContext.global.executeQuery(Query.from<EnvelopeEntity>().paginate(limit: 3));
    expect(envelopePages.results.length, 3);
    expect(envelopePages.results.map((entity) => entity.value), envelopes.take(3).toList());

    expect(envelopePages.canLoadMore, true);
    await envelopePages.loadMore();
    expect(envelopePages.results.length, 4);
    expect(envelopePages.results.map((entity) => entity.value), envelopes);

    expect(envelopePages.canLoadMore, false);
  });

  test('query from abstract class', () async {
    AppContext.global = AppContext()..register(LocalBudgetTransactionRepository());

    final envelopeTransaction = EnvelopeTransactionEntity()
      ..value = (EnvelopeTransaction()
        ..nameProperty.value = 'Tithe'
        ..amountProperty.value = 12 * 100);
    await envelopeTransaction.create();

    final transferTransaction = TransferTransactionEntity()
      ..value = (TransferTransaction()..amountProperty.value = 8 * 100);
    await transferTransaction.create();

    expect(await AppContext.global.executeQuery(Query.from<EnvelopeTransactionEntity>().all()), [envelopeTransaction]);
    expect(await AppContext.global.executeQuery(Query.from<TransferTransactionEntity>().all()), [transferTransaction]);
    expect(
      await AppContext.global.executeQuery(Query.from<BudgetTransactionEntity>().all()),
      containsAll([envelopeTransaction, transferTransaction]),
    );
  });

  test('without cache does not break query.', () async {
    final allEnvelopesQuery = Query.from<EnvelopeEntity>().all();
    final resultEnvelopeEntities = await AppContext.global.executeQuery(allEnvelopesQuery);

    final allEnvelopesQueryWithoutCache1 = Query.from<EnvelopeEntity>().withoutCache().all();
    final resultEnvelopeEntitiesWithoutCache1 = await AppContext.global.executeQuery(allEnvelopesQueryWithoutCache1);
    expect(resultEnvelopeEntitiesWithoutCache1, resultEnvelopeEntities);

    final allEnvelopesQueryWithoutCache2 = Query.from<EnvelopeEntity>().all().withoutCache();
    final resultEnvelopeEntitiesWithoutCache2 = await AppContext.global.executeQuery(allEnvelopesQueryWithoutCache2);
    expect(resultEnvelopeEntitiesWithoutCache2, resultEnvelopeEntities);

    final allEnvelopesQueryWithoutCache3 = Query.from<EnvelopeEntity>().withoutCache().all().withoutCache();
    final resultEnvelopeEntitiesWithoutCache3 = await AppContext.global.executeQuery(allEnvelopesQueryWithoutCache3);
    expect(resultEnvelopeEntitiesWithoutCache3, resultEnvelopeEntities);
  });

  test('where contains', () async {
    AppContext.global = AppContext()..register(LocalLuckyNumbersRepository());

    final firstFive = [1, 2, 3, 4, 5];
    final firstEvens = [2, 4, 6, 8, 10];
    final firstSquares = [1, 4, 9, 16, 25];

    final luckyNumbers = {
      firstFive,
      firstEvens,
      firstSquares,
    };

    await Future.wait(luckyNumbers
        .map((luckyNumbers) => LuckyNumbers()..luckyNumbersProperty.value = luckyNumbers)
        .map((luckyNumbers) => LuckyNumbersEntity()..value = luckyNumbers)
        .map((entity) => entity.create()));

    final containsOne = await AppContext.global.executeQuery(
      Query.from<LuckyNumbersEntity>().where('luckyNumbers', contains: 1).all(),
    );

    expect(
      containsOne.map((entity) => entity.value.luckyNumbersProperty.value).toList(),
      containsAll([firstFive, firstSquares]),
    );

    final containsTwo = await AppContext.global.executeQuery(
      Query.from<LuckyNumbersEntity>().where('luckyNumbers', contains: 2).all(),
    );

    expect(
      containsTwo.map((entity) => entity.value.luckyNumbersProperty.value).toList(),
      containsAll([firstFive, firstEvens]),
    );

    final containsZero = await AppContext.global.executeQuery(
      Query.from<LuckyNumbersEntity>().where('luckyNumbers', contains: 0).all(),
    );

    expect(
      containsZero.map((entity) => entity.value.luckyNumbersProperty.value).toList(),
      isEmpty,
    );
  });

  test('order by', () async {
    final amountUpQuery = Query.from<EnvelopeEntity>().orderByAscending(Envelope.amountField);
    expect(
      (await _getEnvelopesFromQuery(amountUpQuery)).map((envelope) => envelope.nameProperty.value).toList(),
      ['Car', 'House', 'Tithe', 'Investing'],
    );

    final amountDownQuery = Query.from<EnvelopeEntity>().orderByDescending(Envelope.amountField);
    expect(
      (await _getEnvelopesFromQuery(amountDownQuery)).map((envelope) => envelope.nameProperty.value).toList(),
      ['Investing', 'Tithe', 'Car', 'House'],
    );

    final timeUpQuery = Query.from<EnvelopeEntity>().orderByAscending(ValueObject.timeCreatedField);
    expect(
      (await _getEnvelopesFromQuery(timeUpQuery)).map((envelope) => envelope.nameProperty.value).toList(),
      ['House', 'Car', 'Investing', 'Tithe'],
    );

    final timeDownQuery = Query.from<EnvelopeEntity>().orderByDescending(ValueObject.timeCreatedField);
    expect(
      (await _getEnvelopesFromQuery(timeDownQuery)).map((envelope) => envelope.nameProperty.value).toList(),
      ['Tithe', 'Investing', 'Car', 'House'],
    );
  });

  test('greater than/less than', () async {
    final greaterThanEnvelopes =
        await _getEnvelopesFromQuery(Query.from<EnvelopeEntity>().where(Envelope.amountField, isGreaterThan: 0));
    expect(greaterThanEnvelopes, envelopes.where((envelope) => envelope.amountProperty.value! > 0).toList());

    final greaterThanOrEqualToEnvelopes = await _getEnvelopesFromQuery(
        Query.from<EnvelopeEntity>().where(Envelope.amountField, isGreaterThanOrEqualTo: 0));
    expect(greaterThanOrEqualToEnvelopes, envelopes.where((envelope) => envelope.amountProperty.value! >= 0).toList());

    final lessThanEnvelopes =
        await _getEnvelopesFromQuery(Query.from<EnvelopeEntity>().where(Envelope.amountField, isLessThan: 24 * 100));
    expect(lessThanEnvelopes, envelopes.where((envelope) => envelope.amountProperty.value! < 24 * 100).toList());

    final lessThanOrEqualToEnvelopes = await _getEnvelopesFromQuery(
        Query.from<EnvelopeEntity>().where(Envelope.amountField, isLessThanOrEqualTo: 24 * 100));
    expect(
        lessThanOrEqualToEnvelopes, envelopes.where((envelope) => envelope.amountProperty.value! <= 24 * 100).toList());

    final oneMinuteAgo = now.subtract(Duration(seconds: 1));
    final greaterThanDateEnvelopes = await _getEnvelopesFromQuery(
        Query.from<EnvelopeEntity>().where(ValueObject.timeCreatedField, isGreaterThan: oneMinuteAgo));
    expect(greaterThanDateEnvelopes,
        envelopes.where((envelope) => envelope.timeCreatedProperty.value!.isAfter(oneMinuteAgo)).toList());

    final greaterThanOrEqualToDateEnvelopes = await _getEnvelopesFromQuery(
        Query.from<EnvelopeEntity>().where(ValueObject.timeCreatedField, isGreaterThanOrEqualTo: oneMinuteAgo));
    expect(
        greaterThanOrEqualToDateEnvelopes,
        envelopes
            .where((envelope) =>
                envelope.timeCreatedProperty.value!.isAfter(oneMinuteAgo) ||
                envelope.timeCreatedProperty.value!.isAtSameMomentAs(oneMinuteAgo))
            .toList());

    final lessThanDateEnvelopes = await _getEnvelopesFromQuery(
        Query.from<EnvelopeEntity>().where(ValueObject.timeCreatedField, isLessThan: oneMinuteAgo));
    expect(lessThanDateEnvelopes,
        envelopes.where((envelope) => envelope.timeCreatedProperty.value!.isBefore(oneMinuteAgo)).toList());

    final lessThanOrEqualToDateEnvelopes = await _getEnvelopesFromQuery(
        Query.from<EnvelopeEntity>().where(ValueObject.timeCreatedField, isLessThanOrEqualTo: oneMinuteAgo));
    expect(
        lessThanOrEqualToDateEnvelopes,
        envelopes
            .where((envelope) =>
                envelope.timeCreatedProperty.value!.isBefore(oneMinuteAgo) ||
                envelope.timeCreatedProperty.value!.isAtSameMomentAs(oneMinuteAgo))
            .toList());
  });
}

Future<List<Envelope>> _getEnvelopesFromQuery(Query<EnvelopeEntity> query) async {
  final entities = await query.all().get();
  return entities.map((e) => e.value).toList();
}

Future<void> _populateRepositories() async {
  await Future.wait(envelopes.map((envelope) => (EnvelopeEntity()..value = envelope).create()));
  await Future.wait(budgets.map((budget) => (BudgetEntity()..value = budget).create()));
}

class LocalEnvelopeRepository extends DefaultLocalRepository<EnvelopeEntity, Envelope> {
  @override
  EnvelopeEntity createEntity() => EnvelopeEntity();

  @override
  Envelope createValueObject() => Envelope();
}

class LocalBudgetRepository extends DefaultLocalRepository<BudgetEntity, Budget> {
  @override
  BudgetEntity createEntity() => BudgetEntity();

  @override
  Budget createValueObject() => Budget();
}

class LocalBudgetTransactionRepository
    extends DefaultAbstractLocalRepository<BudgetTransactionEntity, BudgetTransaction> {
  @override
  List<ValueObjectRegistration> get valueObjectRegistrations => [
        ValueObjectRegistration<BudgetTransaction, BudgetTransaction?>.abstract(),
        ValueObjectRegistration<EnvelopeTransaction, EnvelopeTransaction?>(
          () => EnvelopeTransaction(),
          parents: {BudgetTransaction},
        ),
        ValueObjectRegistration<TransferTransaction, TransferTransaction?>(
          () => TransferTransaction(),
          parents: {BudgetTransaction},
        ),
      ];

  @override
  List<EntityRegistration> get entityRegistrations => [
        EntityRegistration<BudgetTransactionEntity, BudgetTransaction>.abstract(),
        EntityRegistration<EnvelopeTransactionEntity, EnvelopeTransaction>(() => EnvelopeTransactionEntity()),
        EntityRegistration<TransferTransactionEntity, TransferTransaction>(() => TransferTransactionEntity()),
      ];
}

class LocalLuckyNumbersRepository extends DefaultLocalRepository<LuckyNumbersEntity, LuckyNumbers> {
  @override
  LuckyNumbersEntity createEntity() {
    return LuckyNumbersEntity();
  }

  @override
  LuckyNumbers createValueObject() {
    return LuckyNumbers();
  }
}