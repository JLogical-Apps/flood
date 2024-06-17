import 'package:drop_core/src/repository/adapting_repository.dart';
import 'package:drop_core/src/repository/meta/repository_meta_modifier.dart';

class AdaptingRepositoryMetaModifier extends WrapperRepositoryMetaModifier<AdaptingRepository> {
  @override
  String? getPath(AdaptingRepository repository) {
    return repository.rootPath;
  }
}
