import 'package:drop_core/src/record/entity.dart';
import 'package:drop_core/src/record/value_object.dart';
import 'package:drop_core/src/repository/for_type_repository.dart';
import 'package:drop_core/src/repository/memory_repository.dart';
import 'package:drop_core/src/repository/repository_id_generator.dart';
import 'package:drop_core/src/repository/repository_query_executor.dart';
import 'package:drop_core/src/repository/repository_state_handler.dart';
import 'package:pond_core/pond_core.dart';
import 'package:type/type.dart';

abstract class Repository implements CorePondComponent {
  List<RuntimeType> get handledTypes => [];

  RepositoryIdGenerator get idGenerator => RepositoryIdGenerator.uuid();

  RepositoryStateHandler get stateHandler;

  RepositoryQueryExecutor get queryExecutor;

  static MemoryRepository memory() {
    return MemoryRepository();
  }
}

extension RepositoryExtension on Repository {
  ForTypeRepository forType<E extends Entity<V>, V extends ValueObject>(
    E Function() entityConstructor,
    V Function() valueObjectConstructor, {
    List<Type>? entityParents,
    List<Type>? valueObjectParents,
  }) {
    return ForTypeRepository<E, V>(
      repository: this,
      entityConstructor: entityConstructor,
      valueObjectConstructor: valueObjectConstructor,
      entityParents: entityParents ?? [],
      valueObjectParents: valueObjectParents ?? [],
    );
  }
}

mixin IsRepository implements Repository {
  @override
  List<RuntimeType> get handledTypes => [];

  @override
  RepositoryIdGenerator get idGenerator => RepositoryIdGenerator.uuid();

  @override
  List<CorePondComponentBehavior> get behaviors => [];

  @override
  late CorePondContext context;
}

abstract class RepositoryWrapper implements Repository {
  Repository get repository;

  @override
  List<RuntimeType> get handledTypes => repository.handledTypes;

  @override
  RepositoryIdGenerator get idGenerator => repository.idGenerator;

  @override
  RepositoryStateHandler get stateHandler => repository.stateHandler;

  @override
  RepositoryQueryExecutor get queryExecutor => repository.queryExecutor;
}

mixin IsRepositoryWrapper implements RepositoryWrapper {
  @override
  List<RuntimeType> get handledTypes => repository.handledTypes;

  @override
  RepositoryIdGenerator get idGenerator => repository.idGenerator;

  @override
  RepositoryStateHandler get stateHandler => repository.stateHandler;

  @override
  RepositoryQueryExecutor get queryExecutor => repository.queryExecutor;

  @override
  late CorePondContext context;

  @override
  List<CorePondComponentBehavior> get behaviors => repository.behaviors;
}
