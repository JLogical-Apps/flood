import 'package:jlogical_utils/jlogical_utils.dart';
import 'package:jlogical_utils/src/pond/modules/command/command_stub.dart';

import 'command_parameter_stub.dart';

class CommandModule extends AppModule {
  @override
  List<ValueObjectRegistration> get valueObjectRegistrations => [
        ValueObjectRegistration<CommandStub, CommandStub?>(() => CommandStub()),
        ValueObjectRegistration<CommandParameterStub, CommandParameterStub?>(() => CommandParameterStub()),
      ];
}
