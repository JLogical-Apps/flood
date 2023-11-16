import 'package:actions_core/actions_core.dart';
import 'package:drop_core/drop_core.dart';
import 'package:pond_core/pond_core.dart';
import 'package:test/test.dart';
import 'package:runtime_type/type.dart';
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
    final repository = Repository.forType<UserEntity, User>(
      UserEntity.new,
      User.new,
      entityTypeName: 'UserEntity',
      valueObjectTypeName: 'User',
    ).memory();

    final context = CorePondContext();
    await context.register(TypeCoreComponent());
    await context.register(DropCoreComponent());
    await context.register(repository);

    expect(repository.stateByIdX.value, {});

    var state = State(
      type: context.dropCoreComponent.getRuntimeType<UserEntity>(),
      data: {'field': 'value'},
    );

    expect(state.isNew, true);

    state = await repository.update(state);

    expect(state.isNew, false);
    expect(repository.stateByIdX.value, {state.id: state});

    state = state.withData({'newField': 'newValue'});

    state = await repository.update(state);

    expect(repository.stateByIdX.value, {state.id: state});

    await repository.delete(state);

    expect(repository.stateByIdX.value, {});
  });

  test('throw on saving invalid ValueObject', () async {
    final memoryRepository = UserRepository();

    final context = CorePondContext();
    await context.register(TypeCoreComponent());
    await context.register(DropCoreComponent());
    await context.register(ActionCoreComponent());
    await context.register(memoryRepository);

    final userEntity = UserEntity()..set(User());

    expect(() => context.locate<DropCoreComponent>().updateEntity(userEntity), throwsA(isA<String>()));
    expect(
      () => context
          .locate<DropCoreComponent>()
          .updateEntity(userEntity, (User user) => user..nameProperty.set('John Doe')),
      returnsNormally,
    );
  });

  test('throw on invalid state in repository', () async {
    final memoryRepository = UserRepository();

    final context = CorePondContext();
    await context.register(TypeCoreComponent());
    await context.register(DropCoreComponent());
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

    expect(queriedEntity?.getState(context.locate<DropCoreComponent>()), userState);
  });

  test('executing query with state listener works.', () async {
    final states = <State>[];
    final memoryRepository = UserRepository().withListener(onStateRetrieved: (state) {
      states.add(state);
    });

    final context = CorePondContext();
    await context.register(TypeCoreComponent());
    await context.register(DropCoreComponent());
    await context.register(memoryRepository);

    final userEntity = UserEntity()..set(User()..nameProperty.set('John Doe'));
    final userState = await memoryRepository.update(userEntity);

    await memoryRepository.executeQuery(Query.from<UserEntity>().firstOrNull());
    expect(states, contains(userState));
    states.clear();

    await memoryRepository.executeQuery(Query.from<UserEntity>().all());
    expect(states, contains(userState));
    states.clear();

    await memoryRepository.executeQuery(Query.from<UserEntity>().paginate());
    expect(states, contains(userState));
    states.clear();
  });

  test('executing paginated query with state listener works.', () async {
    final states = <State>[];
    final memoryRepository = UserRepository().withListener(onStateRetrieved: (state) {
      states.add(state);
    });

    final context = CorePondContext();
    await context.register(TypeCoreComponent());
    await context.register(DropCoreComponent());
    await context.register(memoryRepository);

    final names = [
      'John Doe',
      'Jill Doe',
      'Jane Doe',
    ];
    for (final name in names) {
      final userEntity = UserEntity()..set(User()..nameProperty.set(name));
      await memoryRepository.update(userEntity);
    }

    await memoryRepository.executeQuery(Query.from<UserEntity>().firstOrNull());
    expect(states.length, 1);
    states.clear();

    await memoryRepository.executeQuery(Query.from<UserEntity>().all());
    expect(states.length, names.length);
    states.clear();

    final pageResult = await memoryRepository.executeQuery(Query.from<UserEntity>().paginate(pageSize: 2));
    expect(states.length, 2);
    await pageResult.loadNextPage();
    expect(states.length, 3);
    states.clear();
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
  final Repository repository = Repository.forType<UserEntity, User>(
    UserEntity.new,
    User.new,
    entityTypeName: 'UserEntity',
    valueObjectTypeName: 'User',
  ).memory();
}

class Budget extends ValueObject {}

class BudgetEntity extends Entity<Budget> {}

class BudgetRepository with IsRepositoryWrapper {
  @override
  final Repository repository = Repository.forType<BudgetEntity, Budget>(
    BudgetEntity.new,
    Budget.new,
    entityTypeName: 'BudgetEntity',
    valueObjectTypeName: 'Budget',
  ).memory();
}

abstract class BudgetTransaction extends ValueObject {}

abstract class BudgetTransactionEntity<B extends BudgetTransaction> extends Entity<B> {}

class EnvelopeTransaction extends BudgetTransaction {}

class EnvelopeTransactionEntity extends BudgetTransactionEntity<EnvelopeTransaction> {}

class BudgetTransactionRepository with IsRepositoryWrapper {
  @override
  final Repository repository = Repository.forAbstractType<BudgetTransactionEntity, BudgetTransaction>(
    entityTypeName: 'BudgetTransactionEntity',
    valueObjectTypeName: 'BudgetTransaction',
  )
      .withImplementation<EnvelopeTransactionEntity, EnvelopeTransaction>(
        EnvelopeTransactionEntity.new,
        EnvelopeTransaction.new,
        entityTypeName: 'EnvelopeTransactionEntity',
        valueObjectTypeName: 'EnvelopeTransaction',
      )
      .memory();
}
