import 'package:jlogical_utils/src/pond/context/app_context.dart';
import 'package:jlogical_utils/src/pond/context/registration/app_registration.dart';
import 'package:jlogical_utils/src/pond/context/registration/entity_registration.dart';
import 'package:jlogical_utils/src/pond/context/registration/value_object_registration.dart';
import 'package:jlogical_utils/src/pond/type_state_serializers/type_state_serializer.dart';

abstract class AppModule {
  List<EntityRegistration> get entityRegistrations => [];

  List<ValueObjectRegistration> get valueObjectRegistrations => [];

  List<TypeStateSerializer> get typeStateSerializers => [];

  List get navigatorObservers => [];

  void onRegister(AppRegistration registration) {}

  /// Loads during the native_splash screen.
  Future<void> onLoad(AppContext appContext) async {}

  /// Called when the app is "force-reset".
  Future<void> onReset(AppContext appContext) async {}

  /// The app module to register.
  /// Replacing this will register [registerTarget] instead of this.
  /// If [null], then no module will be registered.
  AppModule? get registerTarget => this;

  /// The type of the module to register.
  /// Replacing this will register [registerTarget] with [registerTargetType] as its key.
  /// If [null], then will use the [registerTarget]'s runtime type.
  Type? get registerTargetType => null;
}
