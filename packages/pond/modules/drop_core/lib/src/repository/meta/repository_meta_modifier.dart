import 'package:drop_core/drop_core.dart';
import 'package:drop_core/src/repository/meta/cloud_repository_security_modifier.dart';
import 'package:drop_core/src/repository/meta/file_repository_security_modifier.dart';
import 'package:drop_core/src/repository/meta/for_abstract_type_repository_security_modifier.dart';
import 'package:drop_core/src/repository/meta/for_any_repository_security_modifier.dart';
import 'package:drop_core/src/repository/meta/for_type_repository_security_modifier.dart';
import 'package:drop_core/src/repository/meta/security_repository_security_modifier.dart';
import 'package:utils_core/utils_core.dart';

abstract class RepositoryMetaModifier<R extends Repository> with IsTypedModifier<R, Repository> {
  String? getPath(R repository);

  RepositorySecurity? getSecurity(R repository);

  Type? getEntityType(R repository);

  static final repositoryPathModifierResolver = ModifierResolver<RepositoryMetaModifier, Repository>(modifiers: [
    CloudRepositoryMetaModifier(),
    FileRepositoryMetaModifier(),
    SecurityRepositoryMetaModifier(),
    ForAnyRepositoryMetaModifier(),
    ForTypeRepositoryMetaModifier(),
    ForAbstractTypeRepositoryMetaModifier(),
    WrapperRepositoryMetaModifier(),
  ]);

  static RepositoryMetaModifier? getModifierOrNull(Repository repository) {
    return repositoryPathModifierResolver.resolveOrNull(repository);
  }

  static RepositoryMetaModifier getModifier(Repository repository) {
    return getModifierOrNull(repository) ??
        (throw Exception('Could not find security modifier for repository [$repository]!'));
  }
}

class WrapperRepositoryMetaModifier<R extends RepositoryWrapper> extends RepositoryMetaModifier<R> {
  @override
  String? getPath(R repository) {
    final subRepository = repository.repository;
    return RepositoryMetaModifier.getModifier(subRepository).getPath(subRepository);
  }

  @override
  RepositorySecurity? getSecurity(R repository) {
    final subRepository = repository.repository;
    return RepositoryMetaModifier.getModifier(subRepository).getSecurity(subRepository);
  }

  @override
  Type? getEntityType(R repository) {
    final subRepository = repository.repository;
    return RepositoryMetaModifier.getModifier(subRepository).getEntityType(subRepository);
  }
}
