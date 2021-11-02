import 'package:jlogical_utils/src/pond/export.dart';

import 'color.dart';

class PaletteStats extends ValueObject with WithPropertiesState {
  late final MapProperty<Color, int> colorUses = MapProperty(name: 'colorUses');

  @override
  List<Property> get properties => [colorUses];
}
