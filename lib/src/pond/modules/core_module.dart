import 'package:jlogical_utils/src/pond/context/module/app_module.dart';
import 'package:jlogical_utils/src/pond/context/registration/app_registration.dart';
import 'package:jlogical_utils/src/pond/modules/logging/default_logging_module.dart';
import 'package:jlogical_utils/src/pond/type_state_serializers/bool_type_state_serializer.dart';
import 'package:jlogical_utils/src/pond/type_state_serializers/date_time_type_state_serializer.dart';
import 'package:jlogical_utils/src/pond/type_state_serializers/double_type_state_serializer.dart';
import 'package:jlogical_utils/src/pond/type_state_serializers/dynamic_type_state_serializer.dart';
import 'package:jlogical_utils/src/pond/type_state_serializers/int_type_state_serializer.dart';
import 'package:jlogical_utils/src/pond/type_state_serializers/list_type_state_serializer.dart';
import 'package:jlogical_utils/src/pond/type_state_serializers/map_type_state_serializer.dart';
import 'package:jlogical_utils/src/pond/type_state_serializers/nullable_type_state_serializer_extension.dart';
import 'package:jlogical_utils/src/pond/type_state_serializers/string_type_state_serializer.dart';
import 'package:jlogical_utils/src/pond/type_state_serializers/type_state_serializer.dart';
import 'package:jlogical_utils/src/pond/type_state_serializers/value_object_type_state_serializer.dart';

class CoreModule extends AppModule {
  @override
  late final List<TypeStateSerializer> typeStateSerializers = [
    IntTypeStateSerializer(),
    IntTypeStateSerializer().asNullable(),
    DoubleTypeStateSerializer(),
    DoubleTypeStateSerializer().asNullable(),
    StringTypeStateSerializer(),
    StringTypeStateSerializer().asNullable(),
    BoolTypeStateSerializer(),
    BoolTypeStateSerializer().asNullable(),
    DateTimeTypeStateSerializer(),
    DateTimeTypeStateSerializer().asNullable(),
    ValueObjectTypeStateSerializer(),
    ValueObjectTypeStateSerializer().asNullable(),
    ListTypeStateSerializer(),
    ListTypeStateSerializer().asNullable(),
    MapTypeStateSerializer(),
    MapTypeStateSerializer().asNullable(),
    DynamicTypeStateSerializer(),
  ];

  void onRegister(AppRegistration registration) {
    registration.register(DefaultLoggingModule());
  }
}
