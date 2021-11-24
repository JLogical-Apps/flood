import 'package:jlogical_utils/src/pond/query/query_executor.dart';
import 'package:jlogical_utils/src/pond/record/entity.dart';
import 'package:jlogical_utils/src/pond/transaction/transaction.dart';
import 'package:jlogical_utils/src/pond/transaction/transaction_executor.dart';
import 'package:jlogical_utils/src/pond/utils/with_key_synchronizable.dart';

abstract class EntityRepository<E extends Entity>
    with WithKeySynchronizable<Transaction>
    implements QueryExecutor, TransactionExecutor {
  Future<String> generateId(E entity, {required Transaction transaction});

  Future<void> save(E entity, {required Transaction transaction});

  Future<E?> getOrNull(String id, {required Transaction transaction});

  Future<void> delete(String id, {required Transaction transaction});

  Future<E> get(String id, {required Transaction transaction}) async {
    return (await getOrNull(id, transaction: transaction)) ?? (throw Exception('Cannot find $E with id: $id'));
  }

  Future<void> create(E entity, {required Transaction transaction}) async {
    final id = await generateId(entity, transaction: transaction);
    entity.id = id;
    await save(entity, transaction: transaction);
  }

  Future<String> generateIdIsolated(E entity) {
    final transaction = Transaction((tr) => tr.generateId(entity));
    return transaction.execute(this);
  }

  Future<void> saveIsolated(E entity) {
    final transaction = Transaction((tr) => tr.save(entity));
    return transaction.execute(this);
  }

  Future<E?> getOrNullIsolated(String id) {
    final transaction = Transaction((tr) => tr.getOrNull<E>(id));
    return transaction.execute(this);
  }

  Future<void> deleteIsolated(String id) {
    final transaction = Transaction((tr) => tr.delete(id));
    return transaction.execute(this);
  }

  Future<E> getIsolated(String id) {
    final transaction = Transaction((tr) => tr.get<E>(id));
    return transaction.execute(this);
  }

  Future<void> createIsolated(E entity) {
    final transaction = Transaction((tr) => tr.create(entity));
    return transaction.execute(this);
  }

  Type get entityType => E;

  EntityRepository get repository => this;
}
