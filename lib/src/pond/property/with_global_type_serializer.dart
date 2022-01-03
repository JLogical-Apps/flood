import 'package:jlogical_utils/src/pond/context/app_context.dart';
import 'package:jlogical_utils/src/pond/context/registration/app_registration.dart';
import 'package:jlogical_utils/src/pond/property/property.dart';
import 'package:jlogical_utils/src/pond/type_state_serializers/type_state_serializer.dart';

mixin WithGlobalTypeSerializer<T> on Property<T> {
  TypeStateSerializer get typeStateSerializer => AppContext.global.getTypeStateSerializerByType<T>();
}
