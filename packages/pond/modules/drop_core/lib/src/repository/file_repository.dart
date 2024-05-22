import 'package:drop_core/src/drop_core_component.dart';
import 'package:drop_core/src/repository/repository.dart';
import 'package:environment_core/environment_core.dart';
import 'package:persistence_core/persistence_core.dart';
import 'package:utils_core/utils_core.dart';

class FileRepository with IsRepositoryWrapper {
  final String rootPath;
  final Repository childRepository;

  FileRepository({required this.rootPath, required this.childRepository});

  CrossDirectory get directory => context.fileSystem.storageDirectory / rootPath;

  @override
  late final Repository repository =
      context.locate<DropCoreComponent>().getImplementationOrNull(this) ?? childRepository;
}
