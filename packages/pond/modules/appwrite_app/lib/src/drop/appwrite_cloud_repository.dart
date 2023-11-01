import 'package:appwrite_app/src/drop/appwrite_cloud_repository_query_executor.dart';
import 'package:appwrite_app/src/drop/appwrite_cloud_repository_state_handler.dart';
import 'package:drop_core/drop_core.dart';

class AppwriteCloudRepository with IsRepositoryWrapper {
  static final String defaultDatabaseId = 'default';

  final CloudRepository cloudRepository;

  AppwriteCloudRepository({required this.cloudRepository});

  String get rootPath => cloudRepository.rootPath;

  @override
  late final RepositoryQueryExecutor queryExecutor = AppwriteCloudRepositoryQueryExecutor(repository: this);

  @override
  late final RepositoryStateHandler stateHandler =
      AppwriteCloudRepositoryStateHandler(repository: this).withEntityLifecycle(context.dropCoreComponent);

  @override
  Repository get repository => cloudRepository.childRepository;
}
