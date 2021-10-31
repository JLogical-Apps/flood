import 'package:jlogical_utils/src/pond/context/app_context.dart';
import 'package:jlogical_utils/src/pond/property/property.dart';
import 'package:jlogical_utils/src/pond/type_state_serializers/type_state_serializer.dart';
import 'package:jlogical_utils/src/utils/util.dart';

class ListProperty<T> extends Property<List<T>> {
  ListProperty({required String name, List<T>? initialValue}) : super(name: name, initialValue: initialValue);

  @override
  TypeStateSerializer<List<T>> get typeStateSerializer => ListTypeStateSerializer();
}

class ListTypeStateSerializer<T> extends TypeStateSerializer<List<T>> {
  final TypeStateSerializer<T> valueTypeStateSerializer = AppContext.global.getTypeStateSerializerByType<T>();

  @override
  dynamic onSerialize(List<T> value) {
    return value.map((element) => valueTypeStateSerializer.onSerialize(element)).toList();
  }

  @override
  List<T>? onDeserialize(dynamic value) {
    Object? object = value;

    return object
        ?.as<List>()
        .mapIfNonNull((list) => list.map((element) => valueTypeStateSerializer.onDeserialize(element)!).toList());
  }
}
