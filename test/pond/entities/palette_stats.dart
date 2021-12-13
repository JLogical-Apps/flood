import 'package:jlogical_utils/src/pond/export.dart';

import 'color.dart';

class PaletteStats extends ValueObject {
  late final MapFieldProperty<Color, int> colorUses = MapFieldProperty(name: 'colorUses');

  @override
  List<Property> get properties => [colorUses];
}
