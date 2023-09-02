import 'package:drop/src/repository/flutter_file_repository.dart';
import 'package:drop_core/drop_core.dart';

class FlutterFileRepositoryImplementation with IsRepositoryImplementation<FileRepository> {
  @override
  Repository getImplementation(FileRepository prototype) {
    return FlutterFileRepository(fileRepository: prototype);
  }
}
