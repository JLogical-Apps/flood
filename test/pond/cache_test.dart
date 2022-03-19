import 'package:flutter_test/flutter_test.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

void main() {
  test('use cache if same query called twice.', () async {
    int withoutCacheQueriesExecuted = 0;
    AppContext.global = AppContext.createForTesting()
      ..register(UserRepository(whenWithoutCacheQueryExecuted: () => withoutCacheQueriesExecuted++));

    final userEntities = [
      UserEntity()..value = (User()..emailProperty.value = 'a@a.com'),
      UserEntity()..value = (User()..emailProperty.value = 'b@b.com'),
    ];
    await Future.wait(userEntities.map((user) => user.create()));

    await Query.from<UserEntity>().where('email', isEqualTo: 'a@a.com').all().get();
    await Query.from<UserEntity>().where('email', isEqualTo: 'a@a.com').all().get();

    expect(withoutCacheQueriesExecuted, 1);
  });

  test('do not use cache if query is slightly different', () async {
    int withoutCacheQueriesExecuted = 0;
    AppContext.global = AppContext.createForTesting()
      ..register(UserRepository(whenWithoutCacheQueryExecuted: () => withoutCacheQueriesExecuted++));

    final userEntities = [
      UserEntity()..value = (User()..emailProperty.value = 'a@a.com'),
      UserEntity()..value = (User()..emailProperty.value = 'b@b.com'),
    ];
    await Future.wait(userEntities.map((user) => user.create()));

    await Query.from<UserEntity>().where('email', isEqualTo: 'a@a.com').all().get();
    await Query.from<UserEntity>().where('email', isEqualTo: 'b@b.com').all().get();
    await Query.from<UserEntity>().where('email', isEqualTo: 'a@a.com').all().get(); // Ensure this is still cached.

    expect(withoutCacheQueriesExecuted, 2);
  });

  test('use cache if a super-query was already executed.', () async {
    late int withoutCacheQueriesExecuted;
    Future<void> reset() async {
      withoutCacheQueriesExecuted = 0;
      AppContext.global = AppContext.createForTesting()
        ..register(UserRepository(whenWithoutCacheQueryExecuted: () => withoutCacheQueriesExecuted++));

      final userEntities = [
        UserEntity()..value = (User()..emailProperty.value = 'a@a.com'),
        UserEntity()..value = (User()..emailProperty.value = 'b@b.com'),
      ];
      await Future.wait(userEntities.map((user) => user.create()));
    }

    await reset();
    await Query.from<UserEntity>().all().get();
    await Query.from<UserEntity>()
        .where('email', isEqualTo: 'a@a.com')
        .all()
        .get(); // Since .where is a subset of .all, use cache.
    expect(withoutCacheQueriesExecuted, 1);

    await reset();
    await Query.from<UserEntity>().all().get();
    await Query.from<UserEntity>().firstOrNull().get(); // Since .firstOrNull is a subset of .all, use cache.
    expect(withoutCacheQueriesExecuted, 1);

    await reset();
    await Query.from<UserEntity>().where('email', isEqualTo: 'a@a.com').all().get();
    await Query.from<UserEntity>()
        .where('email', isEqualTo: 'a@a.com')
        .firstOrNull()
        .get(); // Since .firstOrNull is a subset of .all, use cache.
    expect(withoutCacheQueriesExecuted, 1);

    await reset();
    await Query.from<UserEntity>().where('email', isEqualTo: 'a@a.com').all().get();
    await Query.from<UserEntity>().all().get(); // Do not use cache since all is greater in scope than .where
    expect(withoutCacheQueriesExecuted, 2);

    await reset();
    await Query.from<UserEntity>().firstOrNull().get();
    await Query.from<UserEntity>().all().get(); // Do not use cache since all is greater in scope than .firstOrNull
    expect(withoutCacheQueriesExecuted, 2);

    await reset();
    await Query.from<UserEntity>().where('email', isEqualTo: 'a@a.com').firstOrNull().get();
    await Query.from<UserEntity>()
        .where('email', isEqualTo: 'a@a.com')
        .all()
        .get(); // Do not use cache since all is greater in scope than .firstOrNull
    expect(withoutCacheQueriesExecuted, 2);

    // Some edge cases.

    await reset();
    await Query.from<UserEntity>().all().get();
    await Query.from<UserEntity>().orderByAscending('email').firstOrNull().get();
    expect(withoutCacheQueriesExecuted, 1);

    await reset();
    await Query.from<UserEntity>().firstOrNull().get();
    await Query.from<UserEntity>()
        .orderByAscending('email')
        .firstOrNull()
        .get(); // Do not use cache since the first one may be different depending on ordering.
    expect(withoutCacheQueriesExecuted, 2);

    await reset();
    final results = await Query.from<UserEntity>().all().get();
    await Query.getById<UserEntity>(results[0].id!).get();
    expect(withoutCacheQueriesExecuted, 1);

    await reset();
    final paginationResults = await Query.from<UserEntity>().paginate().get();
    await Query.getById<UserEntity>(paginationResults.results[0].id!).get();
    expect(withoutCacheQueriesExecuted, 1);

    await reset();
    await Query.from<UserEntity>().paginate().get();
    await Query.getById<UserEntity>('some random id that will never work').get();
    expect(withoutCacheQueriesExecuted, 2);
  });
}

class User extends ValueObject {
  late final emailProperty = FieldProperty<String>(name: 'email');

  @override
  List<Property> get properties => super.properties + [emailProperty];
}

class UserEntity extends Entity<User> {}

class UserRepository extends DefaultLocalRepository<UserEntity, User> {
  final void Function() whenWithoutCacheQueryExecuted;

  UserRepository({required this.whenWithoutCacheQueryExecuted});

  @override
  UserEntity createEntity() {
    return UserEntity();
  }

  @override
  User createValueObject() {
    return User();
  }

  @override
  Future<void> onWithoutCacheQueryExecuted(QueryRequest queryRequest) async {
    whenWithoutCacheQueryExecuted.call();
  }
}
