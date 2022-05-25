import 'package:jlogical_utils/src/pond/property/modifier/property_modifier.dart';

class ListenerPropertyModifier<T> extends PropertyModifier<T> {
  final void Function(T value) listener;

  ListenerPropertyModifier(this.listener);

  @override
  void Function(T propertyValue)? get setTransformer => listener;
}
