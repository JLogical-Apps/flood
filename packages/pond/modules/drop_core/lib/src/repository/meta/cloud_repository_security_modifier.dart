import 'package:drop_core/src/repository/cloud_repository.dart';
import 'package:drop_core/src/repository/meta/repository_meta_modifier.dart';

class CloudRepositoryMetaModifier extends WrapperRepositoryMetaModifier<CloudRepository> {
  @override
  String? getPath(CloudRepository repository) {
    return repository.rootPath;
  }
}
