import 'package:drop_core/drop_core.dart';
import 'package:pond_core/pond_core.dart';
import 'package:test/test.dart';
import 'package:type_core/type_core.dart';
import 'package:utils_core/utils_core.dart';

void main() {
  test('query all', () async {
    final repository = Repository.forType<UserEntity, User>(
      UserEntity.new,
      User.new,
      entityTypeName: 'UserEntity',
      valueObjectTypeName: 'User',
    ).memory();

    final users = [
      User()
        ..nameProperty.set('Jake')
        ..emailProperty.set('jake@jake.com'),
      User()
        ..nameProperty.set('John')
        ..emailProperty.set('john@doe.com'),
    ];

    final context = CorePondContext();
    await context.register(TypeCoreComponent());
    await context.register(DropCoreComponent());
    await context.register(repository);

    for (final user in users) {
      await repository.update(UserEntity()..value = user);
    }

    final allUserEntities = await repository.executeQuery(Query.from<UserEntity>().all());
    expect(allUserEntities.map((entity) => entity.value).toList(), users);

    final allUserStates = await repository.executeQuery(Query.from<UserEntity>().allStates());
    expect(allUserStates.map((state) => state.data),
        users.map((user) => user.getState(context.locate<DropCoreComponent>()).data).toList());
  });

  test('query first', () async {
    final repository = Repository.forType<UserEntity, User>(
      UserEntity.new,
      User.new,
      entityTypeName: 'UserEntity',
      valueObjectTypeName: 'User',
    ).memory();

    final users = [
      User()
        ..nameProperty.set('Jake')
        ..emailProperty.set('jake@jake.com'),
      User()
        ..nameProperty.set('John')
        ..emailProperty.set('john@doe.com'),
    ];

    final context = CorePondContext();
    await context.register(TypeCoreComponent());
    await context.register(DropCoreComponent());
    await context.register(repository);

    for (final user in users) {
      await repository.update(UserEntity()..value = user);
    }

    final firstUserEntity = await repository.executeQuery(Query.from<UserEntity>().firstOrNull());
    expect(firstUserEntity?.value, users[0]);

    final firstUserEntityState = await repository.executeQuery(Query.from<UserEntity>().firstOrNullState());
    expect(firstUserEntityState?.data, users[0].getState(context.locate<DropCoreComponent>()).data);
  });

  test('query where equals', () async {
    final repository = Repository.forType<UserEntity, User>(
      UserEntity.new,
      User.new,
      entityTypeName: 'UserEntity',
      valueObjectTypeName: 'User',
    ).memory();

    final users = [
      User()
        ..nameProperty.set('Jake')
        ..emailProperty.set('jake@jake.com'),
      User()..emailProperty.set('john@doe.com'),
    ];

    final context = CorePondContext();
    await context.register(TypeCoreComponent());
    await context.register(DropCoreComponent());
    await context.register(repository);

    for (final user in users) {
      await repository.update(UserEntity()..value = user);
    }

    final johnUserEntity =
        await repository.executeQuery(Query.from<UserEntity>().where('name').isEqualTo('John').firstOrNull());
    expect(johnUserEntity?.value, users[1]);
  });

  test('query where contains', () async {
    final repository = Repository.forType<UserEntity, User>(
      UserEntity.new,
      User.new,
      entityTypeName: 'UserEntity',
      valueObjectTypeName: 'User',
    ).memory();

    final users = [
      User()
        ..nameProperty.set('Jake')
        ..emailProperty.set('jake@jake.com')
        ..itemsProperty.set(['a', 'b']),
      User()
        ..nameProperty.set('John')
        ..emailProperty.set('john@doe.com')
        ..itemsProperty.set(['b', 'c']),
    ];

    final context = CorePondContext();
    await context.register(TypeCoreComponent());
    await context.register(DropCoreComponent());
    await context.register(repository);

    for (final user in users) {
      await repository.update(UserEntity()..value = user);
    }

    final containsA = await repository.executeQuery(Query.from<UserEntity>().where('items').contains('a').all());
    expect(containsA.map((user) => user.value.nameProperty.value), ['Jake']);

    final containsB = await repository.executeQuery(Query.from<UserEntity>().where('items').contains('b').all());
    expect(containsB.map((user) => user.value.nameProperty.value), ['Jake', 'John']);

    final containsC = await repository.executeQuery(Query.from<UserEntity>().where('items').contains('c').all());
    expect(containsC.map((user) => user.value.nameProperty.value), ['John']);

    final containsD = await repository.executeQuery(Query.from<UserEntity>().where('items').contains('d').all());
    expect(containsD, []);
  });

  test('query where contains any', () async {
    final repository = Repository.forType<UserEntity, User>(
      UserEntity.new,
      User.new,
      entityTypeName: 'UserEntity',
      valueObjectTypeName: 'User',
    ).memory();

    final users = [
      User()
        ..nameProperty.set('Jake')
        ..emailProperty.set('jake@jake.com')
        ..itemsProperty.set(['a', 'b']),
      User()
        ..nameProperty.set('John')
        ..emailProperty.set('john@doe.com')
        ..itemsProperty.set(['b', 'c']),
    ];

    final context = CorePondContext();
    await context.register(TypeCoreComponent());
    await context.register(DropCoreComponent());
    await context.register(repository);

    for (final user in users) {
      await repository.update(UserEntity()..value = user);
    }

    final containsA =
        await repository.executeQuery(Query.from<UserEntity>().where('items').containsAny(['a', 'c']).all());
    expect(containsA.map((user) => user.value.nameProperty.value), ['Jake', 'John']);

    final containsB =
        await repository.executeQuery(Query.from<UserEntity>().where('items').containsAny(['b', 'd']).all());
    expect(containsB.map((user) => user.value.nameProperty.value), ['Jake', 'John']);

    final containsC = await repository.executeQuery(Query.from<UserEntity>().where('items').containsAny(['a']).all());
    expect(containsC.map((user) => user.value.nameProperty.value), ['Jake']);

    final containsD = await repository.executeQuery(Query.from<UserEntity>().where('items').containsAny([]).all());
    expect(containsD, []);
  });

  test('query where numeric', () async {
    final repository = Repository.forType<InvoiceEntity, Invoice>(
      InvoiceEntity.new,
      Invoice.new,
      entityTypeName: 'InvoiceEntity',
      valueObjectTypeName: 'Invoice',
    ).memory();

    final invoices = [
      Invoice()..amountProperty.set(0),
      Invoice()..amountProperty.set(10),
      Invoice()..amountProperty.set(20),
      Invoice()..amountProperty.set(50),
      Invoice()..amountProperty.set(100),
      Invoice()..amountProperty.set(-10),
      Invoice()..amountProperty.set(null),
    ];

    final context = CorePondContext();
    await context.register(TypeCoreComponent());
    await context.register(DropCoreComponent());
    await context.register(repository);

    for (final invoice in invoices) {
      await repository.update(InvoiceEntity()..value = invoice);
    }

    final zeroInvoiceEntities =
        await repository.executeQuery(Query.from<InvoiceEntity>().where(Invoice.amountField).isEqualTo(0).all());
    expect(
      zeroInvoiceEntities.map((e) => e.value).toList(),
      invoices.where((i) => i.amountProperty.value == 0).toList(),
    );

    final positiveInvoiceEntities =
        await repository.executeQuery(Query.from<InvoiceEntity>().where(Invoice.amountField).isGreaterThan(0).all());
    expect(
      positiveInvoiceEntities.map((e) => e.value).toList(),
      invoices.where((i) => i.amountProperty.value != null && i.amountProperty.value! > 0).toList(),
    );

    final nonNegativeInvoiceEntities = await repository
        .executeQuery(Query.from<InvoiceEntity>().where(Invoice.amountField).isGreaterThanOrEqualTo(0).all());
    expect(
      nonNegativeInvoiceEntities.map((e) => e.value).toList(),
      invoices.where((i) => i.amountProperty.value != null && i.amountProperty.value! >= 0).toList(),
    );

    final negativeInvoiceEntities =
        await repository.executeQuery(Query.from<InvoiceEntity>().where(Invoice.amountField).isLessThan(0).all());
    expect(
      negativeInvoiceEntities.map((e) => e.value).toList(),
      invoices.where((i) => i.amountProperty.value != null && i.amountProperty.value! < 0).toList(),
    );

    final nonPositiveInvoiceEntities = await repository
        .executeQuery(Query.from<InvoiceEntity>().where(Invoice.amountField).isLessThanOrEqualTo(0).all());
    expect(
      nonPositiveInvoiceEntities.map((e) => e.value).toList(),
      invoices.where((i) => i.amountProperty.value != null && i.amountProperty.value! <= 0).toList(),
    );

    final nullInvoiceEntities =
        await repository.executeQuery(Query.from<InvoiceEntity>().where(Invoice.amountField).isNull().all());
    expect(
      nullInvoiceEntities.map((e) => e.value).toList(),
      invoices.where((i) => i.amountProperty.value == null).toList(),
    );

    final nonNullInvoiceEntities =
        await repository.executeQuery(Query.from<InvoiceEntity>().where(Invoice.amountField).isNonNull().all());
    expect(
      nonNullInvoiceEntities.map((e) => e.value).toList(),
      invoices.where((i) => i.amountProperty.value != null).toList(),
    );
  });

  test('query orderby numeric', () async {
    final repository = Repository.forType<InvoiceEntity, Invoice>(
      InvoiceEntity.new,
      Invoice.new,
      entityTypeName: 'InvoiceEntity',
      valueObjectTypeName: 'Invoice',
    ).memory();

    final invoices = [
      Invoice()..amountProperty.set(20),
      Invoice()..amountProperty.set(0),
      Invoice()..amountProperty.set(100),
      Invoice()..amountProperty.set(null),
      Invoice()..amountProperty.set(10),
      Invoice()..amountProperty.set(-10),
      Invoice()..amountProperty.set(50),
    ];

    final context = CorePondContext();
    await context.register(TypeCoreComponent());
    await context.register(DropCoreComponent());
    await context.register(repository);

    for (final invoice in invoices) {
      await repository.update(InvoiceEntity()..value = invoice);
    }

    final ascendingInvoiceEntities =
        await repository.executeQuery(Query.from<InvoiceEntity>().orderByAscending(Invoice.amountField).all());
    final ascending = [
      ...invoices.where((i) => i.amountProperty.value != null).toList()
        ..sort((a, b) => a.amountProperty.value!.compareTo(b.amountProperty.value!)),
      ...invoices.where((i) => i.amountProperty.value == null),
    ];
    expect(
      ascendingInvoiceEntities.map((e) => e.value).toList(),
      ascending,
    );

    final descendingInvoiceEntities =
        await repository.executeQuery(Query.from<InvoiceEntity>().orderByDescending(Invoice.amountField).all());
    final descending = [
      ...invoices.where((i) => i.amountProperty.value != null).toList()
        ..sort((a, b) => b.amountProperty.value!.compareTo(a.amountProperty.value!)),
      ...invoices.where((i) => i.amountProperty.value == null),
    ];
    expect(
      descendingInvoiceEntities.map((e) => e.value).toList(),
      descending,
    );
  });

  test('paginate queries', () async {
    final repository = Repository.forType<InvoiceEntity, Invoice>(
      InvoiceEntity.new,
      Invoice.new,
      entityTypeName: 'InvoiceEntity',
      valueObjectTypeName: 'Invoice',
    ).memory();

    final invoices = [
      Invoice()..amountProperty.set(0),
      Invoice()..amountProperty.set(10),
      Invoice()..amountProperty.set(20),
      Invoice()..amountProperty.set(50),
    ];

    final context = CorePondContext();
    await context.register(TypeCoreComponent());
    await context.register(DropCoreComponent());
    await context.register(repository);

    for (final invoice in invoices) {
      await repository.update(InvoiceEntity()..value = invoice);
    }

    final queryResultPage = await repository.executeQuery(Query.from<InvoiceEntity>().paginate(pageSize: 2));
    expect((await queryResultPage.getItems()).map((i) => i.value), invoices.take(2).toList());
    expect(queryResultPage.hasNext, isTrue);

    final nextQueryResultPage = await queryResultPage.getNextPage();
    expect((await nextQueryResultPage.getItems()).map((i) => i.value), invoices.skip(2).take(2).toList());
    expect(nextQueryResultPage.hasNext, isFalse);

    final allItems = await queryResultPage.combineAll();
    expect(allItems.map((i) => i.value), invoices);
  });

  test('query all map', () async {
    final repository = Repository.forType<UserEntity, User>(
      UserEntity.new,
      User.new,
      entityTypeName: 'UserEntity',
      valueObjectTypeName: 'User',
    ).memory();

    final users = [
      User()
        ..nameProperty.set('Jake')
        ..emailProperty.set('jake@jake.com'),
      User()
        ..nameProperty.set('John')
        ..emailProperty.set('john@doe.com'),
    ];

    final context = CorePondContext();
    await context.register(TypeCoreComponent());
    await context.register(DropCoreComponent());
    await context.register(repository);

    for (final user in users) {
      await repository.update(UserEntity()..value = user);
    }

    final allUserNames = await repository.executeQuery(Query.from<UserEntity>()
        .all()
        .map((context, entities) => entities.map((entity) => entity.value.nameProperty.value).toList()));
    expect(allUserNames, users.map((user) => user.nameProperty.value).toList());

    final allUserEmails = await repository.executeQuery(
        Query.from<UserEntity>().allStates().map((context, states) => states.map((state) => state['email']).toList()));
    expect(allUserEmails, users.map((user) => user.emailProperty.value).toList());
  });

  test('query on abstract type.', () async {
    final repository = Repository.forAbstractType<TransactionEntity, Transaction>(
      entityTypeName: 'TransactionEntity',
      valueObjectTypeName: 'Transaction',
    )
        .withImplementation<EnvelopeTransactionEntity, EnvelopeTransaction>(
          EnvelopeTransactionEntity.new,
          EnvelopeTransaction.new,
          entityTypeName: 'EnvelopeTransactionEntity',
          valueObjectTypeName: 'EnvelopeTransaction',
        )
        .withImplementation<TransferTransactionEntity, TransferTransaction>(
          TransferTransactionEntity.new,
          TransferTransaction.new,
          entityTypeName: 'TransferTransactionEntity',
          valueObjectTypeName: 'TransferTransaction',
        )
        .memory();

    final transactionEntities = <TransactionEntity>[
      EnvelopeTransactionEntity()..value = EnvelopeTransaction(),
      TransferTransactionEntity()..value = TransferTransaction(),
    ];

    final context = CorePondContext();
    await context.register(TypeCoreComponent());
    await context.register(DropCoreComponent());
    await context.register(repository);

    await Future.wait(transactionEntities.map((e) => repository.update(e)));

    final allTransactionEntities = await repository.executeQuery(Query.from<TransactionEntity>().all());
    expect(allTransactionEntities.map((e) => e.value), transactionEntities.map((e) => e.value));
  });

  test('list repository', () async {
    final userRepository = Repository.forType<UserEntity, User>(
      UserEntity.new,
      User.new,
      entityTypeName: 'UserEntity',
      valueObjectTypeName: 'User',
    ).memory();
    final invoiceRepository = Repository.forType<InvoiceEntity, Invoice>(
      InvoiceEntity.new,
      Invoice.new,
      entityTypeName: 'InvoiceEntity',
      valueObjectTypeName: 'Invoice',
    ).memory();
    final listRepository = Repository.list([userRepository, invoiceRepository]);

    final context = CorePondContext();
    await context.register(TypeCoreComponent());
    await context.register(DropCoreComponent());
    await context.register(listRepository);

    await listRepository.update(UserEntity()..value = (User()..nameProperty.set('John Doe')));
    await listRepository.update(InvoiceEntity()..value = (Invoice()..amountProperty.set(35)));

    final userEntity = await listRepository.executeQuery(Query.from<UserEntity>().first());
    expect(userEntity.value.nameProperty.value, 'John Doe');

    final invoiceEntity = await listRepository.executeQuery(Query.from<InvoiceEntity>().first());
    expect(invoiceEntity.value.amountProperty.value, 35);
  });

  test('query equality', () {
    expect(Query.from<UserEntity>().all(), Query.from<UserEntity>().all());
    expect(Query.from<UserEntity>().all(), isNot(Query.from<UserEntity>().allStates()));
    expect(Query.from<UserEntity>().allStates(), Query.from<UserEntity>().allStates());
    expect(Query.from<UserEntity>().where('a').isEqualTo('b').all(),
        Query.from<UserEntity>().where('a').isEqualTo('b').all());
    expect(Query.from<UserEntity>().where('a').isEqualTo('b').all(),
        isNot(Query.from<UserEntity>().where('a').isEqualTo('c').all()));
    expect(Query.from<UserEntity>().where('a').isEqualTo('b').all(),
        isNot(Query.from<UserEntity>().where('c').isEqualTo('b').all()));
    expect(Query.from<UserEntity>().all(), isNot(Query.from<UserEntity>().all().withoutCache()));
    expect(Query.from<UserEntity>().all().withoutCache(), Query.from<UserEntity>().all().withoutCache());
  });

  test('query limit', () async {
    final repository = Repository.forType<UserEntity, User>(
      UserEntity.new,
      User.new,
      entityTypeName: 'UserEntity',
      valueObjectTypeName: 'User',
    ).memory();

    final users = [
      User()
        ..nameProperty.set('Jake')
        ..emailProperty.set('jake@jake.com'),
      User()
        ..nameProperty.set('John')
        ..emailProperty.set('john@doe.com'),
    ];

    final context = CorePondContext();
    await context.register(TypeCoreComponent());
    await context.register(DropCoreComponent());
    await context.register(repository);

    for (final user in users) {
      await repository.update(UserEntity()..value = user);
    }

    final firstUser = await Query.from<UserEntity>().limit(1).all().get(context.dropCoreComponent);
    expect(firstUser[0].value, users[0]);
  });

  test('query count', () async {
    final repository = Repository.forType<UserEntity, User>(
      UserEntity.new,
      User.new,
      entityTypeName: 'UserEntity',
      valueObjectTypeName: 'User',
    ).memory();

    final users = [
      User()
        ..nameProperty.set('Jake')
        ..emailProperty.set('jake@jake.com'),
      User()
        ..nameProperty.set('John')
        ..emailProperty.set('john@doe.com'),
    ];

    final context = CorePondContext();
    await context.register(TypeCoreComponent());
    await context.register(DropCoreComponent());
    await context.register(repository);

    for (final user in users) {
      await repository.update(UserEntity()..value = user);
    }

    final allUsersCount = await Query.from<UserEntity>().count().get(context.dropCoreComponent);
    expect(allUsersCount, users.length);

    final johnUsersCount =
        await Query.from<UserEntity>().where('name').isEqualTo('John').count().get(context.dropCoreComponent);
    expect(johnUsersCount, 1);
  });
}

class User extends ValueObject {
  late final nameProperty = field<String>(name: 'name').withFallback(() => 'John');
  late final emailProperty = field<String>(name: 'email');
  late final itemsProperty = field<String>(name: 'items').list();

  @override
  late final List<ValueObjectBehavior> behaviors = [nameProperty, emailProperty, itemsProperty];
}

class UserEntity extends Entity<User> {}

class Invoice extends ValueObject {
  static const amountField = 'amount';
  late final amountProperty = field<double>(name: amountField);

  @override
  late final List<ValueObjectBehavior> behaviors = [amountProperty];
}

class InvoiceEntity extends Entity<Invoice> {}

abstract class Transaction extends ValueObject {}

abstract class TransactionEntity<T extends Transaction> extends Entity<T> {}

class EnvelopeTransaction extends Transaction {}

class EnvelopeTransactionEntity extends TransactionEntity<EnvelopeTransaction> {}

class TransferTransaction extends Transaction {}

class TransferTransactionEntity extends TransactionEntity<TransferTransaction> {}
