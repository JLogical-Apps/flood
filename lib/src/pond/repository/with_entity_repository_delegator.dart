import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:rxdart/rxdart.dart';

mixin WithEntityRepositoryDelegator implements EntityRepository {
  EntityRepository get entityRepository;

  @override
  List<Type> get handledEntityTypes => entityRepository.handledEntityTypes;

  @override
  Future<String> generateId(Entity entity) => entityRepository.generateId(entity);

  @override
  Future<void> save(Entity entity) => entityRepository.save(entity);

  @override
  Future<Entity?> getOrNull(String id, {bool withoutCache: false}) =>
      entityRepository.getOrNull(id, withoutCache: withoutCache);

  @override
  ValueStream<FutureValue<Entity?>> getXOrNull(String id) => entityRepository.getXOrNull(id);

  @override
  Future<void> delete(Entity entity) => entityRepository.delete(entity);

  @override
  ValueStream<FutureValue<T>> onExecuteQueryX<R extends Record, T>(QueryRequest<R, T> queryRequest) =>
      entityRepository.executeQueryX(queryRequest);

  @override
  Future<T> onExecuteQuery<R extends Record, T>(QueryRequest<R, T> queryRequest) =>
      entityRepository.executeQuery(queryRequest);
}
