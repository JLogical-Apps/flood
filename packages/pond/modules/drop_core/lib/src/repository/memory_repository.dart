import 'package:drop_core/src/context/core_pond_context_extensions.dart';
import 'package:drop_core/src/context/core_drop_context.dart';
import 'package:drop_core/src/core_drop_component.dart';
import 'package:drop_core/src/record/value_object/time/timestamp.dart';
import 'package:drop_core/src/repository/query_executor/state_query_executor.dart';
import 'package:drop_core/src/repository/repository.dart';
import 'package:drop_core/src/repository/repository_query_executor.dart';
import 'package:drop_core/src/repository/repository_state_handler.dart';
import 'package:drop_core/src/state/state.dart';
import 'package:rxdart/rxdart.dart';
import 'package:utils_core/utils_core.dart';
import 'package:uuid/uuid.dart';

class MemoryRepository with IsRepository {
  final BehaviorSubject<Map<String, State>> stateByIdX = BehaviorSubject.seeded({});

  @override
  late final RepositoryQueryExecutor queryExecutor = MemoryRepositoryQueryExecutor(repository: this);

  @override
  late final RepositoryStateHandler stateHandler = MemoryRepositoryStateHandler(repository: this);
}

class MemoryRepositoryQueryExecutor with IsRepositoryQueryExecutorWrapper {
  final MemoryRepository repository;

  MemoryRepositoryQueryExecutor({required this.repository});

  @override
  RepositoryQueryExecutor get queryExecutor {
    final stateByIdX = repository.stateByIdX;

    return StateQueryExecutor(
      dropContext: repository.context.locate<CoreDropComponent>(),
      statesX: stateByIdX.mapWithValue((stateById) => stateById.values.toList()),
    );
  }
}

class MemoryRepositoryStateHandler implements RepositoryStateHandler {
  final MemoryRepository repository;

  MemoryRepositoryStateHandler({required this.repository});

  @override
  Future<State> onUpdate(State state) async {
    final context = repository.context.coreDropComponent;

    final isNew = state.isNew;
    final id = state.id ?? Uuid().v4();

    final entity = await context.constructEntityFromState(state);
    if (isNew) {
      await entity.beforeCreate(context);
    }

    await entity.beforeSave(context);
    state = entity.getState(context);

    state = state.withId(id).withData(state.data
        .replaceWhereTraversed(
          (key, value) => value is Timestamp,
          (key, value) => (value as Timestamp).time,
        )
        .cast<String, dynamic>());

    repository.stateByIdX.value = repository.stateByIdX.value.copy()..set(state.id!, state);

    if (isNew) {
      await entity.afterCreate(context);
    }

    await entity.afterSave(context);

    state = entity.getState(context).withId(id);

    return state;
  }

  @override
  Future<State> onDelete(State state) async {
    final context = repository.context.coreDropComponent;
    final entity = await context.constructEntityFromState(state);

    await entity.beforeDelete(context);
    repository.stateByIdX.value = repository.stateByIdX.value.copy()..remove(state.id!);
    await entity.afterDelete(context);

    state = entity.getState(context);

    return state;
  }
}
