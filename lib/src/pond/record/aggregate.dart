import 'package:jlogical_utils/src/pond/context/app_context.dart';
import 'package:jlogical_utils/src/pond/utils/resolvable.dart';

import 'entity.dart';

abstract class Aggregate<E extends Entity> {
  late final E entity;

  Aggregate();

  List<Resolvable> get resolvables => [];

  Future<void> resolve() {
    final appContext = AppContext.global;
    return Future.wait(resolvables.map((resolvable) => resolvable.resolve(appContext)));
  }
}
