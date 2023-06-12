import 'package:drop_core/drop_core.dart';

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
  final FlutterFileRepository repository;

  FlutterFileRepositoryQueryExecutor({required this.repository});

  @override
  RepositoryQueryExecutor get queryExecutor {
    throw UnimplementedError();
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
