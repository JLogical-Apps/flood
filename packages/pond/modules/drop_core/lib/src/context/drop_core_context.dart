import 'package:collection/collection.dart';
import 'package:drop_core/src/record/entity.dart';
import 'package:drop_core/src/record/value_object.dart';
import 'package:drop_core/src/repository/repository.dart';
import 'package:drop_core/src/repository/repository_list_wrapper.dart';
import 'package:drop_core/src/state/state.dart';
import 'package:runtime_type/type.dart';

abstract class DropCoreContext implements TypeContextWrapper, Repository {
  List<Repository> get repositories;

  factory DropCoreContext({required TypeContext typeContext}) => _DropCoreContextImpl(typeContext: typeContext);
}

class _DropCoreContextImpl with IsTypeContextWrapper, IsRepositoryListWrapper implements DropCoreContext {
  @override
  final List<Repository> repositories;

  @override
  final TypeContext typeContext;

  _DropCoreContextImpl({List<Repository>? repositories, required this.typeContext}) : repositories = repositories ?? [];
}

extension DropCoreContextExtension on DropCoreContext {
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
    valueObject.state = state;

    entity.value = valueObject;

    await entity.afterInitialize(this);

    return entity as E;
  }
}

mixin IsDropCoreContext implements DropCoreContext {
  @override
  List<RuntimeType> get runtimeTypes => typeContext.runtimeTypes;
}

abstract class DropCoreContextWrapper implements DropCoreContext {
  DropCoreContext get dropCoreContext;

  @override
  List<Repository> get repositories => dropCoreContext.repositories;
}

mixin IsDropCoreContextWrapper implements DropCoreContextWrapper {
  @override
  List<Repository> get repositories => dropCoreContext.repositories;

  @override
  List<RuntimeType> get runtimeTypes => dropCoreContext.runtimeTypes;
}
