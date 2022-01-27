import 'package:jlogical_utils/src/pond/context/registration/app_registration.dart';
import 'package:jlogical_utils/src/pond/context/registration/entity_registration.dart';
import 'package:jlogical_utils/src/pond/context/registration/value_object_registration.dart';
import 'package:jlogical_utils/src/pond/type_state_serializers/type_state_serializer.dart';

abstract class AppModule {
  List<EntityRegistration> get entityRegistrations => [];
  List<ValueObjectRegistration> get valueObjectRegistrations => [];
  List<TypeStateSerializer> get typeStateSerializers => [];

  void onRegister(AppRegistration registration) {}

  /// Called when the app is "force-reset".
  Future<void> onReset() async {}

  /// Loads during the native_splash screen.
  Future<void> onLoad() async {}
}
