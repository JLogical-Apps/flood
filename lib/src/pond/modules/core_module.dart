import 'package:jlogical_utils/src/pond/context/module/app_module.dart';
import 'package:jlogical_utils/src/pond/modules/logging/default_logging_module.dart';
import 'package:jlogical_utils/src/pond/context/registration/app_registration.dart';
import 'package:jlogical_utils/src/pond/record/value_object.dart';
import 'package:jlogical_utils/src/pond/type_state_serializers/bool_type_state_serializer.dart';
import 'package:jlogical_utils/src/pond/type_state_serializers/date_time_type_state_serializer.dart';
import 'package:jlogical_utils/src/pond/type_state_serializers/double_type_state_serializer.dart';
import 'package:jlogical_utils/src/pond/type_state_serializers/dynamic_type_state_serializer.dart';
import 'package:jlogical_utils/src/pond/type_state_serializers/int_type_state_serializer.dart';
import 'package:jlogical_utils/src/pond/type_state_serializers/list_type_state_serializer.dart';
import 'package:jlogical_utils/src/pond/type_state_serializers/map_type_state_serializer.dart';
import 'package:jlogical_utils/src/pond/type_state_serializers/nullable_type_state_serializer.dart';
import 'package:jlogical_utils/src/pond/type_state_serializers/string_type_state_serializer.dart';
import 'package:jlogical_utils/src/pond/type_state_serializers/type_state_serializer.dart';
import 'package:jlogical_utils/src/pond/type_state_serializers/value_object_type_state_serializer.dart';

class CoreModule extends AppModule {
  @override
  late final List<TypeStateSerializer> typeStateSerializers = [
    ..._coreTypeStateSerializers,
    ..._nullableCoreTypeStateSerializers,
  ];

  void onRegister(AppRegistration registration) {
    registration.register(DefaultLoggingModule());
  }

  static List<TypeStateSerializer> get _coreTypeStateSerializers => [
        IntTypeStateSerializer(),
        DoubleTypeStateSerializer(),
        StringTypeStateSerializer(),
        BoolTypeStateSerializer(),
        DateTimeTypeStateSerializer(),
        ListTypeStateSerializer(),
        MapTypeStateSerializer(),
        ValueObjectTypeStateSerializer(),
        DynamicTypeStateSerializer(),
      ];

  static List<TypeStateSerializer> get _nullableCoreTypeStateSerializers => [
        NullableTypeStateSerializer<int?>(IntTypeStateSerializer()),
        NullableTypeStateSerializer<double?>(DoubleTypeStateSerializer()),
        NullableTypeStateSerializer<String?>(StringTypeStateSerializer()),
        NullableTypeStateSerializer<bool?>(BoolTypeStateSerializer()),
        NullableTypeStateSerializer<DateTime?>(DateTimeTypeStateSerializer()),
        NullableTypeStateSerializer<ValueObject?>(ValueObjectTypeStateSerializer()),
        NullableTypeStateSerializer<List?>(ListTypeStateSerializer()),
        NullableTypeStateSerializer<Map?>(MapTypeStateSerializer()),
      ];
}
