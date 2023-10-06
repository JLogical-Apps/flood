import 'package:drop_core/drop_core.dart';
import 'package:ops/src/appwrite/behavior/appwrite_attribute_behavior_modifier.dart';

class MapFieldBehaviorModifier extends AppwriteAttributeBehaviorModifier<MapValueObjectProperty> {
  @override
  String getType(MapValueObjectProperty behavior) {
    throw Exception('Map properties are currently not supported by Appwrite');
  }
}
