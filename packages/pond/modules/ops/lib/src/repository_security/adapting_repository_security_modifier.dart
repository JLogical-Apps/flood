import 'package:drop_core/drop_core.dart';
import 'package:ops/src/repository_security/repository_security_modifier.dart';

class AdaptingRepositorySecurityModifier extends RepositorySecurityModifier<AdaptingRepository> {
  @override
  String? getPath(AdaptingRepository repository) {
    return repository.rootPath;
  }

  @override
  RepositorySecurity? getSecurity(AdaptingRepository repository) {
    return null;
  }
}
