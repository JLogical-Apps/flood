import 'package:drop_core/drop_core.dart';
import 'package:pond_core/pond_core.dart';
import 'package:test/test.dart';
import 'package:type_core/type_core.dart';
import 'package:utils_core/utils_core.dart';

void main() {
  test('query all', () async {
    final repository = Repository.memory().forType<UserEntity, User>(
      UserEntity.new,
      User.new,
      entityTypeName: 'UserEntity',
      valueObjectTypeName: 'User',
    );

    final users = [
      User()
        ..nameProperty.value = 'Jake'
        ..emailProperty.value = 'jake@jake.com',
      User()
        ..nameProperty.value = 'John'
        ..emailProperty.value = 'john@doe.com',
    ];

    final context = CorePondContext()
      ..register(TypeCoreComponent())
      ..register(DropCoreComponent())
      ..register(repository);

    for (final user in users) {
      await repository.update(UserEntity()..value = user);
    }

    final allUserEntities = await repository.executeQuery(Query.from<UserEntity>().all<UserEntity>());
    expect(allUserEntities.map((entity) => entity.value).toList(), users);

    final allUserStates = await repository.executeQuery(Query.from<UserEntity>().allStates());
    expect(allUserStates.map((state) => state.data),
        users.map((user) => user.getState(context.locate<DropCoreComponent>()).data).toList());
  });

  test('query first', () async {
    final repository = Repository.memory().forType<UserEntity, User>(
      UserEntity.new,
      User.new,
      entityTypeName: 'UserEntity',
      valueObjectTypeName: 'User',
    );

    final users = [
      User()
        ..nameProperty.value = 'Jake'
        ..emailProperty.value = 'jake@jake.com',
      User()
        ..nameProperty.value = 'John'
        ..emailProperty.value = 'john@doe.com',
    ];

    final context = CorePondContext()
      ..register(TypeCoreComponent())
      ..register(DropCoreComponent())
      ..register(repository);

    for (final user in users) {
      await repository.update(UserEntity()..value = user);
    }

    final firstUserEntity = await repository.executeQuery(Query.from<UserEntity>().firstOrNull<UserEntity>());
    expect(firstUserEntity?.value, users[0]);

    final firstUserEntityState = await repository.executeQuery(Query.from<UserEntity>().firstOrNullState());
    expect(firstUserEntityState?.data, users[0].getState(context.locate<DropCoreComponent>()).data);
  });

  test('query where equals', () async {
    final repository = Repository.memory().forType<UserEntity, User>(
      UserEntity.new,
      User.new,
      entityTypeName: 'UserEntity',
      valueObjectTypeName: 'User',
    );

    final users = [
      User()
        ..nameProperty.value = 'Jake'
        ..emailProperty.value = 'jake@jake.com',
      User()
        ..nameProperty.value = 'John'
        ..emailProperty.value = 'john@doe.com',
    ];

    CorePondContext()
      ..register(TypeCoreComponent())
      ..register(DropCoreComponent())
      ..register(repository);

    for (final user in users) {
      await repository.update(UserEntity()..value = user);
    }

    final johnUserEntity = await repository
        .executeQuery(Query.from<UserEntity>().where('name').isEqualTo('John').firstOrNull<UserEntity>());
    expect(johnUserEntity?.value, users[1]);
  });

  test('query where numeric', () async {
    final repository = Repository.memory().forType<InvoiceEntity, Invoice>(
      InvoiceEntity.new,
      Invoice.new,
      entityTypeName: 'InvoiceEntity',
      valueObjectTypeName: 'Invoice',
    );

    final invoices = [
      Invoice()..amountProperty.set(0),
      Invoice()..amountProperty.set(10),
      Invoice()..amountProperty.set(20),
      Invoice()..amountProperty.set(50),
      Invoice()..amountProperty.set(100),
      Invoice()..amountProperty.set(-10),
      Invoice()..amountProperty.set(null),
    ];

    CorePondContext()
      ..register(TypeCoreComponent())
      ..register(DropCoreComponent())
      ..register(repository);

    for (final invoice in invoices) {
      await repository.update(InvoiceEntity()..value = invoice);
    }

    final zeroInvoiceEntities = await repository
        .executeQuery(Query.from<InvoiceEntity>().where(Invoice.amountField).isEqualTo(0).all<InvoiceEntity>());
    expect(
      zeroInvoiceEntities.map((e) => e.value).toList(),
      invoices.where((i) => i.amountProperty.value == 0).toList(),
    );

    final positiveInvoiceEntities = await repository
        .executeQuery(Query.from<InvoiceEntity>().where(Invoice.amountField).isGreaterThan(0).all<InvoiceEntity>());
    expect(
      positiveInvoiceEntities.map((e) => e.value).toList(),
      invoices.where((i) => i.amountProperty.value != null && i.amountProperty.value! > 0).toList(),
    );

    final nonNegativeInvoiceEntities = await repository.executeQuery(
        Query.from<InvoiceEntity>().where(Invoice.amountField).isGreaterThanOrEqualTo(0).all<InvoiceEntity>());
    expect(
      nonNegativeInvoiceEntities.map((e) => e.value).toList(),
      invoices.where((i) => i.amountProperty.value != null && i.amountProperty.value! >= 0).toList(),
    );

    final negativeInvoiceEntities = await repository
        .executeQuery(Query.from<InvoiceEntity>().where(Invoice.amountField).isLessThan(0).all<InvoiceEntity>());
    expect(
      negativeInvoiceEntities.map((e) => e.value).toList(),
      invoices.where((i) => i.amountProperty.value != null && i.amountProperty.value! < 0).toList(),
    );

    final nonPositiveInvoiceEntities = await repository.executeQuery(
        Query.from<InvoiceEntity>().where(Invoice.amountField).isLessThanOrEqualTo(0).all<InvoiceEntity>());
    expect(
      nonPositiveInvoiceEntities.map((e) => e.value).toList(),
      invoices.where((i) => i.amountProperty.value != null && i.amountProperty.value! <= 0).toList(),
    );
  });

  test('query all map', () async {
    final repository = Repository.memory().forType<UserEntity, User>(
      UserEntity.new,
      User.new,
      entityTypeName: 'UserEntity',
      valueObjectTypeName: 'User',
    );

    final users = [
      User()
        ..nameProperty.value = 'Jake'
        ..emailProperty.value = 'jake@jake.com',
      User()
        ..nameProperty.value = 'John'
        ..emailProperty.value = 'john@doe.com',
    ];

    CorePondContext()
      ..register(TypeCoreComponent())
      ..register(DropCoreComponent())
      ..register(repository);

    for (final user in users) {
      await repository.update(UserEntity()..value = user);
    }

    final allUserNames = await repository.executeQuery(Query.from<UserEntity>()
        .all<UserEntity>()
        .map((context, entities) => entities.map((entity) => entity.value.nameProperty.value).toList()));
    expect(allUserNames, users.map((user) => user.nameProperty.value).toList());

    final allUserEmails = await repository.executeQuery(
        Query.from<UserEntity>().allStates().map((context, states) => states.map((state) => state['email']).toList()));
    expect(allUserEmails, users.map((user) => user.emailProperty.value).toList());
  });
}

class User extends ValueObject {
  late final nameProperty = field<String>(name: 'name');
  late final emailProperty = field<String>(name: 'email');

  @override
  List<ValueObjectBehavior> get behaviors => [nameProperty, emailProperty];
}

class UserEntity extends Entity<User> {}

class Invoice extends ValueObject {
  static const amountField = 'amount';
  late final amountProperty = field<double>(name: amountField);

  @override
  List<ValueObjectBehavior> get behaviors => [amountProperty];
}

class InvoiceEntity extends Entity<Invoice> {}
