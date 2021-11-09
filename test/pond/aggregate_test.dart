import 'package:flutter_test/flutter_test.dart';
import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:jlogical_utils/src/pond/database/database.dart';
import 'package:jlogical_utils/src/pond/repository/entity_repository.dart';
import 'package:jlogical_utils/src/pond/repository/with_id_generator.dart';
import 'package:jlogical_utils/src/pond/repository/with_local_record_repository.dart';

import 'entities/budget.dart';
import 'entities/budget_aggregate.dart';
import 'entities/budget_entity.dart';
import 'entities/user.dart';
import 'entities/user_entity.dart';

void main() {
  test('resolving aggregate.', () async {
    final database = Database(
      repositories: [
        LocalUserRepository(),
        LocalBudgetRepository(),
      ],
    );

    AppContext.global = AppContext(
      database: database,
      entityRegistrations: [
        EntityRegistration<Budget, BudgetEntity>((value) => BudgetEntity(initialBudget: value)),
        EntityRegistration<User, UserEntity>((value) => UserEntity(initialUser: value)),
      ],
    );

    final ownerEntity = UserEntity(initialUser: User()..nameProperty.value = 'Jake')..id = 'jake';
    await database.getRepository<UserEntity>().save(ownerEntity);

    final budgetAggregate = BudgetAggregate(
        budgetEntity: BudgetEntity(
            initialBudget: Budget()
              ..nameProperty.value = 'Budget'
              ..ownerProperty.value = 'jake'));
    await budgetAggregate.resolve();

    final ownerReference = budgetAggregate.entity.value.ownerProperty.reference;

    expect(ownerReference, equals(ownerEntity));
    expect(ownerReference!.state, equals(ownerEntity.state));
  });
}

class LocalUserRepository = EntityRepository<UserEntity> with WithLocalEntityRepository, WithIdGenerator;

class LocalBudgetRepository = EntityRepository<BudgetEntity> with WithLocalEntityRepository, WithIdGenerator;
