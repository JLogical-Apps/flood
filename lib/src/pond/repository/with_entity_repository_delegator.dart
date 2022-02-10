import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:jlogical_utils/src/pond/query/executor/query_executor.dart';
import 'package:rxdart/rxdart.dart';

mixin WithEntityRepositoryDelegator implements EntityRepository {
  EntityRepository get entityRepository;

  @override
  List<Type> get handledEntityTypes => entityRepository.handledEntityTypes;

  @override
  Future<String> generateId(Entity entity, {Transaction? transaction}) =>
      entityRepository.generateId(entity, transaction: transaction);

  @override
  Future<void> save(Entity entity, {Transaction? transaction}) =>
      entityRepository.save(entity, transaction: transaction);

  @override
  Future<Entity?> getOrNull(String id, {Transaction? transaction, bool withoutCache: false}) =>
      entityRepository.getOrNull(id, transaction: transaction, withoutCache: withoutCache);

  @override
  ValueStream<FutureValue<Entity?>> getXOrNull(String id) => entityRepository.getXOrNull(id);

  @override
  Future<void> delete(Entity entity, {Transaction? transaction}) =>
      entityRepository.delete(entity, transaction: transaction);

  @override
  ValueStream<FutureValue<T>> onExecuteQueryX<R extends Record, T>(QueryRequest<R, T> queryRequest) =>
      entityRepository.executeQueryX(queryRequest);

  @override
  Future<T> onExecuteQuery<R extends Record, T>(QueryRequest<R, T> queryRequest, {Transaction? transaction}) =>
      entityRepository.executeQuery(queryRequest);

  @override
  Future<void> commit() => entityRepository.commit();

  @override
  Future<void> revert() => entityRepository.revert();
}
