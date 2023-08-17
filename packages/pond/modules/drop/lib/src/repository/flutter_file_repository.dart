import 'dart:io';

import 'package:drop_core/drop_core.dart';
import 'package:persistence/persistence.dart';
import 'package:pond/pond.dart';
import 'package:pool/pool.dart';
import 'package:rxdart/rxdart.dart';
import 'package:utils/utils.dart';

class FlutterFileRepository with IsRepository {
  final FileRepository fileRepository;

  FlutterFileRepository({required this.fileRepository});

  @override
  late final List<CorePondComponentBehavior> behaviors = [
    CorePondComponentBehavior(
      onReset: (context, _) async {
        if (await fileRepository.directory.exists()) {
          await fileRepository.directory.delete(recursive: true);
        }
      },
    ),
  ];

  @override
  late final RepositoryQueryExecutor queryExecutor = FlutterFileRepositoryQueryExecutor(repository: this);

  @override
  late final RepositoryStateHandler stateHandler =
      FlutterFileRepositoryStateHandler(repository: this).withEntityLifecycle(context.dropCoreComponent);
}

class FlutterFileRepositoryQueryExecutor with IsRepositoryQueryExecutorWrapper {
  static const maxFilesOpen = 30;
  static Pool filePool = Pool(maxFilesOpen, timeout: Duration(seconds: 30));

  final FlutterFileRepository repository;

  FlutterFileRepositoryQueryExecutor({required this.repository});

  @override
  late final RepositoryQueryExecutor queryExecutor = _getQueryExecutor();

  late StatePersister<String> statePersister = StatePersister.jsonString(context: repository.context.dropCoreComponent);

  RepositoryQueryExecutor _getQueryExecutor() {
    return StateQueryExecutor(
      maybeStatesX: DataSource.static
          .directory(repository.fileRepository.directory)
          .getX()
          .map((fileEntities) => (fileEntities ?? []).whereType<File>())
          .asyncMap<FutureValue<List<State>>>(
              (files) async => FutureValue.loaded(await Future.wait(files.map(getStateFromFile))))
          .publishValueSeeded(FutureValue.loading())
          .autoConnect(),
      dropContext: repository.context.dropCoreComponent,
    );
  }

  Future<State> getStateFromFile(File file) async {
    return await filePool.withResource(() async {
      final rawJson = await file.readAsString();
      final state = statePersister.inflate(rawJson);
      return state;
    });
  }
}

class FlutterFileRepositoryStateHandler implements RepositoryStateHandler {
  final FlutterFileRepository repository;

  FlutterFileRepositoryStateHandler({required this.repository});

  late StatePersister<String> statePersister = StatePersister.jsonString(context: repository.context.dropCoreComponent);

  @override
  Future<State> onUpdate(State state) async {
    final file = repository.fileRepository.directory - '${state.id}.json';
    await file.ensureCreated();

    final persistedJson = statePersister.persist(state);
    await file.writeAsString(persistedJson);

    return state;
  }

  @override
  Future<State> onDelete(State state) async {
    final file = repository.fileRepository.directory - '${state.id}.json';
    await file.delete();

    return state;
  }
}
