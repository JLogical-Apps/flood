import 'package:jlogical_utils/src/pond/context/module/app_module.dart';
import 'package:jlogical_utils/src/pond/modules/config/config_module.dart';
import 'package:jlogical_utils/src/pond/type_state_serializers/bool_type_state_serializer.dart';
import 'package:jlogical_utils/src/pond/type_state_serializers/date_time_type_state_serializer.dart';
import 'package:jlogical_utils/src/pond/type_state_serializers/double_type_state_serializer.dart';
import 'package:jlogical_utils/src/pond/type_state_serializers/int_type_state_serializer.dart';
import 'package:jlogical_utils/src/pond/type_state_serializers/nullable_type_state_serializer.dart';
import 'package:jlogical_utils/src/pond/type_state_serializers/string_type_state_serializer.dart';
import 'package:jlogical_utils/src/pond/type_state_serializers/type_state_serializer.dart';

import '../context/registration/app_registration.dart';
import 'environment/environment_module.dart';
import 'logging/default_logging_module.dart';

class CoreModule extends AppModule {
  @override
  List<TypeStateSerializer> get typeStateSerializers => [
        ..._coreTypeStateSerializers,
        ..._nullableCoreTypeStateSerializers,
      ];

  Future<void> initialize(AppRegistration registration) async {
    registration.register(await ConfigModule.create());
    registration.register(await EnvironmentModule.create());
    registration.register(DefaultLoggingModule());
    registration.register(this);
  }

  static List<TypeStateSerializer> get _coreTypeStateSerializers => [
        IntTypeStateSerializer(),
        DoubleTypeStateSerializer(),
        StringTypeStateSerializer(),
        BoolTypeStateSerializer(),
        DateTimeTypeStateSerializer(),
      ];

  static List<TypeStateSerializer> get _nullableCoreTypeStateSerializers => [
        NullableTypeStateSerializer<int?>(IntTypeStateSerializer()),
        NullableTypeStateSerializer<double?>(DoubleTypeStateSerializer()),
        NullableTypeStateSerializer<String?>(StringTypeStateSerializer()),
        NullableTypeStateSerializer<bool?>(BoolTypeStateSerializer()),
        NullableTypeStateSerializer<DateTime?>(DateTimeTypeStateSerializer()),
      ];
}
