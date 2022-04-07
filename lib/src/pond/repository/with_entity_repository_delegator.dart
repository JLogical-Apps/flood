import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:rxdart/rxdart.dart';

mixin WithEntityRepositoryDelegator implements EntityRepository {
  EntityRepository get entityRepository;

  @override
  List<Type> get handledEntityTypes => entityRepository.handledEntityTypes;

  @override
  Future<String> generateId(Entity entity) => entityRepository.generateId(entity);

  @override
  Future<void> saveState(State state) => entityRepository.saveState(state);

  @override
  Future<void> deleteState(State state) => entityRepository.deleteState(state);

  @override
  ValueStream<FutureValue<T>> onExecuteQueryX<R extends Record, T>(QueryRequest<R, T> queryRequest) =>
      entityRepository.executeQueryX(queryRequest);

  @override
  Future<T> onExecuteQuery<R extends Record, T>(QueryRequest<R, T> queryRequest) =>
      entityRepository.executeQuery(queryRequest);
}
