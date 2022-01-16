import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:rxdart/rxdart.dart';

mixin WithEntityRepositoryDelegator implements EntityRepository {
  EntityRepository get entityRepository;

  List<Type> get handledEntityTypes => entityRepository.handledEntityTypes;

  Future<String> generateId(Entity entity, {Transaction? transaction}) =>
      entityRepository.generateId(entity, transaction: transaction);

  Future<void> save(Entity entity, {Transaction? transaction}) =>
      entityRepository.save(entity, transaction: transaction);

  Future<Entity?> getOrNull(String id, {Transaction? transaction, bool withoutCache: false}) =>
      entityRepository.getOrNull(id, transaction: transaction, withoutCache: withoutCache);

  ValueStream<FutureValue<Entity?>> getXOrNull(String id) => entityRepository.getXOrNull(id);

  Future<void> delete(Entity entity, {Transaction? transaction}) =>
      entityRepository.delete(entity, transaction: transaction);

  ValueStream<FutureValue<T>> executeQueryX<R extends Record, T>(QueryRequest<R, T> queryRequest) =>
      entityRepository.executeQueryX(queryRequest);

  Future<T> executeQuery<R extends Record, T>(QueryRequest<R, T> queryRequest, {Transaction? transaction}) =>
      entityRepository.executeQuery(queryRequest);

  Future<void> commit() => entityRepository.commit();

  Future<void> revert() => entityRepository.revert();
}
