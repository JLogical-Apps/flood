import 'dart:async';

import 'package:jlogical_utils/jlogical_utils.dart';

abstract class Singleton {
  static Future<E> getOrCreate<E extends Entity<V>, V extends ValueObject>({
    FutureOr Function(E entity)? beforeCreate,
  }) async {
    final entities = await Query.from<E>().all().get();
    if (entities.isNotEmpty) {
      if (entities.length > 1) {
        throw Exception('More than one instance of a Singleton of $E');
      }

      return entities[0];
    }

    final value = AppContext.global.constructValueObject<V>();
    final entity = AppContext.global.constructEntity<E, V>(value);

    await beforeCreate?.call(entity);
    await entity.create();

    return entity;
  }
}
