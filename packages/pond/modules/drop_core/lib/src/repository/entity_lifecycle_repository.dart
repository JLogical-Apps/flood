import 'package:drop_core/drop_core.dart';

class EntityLifecycleRepository with IsRepositoryWrapper {
  @override
  final Repository repository;

  EntityLifecycleRepository({required this.repository});

  @override
  late RepositoryStateHandler stateHandler =
      repository.stateHandler.withEntityStateLifecycle(context.dropCoreComponent);
}
