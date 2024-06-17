import 'package:drop_core/src/repository/meta/repository_meta_modifier.dart';
import 'package:drop_core/src/repository/security/repository_security.dart';
import 'package:drop_core/src/repository/security/security_repository.dart';

class SecurityRepositoryMetaModifier extends WrapperRepositoryMetaModifier<SecurityRepository> {
  @override
  RepositorySecurity? getSecurity(SecurityRepository repository) {
    return repository.repositorySecurity;
  }
}
