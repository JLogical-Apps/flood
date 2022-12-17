import 'package:drop_core/drop_core.dart';
import 'package:pond_core/pond_core.dart';
import 'package:test/test.dart';
import 'package:type_core/type_core.dart';
import 'package:utils_core/utils_core.dart';

void main() {
  test('find right repository.', () async {
    final corePondContext = CorePondContext();
    await corePondContext.register(TypeCoreComponent());
    await corePondContext.register(DropCoreComponent());
    await corePondContext.register(UserRepository());
    await corePondContext.register(BudgetRepository());

    final dropCoreComponent = corePondContext.locate<DropCoreComponent>();

    expect(dropCoreComponent.getRepositoryFor<UserEntity>(), isA<UserRepository>());
    expect(dropCoreComponent.getRepositoryFor<BudgetEntity>(), isA<BudgetRepository>());
    expect(dropCoreComponent.getRepositoryForTypeOrNull<BudgetTransactionEntity>(), isNull);

    await corePondContext.register(BudgetTransactionRepository());

    expect(dropCoreComponent.getRepositoryFor<BudgetTransactionEntity>(), isA<BudgetTransactionRepository>());
    expect(dropCoreComponent.getRepositoryFor<EnvelopeTransactionEntity>(), isA<BudgetTransactionRepository>());
  });

  test('creating, saving, and deleting from a repository.', () async {
    final memoryRepository = Repository.memory();

    final context = CorePondContext();
    await context.register(TypeCoreComponent());
    await context.register(DropCoreComponent());
    await context.register(memoryRepository);

    expect(memoryRepository.stateByIdX.value, {});

    var state = State(
      data: {'field': 'value'},
    );

    expect(state.isNew, true);

    state = await memoryRepository.update(state);

    expect(state.isNew, false);
    expect(memoryRepository.stateByIdX.value, {state.id: state});

    state = state.withData({'newField': 'newValue'});

    state = await memoryRepository.update(state);

    expect(memoryRepository.stateByIdX.value, {state.id: state});

    await memoryRepository.delete(state);

    expect(memoryRepository.stateByIdX.value, {});
  });
}

class User extends ValueObject {}

class UserEntity extends Entity<User> {}

class UserRepository with IsRepositoryWrapper {
  @override
  final Repository repository = Repository.memory().forType<UserEntity, User>(
    UserEntity.new,
    User.new,
    entityTypeName: 'UserEntity',
    valueObjectTypeName: 'User',
  );
}

class Budget extends ValueObject {}

class BudgetEntity extends Entity<Budget> {}

class BudgetRepository with IsRepositoryWrapper {
  @override
  final Repository repository = Repository.memory().forType<BudgetEntity, Budget>(
    BudgetEntity.new,
    Budget.new,
    entityTypeName: 'BudgetEntity',
    valueObjectTypeName: 'Budget',
  );
}

abstract class BudgetTransaction extends ValueObject {}

abstract class BudgetTransactionEntity<B extends BudgetTransaction> extends Entity<B> {}

class EnvelopeTransaction extends BudgetTransaction {}

class EnvelopeTransactionEntity extends BudgetTransactionEntity<EnvelopeTransaction> {}

class BudgetTransactionRepository with IsRepositoryWrapper {
  @override
  final Repository repository = Repository.memory()
      .forAbstractType<BudgetTransactionEntity, BudgetTransaction>(
        entityTypeName: 'BudgetTransactionEntity',
        valueObjectTypeName: 'BudgetTransaction',
      )
      .withImplementation<EnvelopeTransactionEntity, EnvelopeTransaction>(
        EnvelopeTransactionEntity.new,
        EnvelopeTransaction.new,
        entityTypeName: 'EnvelopeTransactionEntity',
        valueObjectTypeName: 'EnvelopeTransaction',
      );
}
