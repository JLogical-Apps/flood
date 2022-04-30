import '../../property/field_property.dart';
import '../../property/property.dart';
import '../../record/value_object.dart';

class VersionUsage extends ValueObject {
  late final versionProperty = FieldProperty<int>(name: 'version');

  @override
  List<Property> get properties => super.properties + [versionProperty];
}
