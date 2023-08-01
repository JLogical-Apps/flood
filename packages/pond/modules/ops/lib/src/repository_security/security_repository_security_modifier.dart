import 'package:drop_core/drop_core.dart';
import 'package:ops/src/repository_security/repository_security_modifier.dart';

class SecurityRepositorySecurityModifier extends RepositorySecurityModifier<SecurityRepository> {
  final RepositorySecurityModifier? Function(Repository repository) modifierGetter;

  SecurityRepositorySecurityModifier({required this.modifierGetter});

  @override
  String? getPath(SecurityRepository repository) {
    final subRepository = repository.repository;
    return modifierGetter(subRepository)?.getPath(subRepository);
  }

  @override
  RepositorySecurity? getSecurity(SecurityRepository repository) {
    return repository.repositorySecurity;
  }
}
