import 'package:collection/collection.dart';
import 'package:drop_core/src/record/entity.dart';
import 'package:drop_core/src/repository/repository.dart';
import 'package:type/type.dart';

abstract class DropCoreContext {
  List<Repository> get repositories;

  TypeContext get typeContext;

  factory DropCoreContext({required TypeContext typeContext}) => _DropCoreContextImpl(typeContext: typeContext);
}

class _DropCoreContextImpl implements DropCoreContext {
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
}

mixin IsDropCoreContext implements DropCoreContext {}

abstract class DropCoreContextWrapper implements DropCoreContext {
  DropCoreContext get dropCoreContext;

  @override
  List<Repository> get repositories => dropCoreContext.repositories;
}

mixin IsDropCoreContextWrapper implements DropCoreContextWrapper {
  @override
  List<Repository> get repositories => dropCoreContext.repositories;
}
