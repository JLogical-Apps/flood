import '../record/entity.dart';
import 'entity_repository.dart';

mixin WithMonoEntityRepository<E extends Entity> on EntityRepository {
  @override
  List<Type> get handledEntityTypes => [E];
}
