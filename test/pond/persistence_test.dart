import 'package:flutter_test/flutter_test.dart';
import 'package:jlogical_utils/src/pond/export.dart';
import 'package:jlogical_utils/src/pond/state/persistence/json_state_persister.dart';

import 'entities/budget_transaction.dart';
import 'entities/envelope_transaction.dart';

void main() {
  test('json', () {
    AppContext.global = AppContext.createForTesting()
      ..registerForTesting()
      ..register(SimpleAppModule(
        valueObjectRegistrations: [
          ValueObjectRegistration<BudgetTransaction, BudgetTransaction?>.abstract(),
          ValueObjectRegistration<EnvelopeTransaction, EnvelopeTransaction?>(
            () => EnvelopeTransaction(),
            parents: {BudgetTransaction},
          ),
          ValueObjectRegistration<BudgetTransactionWrapper, BudgetTransactionWrapper?>(
              () => BudgetTransactionWrapper()),
        ],
        entityRegistrations: [
          EntityRegistration<BudgetTransactionWrapperEntity, BudgetTransactionWrapper>(
              () => BudgetTransactionWrapperEntity()),
        ],
      ));

    final jsonPersister = JsonStatePersister();

    final envelopeTransaction = EnvelopeTransaction()
      ..nameProperty.value = 'Payment'
      ..amountProperty.value = 12 * 100;
    final budgetTransactionWrapper = BudgetTransactionWrapper()..budgetTransactionProperty.value = envelopeTransaction;
    final budgetTransactionWrapperEntity = BudgetTransactionWrapperEntity()..value = budgetTransactionWrapper;
    budgetTransactionWrapperEntity.id = 'id0';

    final json = '''\
{
  "transaction": {
    "_type": "$EnvelopeTransaction",
    "name": "Payment",
    "amount": 1200
  },
  "_id": "${budgetTransactionWrapperEntity.id}",
  "_type": "$BudgetTransactionWrapperEntity"
}''';

    expect(jsonPersister.persist(budgetTransactionWrapperEntity.state), json);

    final inflated = Entity.fromState(jsonPersister.inflate(json));
    expect(inflated, budgetTransactionWrapperEntity);
    expect(inflated.state, budgetTransactionWrapperEntity.state);
  });
}

class BudgetTransactionWrapper extends ValueObject {
  late final budgetTransactionProperty = FieldProperty<BudgetTransaction>(name: 'transaction');

  @override
  List<Property> get properties => [budgetTransactionProperty];
}

class BudgetTransactionWrapperEntity extends Entity<BudgetTransactionWrapper> {}
