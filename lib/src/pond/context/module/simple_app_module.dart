import 'package:jlogical_utils/src/pond/context/module/app_module.dart';
import 'package:jlogical_utils/src/pond/context/registration/entity_registration.dart';
import 'package:jlogical_utils/src/pond/context/registration/value_object_registration.dart';
import 'package:jlogical_utils/src/pond/type_state_serializers/type_state_serializer.dart';

class SimpleAppModule extends AppModule {
  @override
  final List<ValueObjectRegistration> valueObjectRegistrations;

  @override
  final List<EntityRegistration> entityRegistrations;

  @override
  final List<TypeStateSerializer> typeStateSerializers;

  SimpleAppModule({
    this.valueObjectRegistrations: const [],
    this.entityRegistrations: const [],
    this.typeStateSerializers: const [],
  });
}
