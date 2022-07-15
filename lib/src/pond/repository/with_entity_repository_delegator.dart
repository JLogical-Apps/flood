import 'package:jlogical_utils/src/pond/query/executor/query_executor.dart';
import 'package:jlogical_utils/src/pond/query/executor/query_executor_x.dart';
import 'package:rxdart/rxdart.dart';

import '../../model/export_core.dart';
import '../context/module/app_module.dart';
import '../query/request/query_request.dart';
import '../record/entity.dart';
import '../record/record.dart';
import '../state/state.dart';
import 'entity_repository.dart';

mixin WithEntityRepositoryDelegator implements EntityRepository {
  EntityRepository get entityRepository;

  /// Register the [entityRepository] instead of the current repository.
  @override
  AppModule get registerTarget => entityRepository;

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
