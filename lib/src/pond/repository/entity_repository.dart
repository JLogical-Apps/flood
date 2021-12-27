import 'package:jlogical_utils/src/model/future_value.dart';
import 'package:jlogical_utils/src/pond/query/query_executor.dart';
import 'package:jlogical_utils/src/pond/record/entity.dart';
import 'package:jlogical_utils/src/pond/transaction/transaction.dart';
import 'package:jlogical_utils/src/pond/transaction/transaction_executor.dart';
import 'package:jlogical_utils/src/pond/utils/with_key_synchronizable.dart';
import 'package:rxdart/rxdart.dart';

abstract class EntityRepository with WithKeySynchronizable<Transaction> implements QueryExecutor, TransactionExecutor {

  List<Type> get handledEntityTypes;

  Future<String> generateId(Entity entity, {Transaction? transaction});

  Future<void> save(Entity entity, {Transaction? transaction});

  Future<Entity?> getOrNull(String id, {Transaction? transaction});

  ValueStream<FutureValue<Entity>> getX(String id);

  Future<void> delete(String id, {Transaction? transaction});

  Future<Entity> get(String id, {Transaction? transaction}) async {
    return (await getOrNull(id, transaction: transaction)) ?? (throw Exception('Cannot find entity with id [$id] from repository [$this]'));
  }

  Future<void> create(Entity entity, {Transaction? transaction}) async {
    final id = await generateId(entity, transaction: transaction);
    entity.id = id;
    await save(entity, transaction: transaction);
  }

  EntityRepository get repository => this;
}
