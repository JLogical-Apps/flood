import 'package:drop_core/src/repository/repository.dart';

abstract class RepositoryImplementation<T extends Repository> {
  Repository getImplementation(T prototype);

  Type get repositoryType;
}

mixin IsRepositoryImplementation<T extends Repository> implements RepositoryImplementation<T> {
  @override
  Type get repositoryType => T;
}
