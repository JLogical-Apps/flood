import 'package:drop_core/src/repository/file_repository.dart';
import 'package:drop_core/src/repository/meta/repository_meta_modifier.dart';

class FileRepositoryMetaModifier extends WrapperRepositoryMetaModifier<FileRepository> {
  @override
  String? getPath(FileRepository repository) {
    return repository.rootPath;
  }
}
