import 'package:drop_core/drop_core.dart';
import 'package:ops/src/repository_security/repository_security_modifier.dart';

class WrapperRepositorySecurityModifier extends RepositorySecurityModifier<RepositoryWrapper> {
  final RepositorySecurityModifier? Function(Repository repository) modifierGetter;

  WrapperRepositorySecurityModifier({required this.modifierGetter});

  @override
  String? getPath(RepositoryWrapper repository) {
    final subRepository = repository.repository;
    return modifierGetter(subRepository)?.getPath(subRepository);
  }

  @override
  RepositorySecurity? getSecurity(RepositoryWrapper repository) {
    final subRepository = repository.repository;
    return modifierGetter(subRepository)?.getSecurity(subRepository);
  }
}
