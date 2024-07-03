import 'package:drop_core/src/repository/meta/repository_meta_modifier.dart';
import 'package:drop_core/src/repository/security/repository_security.dart';
import 'package:drop_core/src/repository/type/for_any_repository.dart';

class ForAnyRepositoryMetaModifier extends RepositoryMetaModifier<ForAnyRepository> {
  @override
  String? getPath(ForAnyRepository repository) {
    return null;
  }

  @override
  Type? getEntityType(ForAnyRepository repository) {
    return null;
  }

  @override
  RepositorySecurity? getSecurity(ForAnyRepository repository) {
    return null;
  }
}
