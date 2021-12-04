import 'package:flutter_test/flutter_test.dart';
import 'package:jlogical_utils/src/pond/context/registration/database_app_registration.dart';
import 'package:jlogical_utils/src/pond/context/registration/registrations_provider.dart';
import 'package:jlogical_utils/src/pond/context/registration/with_domain_registrations_provider.dart';
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

void main() {
  setUp(() {
    AppContext.global = AppContext(
        registration: DatabaseAppRegistration(repositories: [LocalEnvelopeRepository(), LocalBudgetRepository()]));

    _populateRepositories();
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
}

void _populateRepositories() {
  envelopes
      .map((envelope) => EnvelopeEntity(initialEnvelope: envelope))
      .forEach((entity) => AppContext.global.create<EnvelopeEntity>(entity));
  budgets
      .map((budget) => BudgetEntity(initialBudget: budget))
      .forEach((entity) => AppContext.global.create<BudgetEntity>(entity));
}

class LocalEnvelopeRepository extends EntityRepository<EnvelopeEntity>
    with WithLocalEntityRepository, WithIdGenerator, WithDomainRegistrationsProvider<Envelope, EnvelopeEntity>
    implements RegistrationsProvider {
  @override
  EnvelopeEntity createEntity(Envelope initialValue) => EnvelopeEntity(initialEnvelope: initialValue);

  @override
  Envelope createValueObject() => Envelope();
}

class LocalBudgetRepository extends EntityRepository<BudgetEntity>
    with WithLocalEntityRepository, WithIdGenerator, WithDomainRegistrationsProvider<Budget, BudgetEntity>
    implements RegistrationsProvider {
  @override
  BudgetEntity createEntity(Budget initialValue) => BudgetEntity(initialBudget: initialValue);

  @override
  Budget createValueObject() => Budget();
}
