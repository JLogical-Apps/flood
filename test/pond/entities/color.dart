import 'package:jlogical_utils/src/pond/export.dart';

class Color extends ValueObject with WithPropertiesState {
  late final MapProperty<String, int> rgbProperty = MapProperty(name: 'rgb');

  @override
  List<Property> get properties => [rgbProperty];
}
