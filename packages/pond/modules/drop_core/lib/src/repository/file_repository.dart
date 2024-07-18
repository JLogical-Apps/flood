import 'package:collection/collection.dart';
import 'package:drop_core/src/context/core_pond_context_extensions.dart';
import 'package:drop_core/src/repository/query_executor/state_query_executor.dart';
import 'package:drop_core/src/repository/repository.dart';
import 'package:drop_core/src/repository/repository_query_executor.dart';
import 'package:drop_core/src/repository/repository_state_handler.dart';
import 'package:drop_core/src/state/persistence/state_persister.dart';
import 'package:drop_core/src/state/state.dart';
import 'package:environment_core/environment_core.dart';
import 'package:persistence_core/persistence_core.dart';
import 'package:pond_core/pond_core.dart';
import 'package:pool/pool.dart';
import 'package:rxdart/rxdart.dart';
import 'package:utils_core/utils_core.dart';

class FileRepository with IsRepositoryWrapper {
  final String rootPath;

  @override
  final Repository repository;

  FileRepository({required this.rootPath, required this.repository});

  CrossDirectory get directory => context.fileSystem.storageDirectory / rootPath;

  @override
  late final List<CorePondComponentBehavior> behaviors = super.behaviors +
      [
        CorePondComponentBehavior(
          onReset: (context, _) async {
            if (await directory.exists()) {
              await directory.delete();
            }
          },
        ),
      ];

  @override
  late final RepositoryQueryExecutor queryExecutor = FileRepositoryQueryExecutor(repository: this);

  @override
  late final RepositoryStateHandler stateHandler = FileRepositoryStateHandler(repository: this);
}

class FileRepositoryQueryExecutor with IsRepositoryQueryExecutorWrapper {
  static const maxFilesOpen = 30;
  static Pool filePool = Pool(maxFilesOpen, timeout: Duration(seconds: 30));

  final FileRepository repository;

  FileRepositoryQueryExecutor({required this.repository});

  @override
  late final RepositoryQueryExecutor queryExecutor = _getQueryExecutor();

  late StatePersister<String> statePersister = StatePersister.jsonString(context: repository.context.dropCoreComponent);

  RepositoryQueryExecutor _getQueryExecutor() {
    return StateQueryExecutor(
      maybeStatesX: DataSource.static
          .crossDirectory(repository.directory)
          .getX()
          .map((fileEntities) => (fileEntities ?? []).whereType<CrossFile>())
          .asyncMap<FutureValue<List<State>>>((files) async {
            final states = await Future.wait(files.map(getStateFromFile));
            return FutureValue.loaded(states.sortedBy((state) => state.id!));
          })
          .publishValueSeeded(FutureValue.loading())
          .autoConnect(),
      statesGetter: () async {
        final crossElements = (await DataSource.static.crossDirectory(repository.directory).getOrNull()) ?? [];

        final crossFiles = crossElements.whereType<CrossFile>();
        final states = await Future.wait(crossFiles.map(getStateFromFile));
        return states.sortedBy((state) => state.id!);
      },
      dropContext: repository.context.dropCoreComponent,
    );
  }

  Future<State> getStateFromFile(CrossFile file) async {
    return await filePool.withResource(() async {
      try {
        final rawJson = await file.readAsString();
        final state = statePersister.inflate(rawJson);
        return state;
      } catch (e) {
        print('Error loading ${file.path}');
        rethrow;
      }
    });
  }
}

class FileRepositoryStateHandler implements RepositoryStateHandler {
  final FileRepository repository;

  FileRepositoryStateHandler({required this.repository});

  late StatePersister<String> statePersister = StatePersister.jsonString(context: repository.context.dropCoreComponent);

  @override
  Future<State> onUpdate(State state) async {
    final file = repository.directory - '${state.id}.json';
    await file.ensureCreated();

    final persistedJson = statePersister.persist(state);
    await file.writeAsString(persistedJson);
    state = statePersister.inflate(persistedJson);

    return state;
  }

  @override
  Future<State> onDelete(State state) async {
    final file = repository.directory - '${state.id}.json';
    await file.delete();

    return state;
  }
}
