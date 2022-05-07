import 'package:jlogical_utils/jlogical_utils.dart';

import 'color.dart';

class PaletteStats extends ValueObject {
  late final colorUses = MapFieldProperty<Color, int>(name: 'colorUses');

  @override
  List<Property> get properties => [colorUses];
}
