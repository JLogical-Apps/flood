import 'package:flutter_test/flutter_test.dart';
import 'package:jlogical_utils/jlogical_utils.dart';
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
      registration: ExplicitAppRegistration(
        entityRegistrations: [
          EntityRegistration<BudgetEntity, Budget>((value) => BudgetEntity(initialBudget: value)),
          EntityRegistration<UserEntity, User>((value) => UserEntity(initialUser: value)),
        ],
        valueObjectRegistrations: [
          ValueObjectRegistration<Budget, Budget?>(() => Budget()),
          ValueObjectRegistration<User, User?>(() => User()),
        ],
        database: EntityDatabase(
          repositories: [
            LocalUserRepository(),
            LocalBudgetRepository(),
          ],
        ),
      ),
    );

    final ownerEntity = UserEntity(initialUser: User()..nameProperty.value = 'Jake');
    await AppContext.global.getRepository<UserEntity>().create(ownerEntity);
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

class LocalUserRepository = EntityRepository<UserEntity> with WithLocalEntityRepository, WithIdGenerator;

class LocalBudgetRepository = EntityRepository<BudgetEntity> with WithLocalEntityRepository, WithIdGenerator;
