import 'package:jlogical_utils/src/port/model/port_component.dart';

abstract class PortValueComponent<V> extends PortComponent {
  String get name;

  V get initialValue;
}
