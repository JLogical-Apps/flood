import 'package:jlogical_utils/src/pond/utils/resolvable.dart';

import 'entity.dart';

abstract class Aggregate<E extends Entity> implements Resolvable {
  late final E entity;

  List<Resolvable> get resolvables => [];

  Future<void> resolve() {
    return Future.wait(resolvables.map((resolvable) => resolvable.resolve()));
  }
}
