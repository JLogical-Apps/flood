import 'package:drop_core/drop_core.dart';

class FirebaseCloudRepository with IsRepository {
  final CloudRepository cloudRepository;

  FirebaseCloudRepository({required this.cloudRepository});

  @override
  late final RepositoryQueryExecutor queryExecutor = FirebaseCloudRepositoryQueryExecutor(repository: this);

  @override
  late final RepositoryStateHandler stateHandler =
      FirebaseCloudRepositoryStateHandler(repository: this).withEntityLifecycle(context.coreDropComponent);
}

class FirebaseCloudRepositoryQueryExecutor with IsRepositoryQueryExecutorWrapper {
  final FirebaseCloudRepository repository;

  FirebaseCloudRepositoryQueryExecutor({required this.repository});

  @override
  RepositoryQueryExecutor get queryExecutor {
    throw UnimplementedError();
  }
}

class FirebaseCloudRepositoryStateHandler implements RepositoryStateHandler {
  final FirebaseCloudRepository repository;

  FirebaseCloudRepositoryStateHandler({required this.repository});

  @override
  Future<State> onUpdate(State state) async {
    throw UnimplementedError();
  }

  @override
  Future<State> onDelete(State state) async {
    throw UnimplementedError();
  }
}
