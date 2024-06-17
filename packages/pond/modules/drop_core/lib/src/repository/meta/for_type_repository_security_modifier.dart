import 'package:drop_core/src/repository/meta/repository_meta_modifier.dart';
import 'package:drop_core/src/repository/security/repository_security.dart';
import 'package:drop_core/src/repository/type/for_type_repository.dart';

class ForTypeRepositoryMetaModifier extends RepositoryMetaModifier<ForTypeRepository> {
  @override
  String? getPath(ForTypeRepository repository) {
    return null;
  }

  @override
  Type getEntityType(ForTypeRepository repository) {
    return repository.entityRuntimeType.type;
  }

  @override
  RepositorySecurity? getSecurity(ForTypeRepository repository) {
    return null;
  }
}
