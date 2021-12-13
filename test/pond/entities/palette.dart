import 'package:jlogical_utils/src/pond/export.dart';

import 'color.dart';

class Palette extends ValueObject {
  late final ListFieldProperty<Color> colorsProperty = ListFieldProperty(name: 'colors');

  @override
  List<Property> get properties => [colorsProperty];
}
