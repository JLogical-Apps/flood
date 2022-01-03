import 'package:jlogical_utils/src/pond/export.dart';

import 'color.dart';

class Palette extends ValueObject {
  late final colorsProperty = ListFieldProperty<Color>(name: 'colors');

  @override
  List<Property> get properties => [colorsProperty];
}
