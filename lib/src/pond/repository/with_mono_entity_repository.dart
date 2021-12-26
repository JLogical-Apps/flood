import 'package:jlogical_utils/jlogical_utils.dart';

mixin WithMonoEntityRepository<E extends Entity> on EntityRepository {
  @override
  List<Type> get handledEntityTypes => [E];
}
