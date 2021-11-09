import 'package:collection/collection.dart';
import 'package:jlogical_utils/src/pond/record/entity.dart';
import 'package:jlogical_utils/src/pond/repository/entity_repository.dart';

class Database {
  final List<EntityRepository> repositories;

  const Database({required this.repositories});

  EntityRepository<E> getRepository<E extends Entity>() {
    final repository = repositories.firstWhereOrNull((repository) => repository.entityType == E) ??
        (throw Exception('Cannot find repository for $E'));
    return repository as EntityRepository<E>;
  }
}
