import 'package:drop_core/drop_core.dart';
import 'package:pond_core/pond_core.dart';
import 'package:test/test.dart';
import 'package:type_core/type_core.dart';
import 'package:utils_core/utils_core.dart';

void main() {
  test('find right repository.', () {
    final corePondContext = CorePondContext()
      ..register(TypeCoreComponent())
      ..register(DropCoreComponent())
      ..register(UserRepository())
      ..register(BudgetRepository());

    final dropCoreComponent = corePondContext.locate<DropCoreComponent>();

    expect(dropCoreComponent.getRepositoryFor<UserEntity>(), isA<UserRepository>());
    expect(dropCoreComponent.getRepositoryFor<BudgetEntity>(), isA<BudgetRepository>());
    expect(dropCoreComponent.getRepositoryForTypeOrNull<BudgetTransactionEntity>(), isNull);
  });
}

class User extends ValueObject {}

class UserEntity extends Entity<User> {}

class UserRepository with IsRepositoryWrapper {
  @override
  final Repository repository = Repository.memory().forType<UserEntity, User>(UserEntity.new, User.new);
}

class Budget extends ValueObject {}

class BudgetEntity extends Entity<Budget> {}

class BudgetRepository with IsRepositoryWrapper {
  @override
  final Repository repository = Repository.memory().forType<BudgetEntity, Budget>(BudgetEntity.new, Budget.new);
}

abstract class BudgetTransaction extends ValueObject {}

abstract class BudgetTransactionEntity<B extends BudgetTransaction> extends Entity<B> {}

class BudgetTransactionRepository with IsRepositoryWrapper {
  @override
  Repository get repository => Repository.memory().forType<BudgetTransactionEntity, BudgetTransaction>(
      () => throw UnimplementedError(), () => throw UnimplementedError());
}
