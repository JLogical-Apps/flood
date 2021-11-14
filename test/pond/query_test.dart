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
    ..amountProperty.value = 240 * 100,
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
    database = Database(repositories: [envelopeRepository, budgetRepository]);

    _populateRepositories();
  });

  test('all from a type.', () async {
    final allEnvelopesQuery = Query.from<EnvelopeEntity>().all();
    final resultEntities = await database.executeQuery(allEnvelopesQuery);
    final resultValueObjects = resultEntities.map((envelopeEntity) => envelopeEntity.value).toList();
    expect(resultValueObjects, envelopes);
  });
}

void _populateRepositories() {
  envelopes.map((envelope) => EnvelopeEntity(initialEnvelope: envelope)).forEach(envelopeRepository.create);
  budgets.map((budget) => BudgetEntity(initialBudget: budget)).forEach(budgetRepository.create);
}

class LocalEnvelopeRepository = EntityRepository<EnvelopeEntity> with WithLocalEntityRepository, WithIdGenerator;

class LocalBudgetRepository = EntityRepository<BudgetEntity> with WithLocalEntityRepository, WithIdGenerator;
