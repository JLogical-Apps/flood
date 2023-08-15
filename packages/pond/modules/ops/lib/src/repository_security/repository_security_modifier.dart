import 'package:drop_core/drop_core.dart';
import 'package:ops/src/repository_security/adapting_repository_security_modifier.dart';
import 'package:ops/src/repository_security/cloud_repository_security_modifier.dart';
import 'package:ops/src/repository_security/security_repository_security_modifier.dart';
import 'package:ops/src/repository_security/wrapper_repository_security_modifier.dart';
import 'package:utils_core/utils_core.dart';

abstract class RepositorySecurityModifier<R extends Repository> with IsTypedModifier<R, Repository> {
  String? getPath(R repository);

  RepositorySecurity? getSecurity(R repository);

  static final repositoryPathModifierResolver = ModifierResolver<RepositorySecurityModifier, Repository>(modifiers: [
    CloudRepositorySecurityModifier(),
    AdaptingRepositorySecurityModifier(),
    SecurityRepositorySecurityModifier(modifierGetter: getModifierOrNull),
    WrapperRepositorySecurityModifier(modifierGetter: getModifierOrNull),
  ]);

  static RepositorySecurityModifier? getModifierOrNull(Repository repository) {
    return repositoryPathModifierResolver.resolveOrNull(repository);
  }

  static RepositorySecurityModifier getModifier(Repository repository) {
    return getModifierOrNull(repository) ??
        (throw Exception('Could not find security modifier for repository [$repository]!'));
  }
}
