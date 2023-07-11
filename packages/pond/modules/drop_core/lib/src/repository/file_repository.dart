import 'dart:io';

import 'package:drop_core/src/drop_core_component.dart';
import 'package:drop_core/src/repository/blank_repository.dart';
import 'package:drop_core/src/repository/repository.dart';
import 'package:environment_core/environment_core.dart';
import 'package:utils_core/utils_core.dart';

class FileRepository with IsRepositoryWrapper {
  final String rootPath;

  FileRepository({required this.rootPath});

  Directory get directory => context.fileSystem.storageDirectory / rootPath;

  @override
  late final Repository repository =
      context.locate<DropCoreComponent>().getImplementationOrNull(this) ?? BlankRepository();
}
