import 'package:collection/collection.dart';
import 'package:jlogical_utils/src/pond/entity/entity.dart';
import 'package:jlogical_utils/src/pond/type_state_serializers/int_type_state_serializer.dart';
import 'package:jlogical_utils/src/pond/type_state_serializers/string_type_state_serializer.dart';
import 'package:jlogical_utils/src/pond/type_state_serializers/type_state_serializer.dart';

class AppContext {
  static late AppContext global = AppContext(entityRegistrations: []);

  final List<EntityRegistration> entityRegistrations;
  final List<TypeStateSerializer> typeStateSerializers;

  AppContext({required this.entityRegistrations, List<TypeStateSerializer>? typeStateSerializers})
      : this.typeStateSerializers = typeStateSerializers ?? defaultTypeStateSerializers;

  E? constructEntity<E extends Entity>() {
    return entityRegistrations.firstWhereOrNull((registration) => registration.entityType == E)?.onCreate() as E?;
  }

  TypeStateSerializer<T> getTypeStateSerializerByType<T>() {
    return typeStateSerializers.firstWhere((typeStateSerializer) => typeStateSerializer.type == T)
        as TypeStateSerializer<T>;
  }

  static List<TypeStateSerializer> get defaultTypeStateSerializers => [
        IntTypeStateSerializer(),
        StringTypeStateSerializer(),
      ];
}

class EntityRegistration<E extends Entity> {
  final E Function() onCreate;

  const EntityRegistration(this.onCreate);

  Type get entityType => E;
}
