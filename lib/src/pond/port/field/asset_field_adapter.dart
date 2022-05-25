import 'package:jlogical_utils/src/port/export_core.dart';
import 'package:jlogical_utils/src/port/model/fields/asset_port_field.dart';

import '../../modules/asset/asset_field_property.dart';
import 'abstract_field_adapter.dart';

class AssetFieldAdapter extends AbstractFieldAdapter<AssetFieldProperty, String?> {
  @override
  PortField<String?> toPortField(AssetFieldProperty property) {
    return AssetPortField(name: property.name, initialValue: property.getUnvalidated(), assetType: property.assetType);
  }
}
