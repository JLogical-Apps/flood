import 'package:flutter_test/flutter_test.dart';
import 'package:jlogical_utils/src/pond/context/app_context.dart';
import 'package:jlogical_utils/src/pond/context/registration/database_app_registration.dart';
import 'package:jlogical_utils/src/pond/repository/local/default_local_repository.dart';

import 'entities/budget.dart';
import 'entities/budget_aggregate.dart';
import 'entities/budget_entity.dart';
import 'entities/user.dart';
import 'entities/user_entity.dart';

void main() {
  test('resolving aggregate.', () async {
    AppContext.global = AppContext(
      registration: DatabaseAppRegistration(repositories: [
        LocalUserRepository(),
        LocalBudgetRepository(),
      ]),
    );

    final ownerEntity = UserEntity()..value = (User()..nameProperty.value = 'Jake');
    await ownerEntity.create();
    final ownerId = ownerEntity.id;

    final budgetAggregate = BudgetAggregate()
      ..entity = (BudgetEntity()
        ..value = (Budget()
          ..nameProperty.value = 'Budget'
          ..ownerProperty.value = ownerId));
    await budgetAggregate.resolve();

    final ownerReference = budgetAggregate.entity.value.ownerProperty.reference;

    expect(ownerReference, equals(ownerEntity));
    expect(ownerReference!.state, equals(ownerEntity.state));
  });
}

class LocalUserRepository extends DefaultLocalRepository<UserEntity, User> {
  @override
  UserEntity createEntity() => UserEntity();

  @override
  User createValueObject() => User();
}

class LocalBudgetRepository extends DefaultLocalRepository<BudgetEntity, Budget> {
  @override
  BudgetEntity createEntity() => BudgetEntity();

  @override
  Budget createValueObject() => Budget();
}
