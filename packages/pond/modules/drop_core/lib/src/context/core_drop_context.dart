import 'package:collection/collection.dart';
import 'package:drop_core/src/record/entity.dart';
import 'package:drop_core/src/record/value_object.dart';
import 'package:drop_core/src/repository/repository.dart';
import 'package:drop_core/src/repository/repository_list_wrapper.dart';
import 'package:drop_core/src/state/state.dart';
import 'package:type/type.dart';

abstract class CoreDropContext implements TypeContextWrapper, Repository {
  List<Repository> get repositories;

  factory CoreDropContext({required TypeContext typeContext}) => _CoreDropContextImpl(typeContext: typeContext);
}

class _CoreDropContextImpl with IsTypeContextWrapper, IsRepositoryListWrapper implements CoreDropContext {
  @override
  final List<Repository> repositories;

  @override
  final TypeContext typeContext;

  _CoreDropContextImpl({List<Repository>? repositories, required this.typeContext}) : repositories = repositories ?? [];
}

extension CoreDropContextExtension on CoreDropContext {
  Repository? getRepositoryForTypeOrNullRuntime(Type entityType) {
    return repositories.firstWhereOrNull((repository) => repository.handledTypes.any((runtimeType) =>
        runtimeType.type == entityType ||
        runtimeType.getDescendants().any((descendant) => descendant.type == entityType)));
  }

  Repository? getRepositoryForTypeOrNull<E extends Entity>() {
    return getRepositoryForTypeOrNullRuntime(E);
  }

  Repository getRepositoryForTypeRuntime(Type entityType) {
    return getRepositoryForTypeOrNullRuntime(entityType) ??
        (throw Exception('Could not find repository for [$entityType]'));
  }

  Repository getRepositoryFor<E extends Entity>() {
    return getRepositoryForTypeRuntime(E);
  }

  Future<E> constructEntityFromState<E extends Entity>(State state) async {
    final entity = state.type!.createInstance() as Entity;
    entity.id = state.id;

    state = await entity.beforeInitialize(this, state: state) ?? state;

    final valueObject = typeContext.getRuntimeTypeRuntime(entity.valueObjectType).createInstance() as ValueObject;
    valueObject.setState(this, state);

    entity.value = valueObject;

    await entity.afterInitialize(this);

    return entity as E;
  }
}

mixin IsCoreDropContext implements CoreDropContext {
  @override
  List<RuntimeType> get runtimeTypes => typeContext.runtimeTypes;
}

abstract class CoreDropContextWrapper implements CoreDropContext {
  CoreDropContext get coreDropContext;

  @override
  List<Repository> get repositories => coreDropContext.repositories;
}

mixin IsCoreDropContextWrapper implements CoreDropContextWrapper {
  @override
  List<Repository> get repositories => coreDropContext.repositories;

  @override
  List<RuntimeType> get runtimeTypes => coreDropContext.runtimeTypes;
}
