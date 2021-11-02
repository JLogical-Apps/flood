import 'package:jlogical_utils/src/pond/export.dart';

import 'color.dart';

class UserAvatar extends ValueObject with WithPropertiesState {
  late final ValueObjectProperty<Color> colorProperty = ValueObjectProperty(name: 'color');

  @override
  List<Property> get properties => [colorProperty];
}
