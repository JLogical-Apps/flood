import 'package:jlogical_utils/jlogical_utils.dart';

class Color extends ValueObject {
  late final rgbProperty = MapFieldProperty<String, int>(name: 'rgb').required();

  @override
  List<Property> get properties => [rgbProperty];
}
