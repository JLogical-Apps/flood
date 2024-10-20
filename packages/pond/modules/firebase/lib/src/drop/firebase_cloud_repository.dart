import 'package:drop_core/drop_core.dart';
import 'package:firebase/src/drop/firebase_cloud_repository_query_executor.dart';
import 'package:firebase/src/drop/firebase_cloud_repository_state_handler.dart';

class FirebaseCloudRepository with IsRepositoryWrapper {
  final CloudRepository cloudRepository;

  FirebaseCloudRepository({required this.cloudRepository});

  String get rootPath => cloudRepository.rootPath;

  @override
  late final RepositoryQueryExecutor queryExecutor = FirebaseCloudRepositoryQueryExecutor(repository: this);

  @override
  late final RepositoryStateHandler stateHandler = FirebaseCloudRepositoryStateHandler(repository: this);

  @override
  Repository get repository => cloudRepository.childRepository;
}
