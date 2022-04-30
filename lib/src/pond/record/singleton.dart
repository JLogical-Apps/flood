import 'dart:async';

import 'package:jlogical_utils/src/pond/context/registration/app_registration.dart';
import 'package:jlogical_utils/src/pond/record/value_object.dart';

import '../context/app_context.dart';
import '../query/query.dart';
import 'entity.dart';

abstract class Singleton {
  /// Returns the default entity to be used if there is no existing singleton.
  static E createDefault<E extends Entity<V>, V extends ValueObject>() {
    final value = AppContext.global.constructValueObject<V>();
    final entity = AppContext.global.constructEntity<E, V>(value);

    return entity;
  }

  static Future<E> getOrCreate<E extends Entity<V>, V extends ValueObject>({
    FutureOr Function(E entity)? beforeCreate,
  }) async {
    final entities = await Query.from<E>().all().get();
    if (entities.isNotEmpty) {
      await Future.wait(entities.skip(1).map((entity) => entity.delete()));

      return entities[0];
    }

    final entity = createDefault<E, V>();

    await beforeCreate?.call(entity);
    await entity.create();

    return entity;
  }
}
