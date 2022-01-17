import 'package:jlogical_utils/src/pond/record/entity.dart';
import 'package:jlogical_utils/src/pond/record/value_object.dart';

class EntityRegistration<E extends Entity<V>, V extends ValueObject> {
  final E Function()? onCreate;

  const EntityRegistration(this.onCreate);

  const EntityRegistration.abstract() : onCreate = null;

  E create() => onCreate!();

  bool get isAbstract => onCreate == null;

  Type get entityType => E;

  Type get valueObjectType => V;
}
