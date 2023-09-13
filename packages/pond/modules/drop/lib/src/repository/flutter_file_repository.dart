import 'package:drop_core/drop_core.dart';
import 'package:persistence/persistence.dart';
import 'package:pond/pond.dart';
import 'package:pool/pool.dart';
import 'package:rxdart/rxdart.dart';
import 'package:utils/utils.dart';

class FlutterFileRepository with IsRepositoryWrapper {
  final FileRepository fileRepository;

  FlutterFileRepository({required this.fileRepository});

  @override
  late final List<CorePondComponentBehavior> behaviors = super.behaviors +
      [
        CorePondComponentBehavior(
          onReset: (context, _) async {
            if (await fileRepository.directory.exists()) {
              await fileRepository.directory.delete();
            }
          },
        ),
      ];

  @override
  late final RepositoryQueryExecutor queryExecutor = FlutterFileRepositoryQueryExecutor(repository: this);

  @override
  late final RepositoryStateHandler stateHandler =
      FlutterFileRepositoryStateHandler(repository: this).withEntityLifecycle(context.dropCoreComponent);

  @override
  Repository get repository => fileRepository.childRepository;
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
          .crossDirectory(repository.fileRepository.directory)
          .getX()
          .map((fileEntities) => (fileEntities ?? []).whereType<CrossFile>())
          .asyncMap<FutureValue<List<State>>>(
              (files) async => FutureValue.loaded(await Future.wait(files.map(getStateFromFile))))
          .publishValueSeeded(FutureValue.loading())
          .autoConnect(),
      statesGetter: () async {
        final crossElements = (await DataSource.static.crossDirectory(repository.fileRepository.directory).getOrNull()) ?? [];

        final crossFiles = crossElements.whereType<CrossFile>();
        final states = await Future.wait(crossFiles.map(getStateFromFile));
        return states;
      },
      dropContext: repository.context.dropCoreComponent,
    );
  }

  Future<State> getStateFromFile(CrossFile file) async {
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

  @override
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
