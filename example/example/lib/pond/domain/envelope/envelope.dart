import 'package:jlogical_utils/jlogical_utils.dart';

class Envelope extends ValueObject {
  late final nameProperty = FieldProperty<String>(name: 'name').required();

  @override
  List<Property> get properties => super.properties + [nameProperty];
}
