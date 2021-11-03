import 'package:jlogical_utils/src/pond/export.dart';

import 'color.dart';

class Palette extends Entity {
  late final ListProperty<Color> colorsProperty = ListProperty(name: 'colors');

  @override
  List<Property> get properties => [colorsProperty];
}
