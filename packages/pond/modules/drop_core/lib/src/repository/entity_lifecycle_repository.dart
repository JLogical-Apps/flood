import 'package:drop_core/drop_core.dart';

class EntityLifecycleRepository with IsRepositoryWrapper {
  @override
  final Repository repository;

  EntityLifecycleRepository({required this.repository});

  @override
  RepositoryStateHandler get stateHandler => repository.stateHandler.withEntityLifecycle(context.dropCoreComponent);
}
