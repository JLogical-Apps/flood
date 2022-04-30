import '../../context/module/app_module.dart';
import '../../context/registration/value_object_registration.dart';
import 'command_parameter_stub.dart';
import 'command_stub.dart';

class CommandModule extends AppModule {
  @override
  List<ValueObjectRegistration> get valueObjectRegistrations => [
        ValueObjectRegistration<CommandStub, CommandStub?>(() => CommandStub()),
        ValueObjectRegistration<CommandParameterStub, CommandParameterStub?>(() => CommandParameterStub()),
      ];
}
