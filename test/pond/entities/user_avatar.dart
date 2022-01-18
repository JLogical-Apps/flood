import 'package:jlogical_utils/src/pond/export.dart';

import 'color.dart';

class UserAvatar extends ValueObject {
  late final colorProperty = FieldProperty<Color>(name: 'color');

  @override
  List<Property> get properties => [colorProperty];
}