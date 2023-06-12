import 'package:drop_core/src/core_drop_component.dart';
import 'package:drop_core/src/repository/blank_repository.dart';
import 'package:drop_core/src/repository/repository.dart';
import 'package:utils_core/utils_core.dart';

class CloudRepository with IsRepositoryWrapper {
  final String rootPath;

  CloudRepository({required this.rootPath});

  @override
  late final Repository repository =
      context.locate<CoreDropComponent>().getImplementationOrNull(this) ?? BlankRepository();
}
