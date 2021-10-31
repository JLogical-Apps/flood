import 'package:jlogical_utils/src/pond/type_state_serializers/type_state_serializer.dart';
import 'package:jlogical_utils/src/pond/type_state_serializers/with_implicit_state_serializer.dart';

class StringTypeStateSerializer = TypeStateSerializer<String> with WithImplicitTypeSerializer;
