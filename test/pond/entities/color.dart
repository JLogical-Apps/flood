import 'package:jlogical_utils/src/pond/export.dart';
import 'package:jlogical_utils/src/pond/value_object/value_object.dart';

class Color extends ValueObject {
  late final MapProperty<String, int> rgbProperty = MapProperty(name: 'rgb');

  @override
  List<Property> get properties => [rgbProperty];
}
