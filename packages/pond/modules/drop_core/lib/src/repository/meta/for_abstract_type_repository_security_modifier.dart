import 'package:drop_core/src/repository/meta/repository_meta_modifier.dart';
import 'package:drop_core/src/repository/security/repository_security.dart';
import 'package:drop_core/src/repository/type/for_abstract_type_repository.dart';

class ForAbstractTypeRepositoryMetaModifier extends RepositoryMetaModifier<ForAbstractTypeRepository> {
  @override
  String? getPath(ForAbstractTypeRepository repository) {
    return null;
  }

  @override
  Type getEntityType(ForAbstractTypeRepository repository) {
    return repository.entityRuntimeType.type;
  }

  @override
  RepositorySecurity? getSecurity(ForAbstractTypeRepository repository) {
    return null;
  }
}
