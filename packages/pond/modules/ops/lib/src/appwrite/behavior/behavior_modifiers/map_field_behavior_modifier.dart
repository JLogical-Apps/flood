import 'package:appwrite_core/appwrite_core.dart';
import 'package:drop_core/drop_core.dart';
import 'package:ops/src/appwrite/behavior/appwrite_attribute_behavior_modifier.dart';

class MapFieldBehaviorModifier extends AppwriteAttributeBehaviorModifier<MapValueObjectProperty> {
  @override
  String getType(MapValueObjectProperty behavior) {
    return 'string';
  }

  @override
  int? getSize(MapValueObjectProperty behavior) {
    return AppwriteConsts.longTextSize;
  }
}
