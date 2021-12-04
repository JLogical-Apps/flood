import 'package:flutter_test/flutter_test.dart';
import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:jlogical_utils/src/pond/context/registration/database_app_registration.dart';
import 'package:jlogical_utils/src/pond/context/registration/registrations_provider.dart';
import 'package:jlogical_utils/src/pond/context/registration/with_domain_registrations_provider.dart';
import 'package:jlogical_utils/src/pond/database/database.dart';
import 'package:jlogical_utils/src/pond/repository/entity_repository.dart';
import 'package:jlogical_utils/src/pond/repository/local/with_local_entity_repository.dart';
import 'package:jlogical_utils/src/pond/repository/with_id_generator.dart';

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

    final ownerEntity = UserEntity(initialUser: User()..nameProperty.value = 'Jake');
    await AppContext.global.create<UserEntity>(ownerEntity);
    final ownerId = ownerEntity.id;

    final budgetAggregate = BudgetAggregate(
        budgetEntity: BudgetEntity(
            initialBudget: Budget()
              ..nameProperty.value = 'Budget'
              ..ownerProperty.value = ownerId));
    await budgetAggregate.resolve();

    final ownerReference = budgetAggregate.entity.value.ownerProperty.reference;

    expect(ownerReference, equals(ownerEntity));
    expect(ownerReference!.state, equals(ownerEntity.state));
  });
}

class LocalUserRepository extends EntityRepository<UserEntity>
    with WithLocalEntityRepository, WithIdGenerator, WithDomainRegistrationsProvider<User, UserEntity>
    implements RegistrationsProvider {
  @override
  UserEntity createEntity(User initialValue) => UserEntity(initialUser: initialValue);

  @override
  User createValueObject() => User();
}

class LocalBudgetRepository extends EntityRepository<BudgetEntity>
    with WithLocalEntityRepository, WithIdGenerator, WithDomainRegistrationsProvider<Budget, BudgetEntity>
    implements RegistrationsProvider {
  @override
  BudgetEntity createEntity(Budget initialValue) => BudgetEntity(initialBudget: initialValue);

  @override
  Budget createValueObject() => Budget();
}
