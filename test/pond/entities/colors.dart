import 'package:jlogical_utils/src/pond/export.dart';

class Colors extends Entity {
  late final MapProperty<String, int> colorsProperty = MapProperty(name: 'colors');

  @override
  List<Property> get properties => [colorsProperty];
}
