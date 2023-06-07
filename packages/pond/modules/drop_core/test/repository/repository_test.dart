import 'package:actions_core/actions_core.dart';
import 'package:drop_core/drop_core.dart';
import 'package:pond_core/pond_core.dart';
import 'package:test/test.dart';
import 'package:type/type.dart';
import 'package:type_core/type_core.dart';
import 'package:utils_core/utils_core.dart';

void main() {
  test('find right repository.', () async {
    final corePondContext = CorePondContext();
    await corePondContext.register(TypeCoreComponent());
    await corePondContext.register(CoreDropComponent());
    await corePondContext.register(UserRepository());
    await corePondContext.register(BudgetRepository());

    final coreDropComponent = corePondContext.locate<CoreDropComponent>();

    expect(coreDropComponent.getRepositoryFor<UserEntity>(), isA<UserRepository>());
    expect(coreDropComponent.getRepositoryFor<BudgetEntity>(), isA<BudgetRepository>());
    expect(coreDropComponent.getRepositoryForTypeOrNull<BudgetTransactionEntity>(), isNull);

    await corePondContext.register(BudgetTransactionRepository());

    expect(coreDropComponent.getRepositoryFor<BudgetTransactionEntity>(), isA<BudgetTransactionRepository>());
    expect(coreDropComponent.getRepositoryFor<EnvelopeTransactionEntity>(), isA<BudgetTransactionRepository>());
  });

  test('creating, saving, and deleting from a repository.', () async {
    final memoryRepository = Repository.memory();
    final repository = memoryRepository.forType<UserEntity, User>(
      UserEntity.new,
      User.new,
      entityTypeName: 'UserEntity',
      valueObjectTypeName: 'User',
    );

    final context = CorePondContext();
    await context.register(TypeCoreComponent());
    await context.register(CoreDropComponent());
    await context.register(repository);

    expect(memoryRepository.stateByIdX.value, {});

    var state = State(
      type: context.coreDropComponent.getRuntimeType<UserEntity>(),
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

  test('throw on saving invalid ValueObject', () async {
    final memoryRepository = UserRepository();

    final context = CorePondContext();
    await context.register(TypeCoreComponent());
    await context.register(CoreDropComponent());
    await context.register(ActionCoreComponent());
    await context.register(memoryRepository);

    final userEntity = UserEntity()..set(User());

    expect(() => context.locate<CoreDropComponent>().updateEntity(userEntity), throwsA(isA<String>()));
    expect(
      () => context
          .locate<CoreDropComponent>()
          .updateEntity(userEntity, (User user) => user..nameProperty.set('John Doe')),
      returnsNormally,
    );
  });

  test('throw on invalid state in repository', () async {
    final memoryRepository = UserRepository();

    final context = CorePondContext();
    await context.register(TypeCoreComponent());
    await context.register(CoreDropComponent());
    await context.register(memoryRepository);

    var userState = State(
      type: context.locate<TypeCoreComponent>().getRuntimeType<UserEntity>(),
      data: {},
    );
    userState = await memoryRepository.update(userState);

    expect(() => memoryRepository.executeQuery(Query.from<UserEntity>().firstOrNull()), throwsA(isA<String>()));
    expect(() => memoryRepository.executeQuery(Query.from<UserEntity>().first()), throwsA(isA<String>()));
    expect(() async {
      final page = await memoryRepository.executeQuery(Query.from<UserEntity>().paginate());
      await page.getItems();
    }, throwsA(isA<String>()));
    expect(() => memoryRepository.executeQuery(Query.from<UserEntity>().all()), throwsA(isA<String>()));

    userState = userState.withData({'name': 'John Doe'});
    await memoryRepository.update(userState);

    final queriedEntity = await memoryRepository.executeQuery(Query.from<UserEntity>().firstOrNull());

    expect(queriedEntity?.getState(context.locate<CoreDropComponent>()), userState);
  });
}

class User extends ValueObject {
  late final nameProperty = field<String>(name: 'name').required();

  @override
  List<ValueObjectBehavior> get behaviors => [nameProperty];
}

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
