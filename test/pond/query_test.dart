import 'package:flutter_test/flutter_test.dart';
import 'package:jlogical_utils/src/pond/export.dart';

import 'entities/budget.dart';
import 'entities/budget_entity.dart';
import 'entities/envelope.dart';
import 'entities/envelope_entity.dart';

List<Envelope> envelopes = [
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

late LocalEnvelopeRepository envelopeRepository;
late LocalBudgetRepository budgetRepository;
late Database database;

void main() {
  setUp(() {
    envelopeRepository = LocalEnvelopeRepository();
    budgetRepository = LocalBudgetRepository();
    database = EntityDatabase(repositories: [envelopeRepository, budgetRepository]);

    _populateRepositories();
  });

  test('all from a type.', () async {
    AppContext.global = AppContext(
      registration: ExplicitAppRegistration(
        entityRegistrations: [
          EntityRegistration<EnvelopeEntity, Envelope>((envelope) => EnvelopeEntity(initialEnvelope: envelope)),
          EntityRegistration<BudgetEntity, Budget>((budget) => BudgetEntity(initialBudget: budget)),
        ],
        valueObjectRegistrations: [
          ValueObjectRegistration<Envelope, Envelope?>(() => Envelope()),
          ValueObjectRegistration<Budget, Budget?>(() => Budget()),
        ],
      ),
    );

    final allEnvelopesQuery = Query.from<EnvelopeEntity>().all();
    final resultEnvelopeEntities = await database.executeQuery(allEnvelopesQuery);
    final resultEnvelopeValueObjects = resultEnvelopeEntities.map((envelopeEntity) => envelopeEntity.value).toList();
    expect(resultEnvelopeValueObjects, envelopes);

    final allBudgetsQuery = Query.from<BudgetEntity>().all();
    final resultBudgetEntities = await database.executeQuery(allBudgetsQuery);
    final resultBudgetValueObjects = resultBudgetEntities.map((budgetEntity) => budgetEntity.value).toList();
    expect(resultBudgetValueObjects, budgets);
  });

  test('with condition', () async {
    final emptyEnvelopesQuery = Query.from<EnvelopeEntity>().where(Envelope.amountPropertyName, isEqualTo: 0).all();
    final resultEnvelopeEntities = await database.executeQuery(emptyEnvelopesQuery);
    final resultEnvelopeValueObjects = resultEnvelopeEntities.map((envelopeEntity) => envelopeEntity.value).toList();
    expect(resultEnvelopeValueObjects, envelopes.where((envelope) => envelope.amountProperty.value == 0).toList());
  });
}

void _populateRepositories() {
  envelopes.map((envelope) => EnvelopeEntity(initialEnvelope: envelope)).forEach(envelopeRepository.create);
  budgets.map((budget) => BudgetEntity(initialBudget: budget)).forEach(budgetRepository.create);
}

class LocalEnvelopeRepository = EntityRepository<EnvelopeEntity> with WithLocalEntityRepository, WithIdGenerator;

class LocalBudgetRepository = EntityRepository<BudgetEntity> with WithLocalEntityRepository, WithIdGenerator;
