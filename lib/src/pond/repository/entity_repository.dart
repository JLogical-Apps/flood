import 'package:jlogical_utils/src/model/future_value.dart';
import 'package:jlogical_utils/src/pond/query/query_executor.dart';
import 'package:jlogical_utils/src/pond/record/entity.dart';
import 'package:jlogical_utils/src/pond/transaction/transaction.dart';
import 'package:jlogical_utils/src/pond/transaction/transaction_executor.dart';
import 'package:jlogical_utils/src/pond/utils/with_key_synchronizable.dart';
import 'package:rxdart/rxdart.dart';

abstract class EntityRepository<E extends Entity>
    with WithKeySynchronizable<Transaction>
    implements QueryExecutor, TransactionExecutor {
  Future<String> generateId(E entity, {Transaction? transaction});

  Future<void> save(E entity, {Transaction? transaction});

  Future<E?> getOrNull(String id, {Transaction? transaction});

  ValueStream<FutureValue<E>>? getXOrNull(String id);

  Future<void> delete(String id, {Transaction? transaction});

  Future<E> get(String id, {Transaction? transaction}) async {
    return (await getOrNull(id, transaction: transaction)) ?? (throw Exception('Cannot find $E with id: $id'));
  }

  Future<void> create(E entity, {Transaction? transaction}) async {
    final id = await generateId(entity, transaction: transaction);
    entity.id = id;
    await save(entity, transaction: transaction);
  }

  Type get entityType => E;

  EntityRepository get repository => this;
}
