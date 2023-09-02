import 'package:drop_core/src/drop_core_component.dart';
import 'package:drop_core/src/repository/blank_repository.dart';
import 'package:drop_core/src/repository/repository.dart';
import 'package:utils_core/utils_core.dart';

class CloudRepository with IsRepositoryWrapper {
  final String rootPath;
  final Repository childRepository;

  CloudRepository({required this.rootPath, required this.childRepository});

  @override
  late final Repository repository =
      context.locate<DropCoreComponent>().getImplementationOrNull(this) ?? BlankRepository(repository: childRepository);
}
