import 'package:jlogical_utils/jlogical_utils.dart';

class VersionUsage extends ValueObject {
  late final versionProperty = FieldProperty<int>(name: 'version');

  @override
  List<Property> get properties => super.properties + [versionProperty];
}
