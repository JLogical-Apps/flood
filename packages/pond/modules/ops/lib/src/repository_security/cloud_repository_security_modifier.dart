import 'package:drop_core/drop_core.dart';
import 'package:ops/src/repository_security/repository_security_modifier.dart';

class CloudRepositorySecurityModifier extends RepositorySecurityModifier<CloudRepository> {
  @override
  String? getPath(CloudRepository repository) {
    return repository.rootPath;
  }

  @override
  RepositorySecurity? getSecurity(CloudRepository repository) {
    return null;
  }
}
