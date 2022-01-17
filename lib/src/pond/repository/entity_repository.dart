import 'package:jlogical_utils/src/model/future_value.dart';
import 'package:jlogical_utils/src/pond/context/module/app_module.dart';
import 'package:jlogical_utils/src/pond/query/executor/query_executor_x.dart';
import 'package:jlogical_utils/src/pond/record/entity.dart';
import 'package:jlogical_utils/src/pond/transaction/transaction.dart';
import 'package:jlogical_utils/src/pond/transaction/transaction_executor.dart';
import 'package:jlogical_utils/src/pond/utils/with_key_synchronizable.dart';
import 'package:rxdart/rxdart.dart';

abstract class EntityRepository extends AppModule
    with WithKeySynchronizable<Transaction>
    implements QueryExecutorX, TransactionExecutor {
  List<Type> get handledEntityTypes;

  Future<String> generateId(Entity entity, {Transaction? transaction});

  Future<void> save(Entity entity, {Transaction? transaction});

  Future<Entity?> getOrNull(String id, {Transaction? transaction, bool withoutCache: false});

  ValueStream<FutureValue<Entity?>> getXOrNull(String id);

  Future<void> delete(Entity entity, {Transaction? transaction});

  Future<Entity> get(String id, {Transaction? transaction, bool withoutCache: false}) async {
    return (await getOrNull(id, transaction: transaction, withoutCache: withoutCache)) ??
        (throw Exception('Cannot find entity with id [$id] from repository [$this]'));
  }

  Future<void> create(Entity entity, {Transaction? transaction}) async {
    final id = await generateId(entity, transaction: transaction);
    entity.id = id;
    await save(entity, transaction: transaction);
    await entity.afterCreate();
  }

  EntityRepository get repository => this;
}
