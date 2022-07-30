import 'package:jlogical_utils/jlogical_utils_core.dart';

class AssetMetadataRecord extends ValueObject {
  static const assetIdField = 'asset';
  late final assetIdProperty = FieldProperty<String>(name: assetIdField).required();

  @override
  List<Property> get properties => super.properties + [assetIdProperty];
}
