import 'package:flutter_test/flutter_test.dart';
import 'package:jlogical_utils/src/model/future_value.dart';
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
import 'entities/transfer_transaction.dart';
import 'entities/transfer_transaction_entity.dart';

late List<Envelope> envelopes = [
  Envelope()
    ..nameProperty.value = 'Tithe'
    ..amountProperty.value = 24 * 100,
  Envelope()
    ..nameProperty.value = 'Investing'
    ..amountProperty.value = 81 * 100,
  Envelope()
    ..nameProperty.value = 'Car'
    ..amountProperty.value = 0,
  Envelope()
    ..nameProperty.value = 'House'
    ..amountProperty.value = 0,
];

List<Budget> budgets = [
  Budget()
    ..nameProperty.value = 'Budget A'
    ..ownerProperty.value = 'Jake',
];

void main() {
  setUp(() async {
    AppContext.global = AppContext(
      registration: DatabaseAppRegistration(
        repositories: [
          LocalEnvelopeRepository(),
          LocalBudgetRepository(),
        ],
      ),
    );

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
    final emptyEnvelopesQuery = Query.from<EnvelopeEntity>().where(Envelope.amountPropertyName, isEqualTo: 0).all();
    final resultEnvelopeEntities = await AppContext.global.executeQuery(emptyEnvelopesQuery);
    final resultEnvelopeValueObjects = resultEnvelopeEntities.map((envelopeEntity) => envelopeEntity.value).toList();
    expect(resultEnvelopeValueObjects, envelopes.where((envelope) => envelope.amountProperty.value == 0).toList());
  });

  test('as stream', () async {
    final emptyEnvelopesQuery = Query.from<EnvelopeEntity>().where(Envelope.amountPropertyName, isEqualTo: 0).all();
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
    AppContext.global = AppContext(
      registration: ExplicitAppRegistration(
          valueObjectRegistrations: [
            ValueObjectRegistration<BudgetTransaction, BudgetTransaction?>.abstract(),
            ValueObjectRegistration<EnvelopeTransaction, EnvelopeTransaction?>(
              () => EnvelopeTransaction(),
              parents: {BudgetTransaction},
            ),
            ValueObjectRegistration<TransferTransaction, TransferTransaction?>(
              () => TransferTransaction(),
              parents: {BudgetTransaction},
            ),
          ],
          entityRegistrations: [
            EntityRegistration<BudgetTransactionEntity, BudgetTransaction>.abstract(),
            EntityRegistration<EnvelopeTransactionEntity, EnvelopeTransaction>(() => EnvelopeTransactionEntity()),
            EntityRegistration<TransferTransactionEntity, TransferTransaction>(
              () => TransferTransactionEntity(),
            ),
          ],
          database: EntityDatabase(
            repositories: [
              LocalBudgetTransactionRepository(),
            ],
          )),
    );

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

class LocalBudgetTransactionRepository = EntityRepository
    with
        WithMonoEntityRepository<BudgetTransactionEntity>,
        WithLocalEntityRepository,
        WithIdGenerator,
        WithTransactionsAndCacheEntityRepository;
