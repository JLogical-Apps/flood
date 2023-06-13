import 'dart:io';

import 'package:drop_core/drop_core.dart';
import 'package:environment/environment.dart';
import 'package:path/path.dart' as path;
import 'package:persistence/persistence.dart';
import 'package:pool/pool.dart';
import 'package:rxdart/rxdart.dart';
import 'package:utils/utils.dart';

class FlutterFileRepository with IsRepository {
  final FileRepository fileRepository;

  FlutterFileRepository({required this.fileRepository});

  @override
  late final RepositoryQueryExecutor queryExecutor = FlutterFileRepositoryQueryExecutor(repository: this);

  @override
  late final RepositoryStateHandler stateHandler =
      FlutterFileRepositoryStateHandler(repository: this).withEntityLifecycle(context.coreDropComponent);
}

class FlutterFileRepositoryQueryExecutor with IsRepositoryQueryExecutorWrapper {
  static const maxFilesOpen = 30;
  static Pool filePool = Pool(maxFilesOpen, timeout: Duration(seconds: 30));

  final FlutterFileRepository repository;

  FlutterFileRepositoryQueryExecutor({required this.repository});

  Directory get directory => repository.context.fileSystem.storageDirectory / repository.fileRepository.rootPath;

  @override
  late final RepositoryQueryExecutor queryExecutor = _getQueryExecutor();

  RepositoryQueryExecutor _getQueryExecutor() {
    return StateQueryExecutor(
      maybeStatesX: DataSource.static
          .directory(directory)
          .getX()
          .map((fileEntities) => (fileEntities ?? []).whereType<File>())
          .asyncMap<FutureValue<List<State>>>(
              (files) async => FutureValue.loaded(await Future.wait(files.map(getStateFromFile))))
          .publishValueSeeded(FutureValue.loading())
          .autoConnect(),
      dropContext: repository.context.coreDropComponent,
    );
  }

  Future<State> getStateFromFile(File file) async {
    return State(
      id: path.basenameWithoutExtension(file.path),
      data: await filePool.withResource(() => file.readJson()),
    );
  }
}

class FlutterFileRepositoryStateHandler implements RepositoryStateHandler {
  final FlutterFileRepository repository;

  FlutterFileRepositoryStateHandler({required this.repository});

  @override
  Future<State> onUpdate(State state) async {
    throw UnimplementedError();
  }

  @override
  Future<State> onDelete(State state) async {
    throw UnimplementedError();
  }
}
