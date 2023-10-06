import 'package:drop_core/drop_core.dart';
import 'package:ops/src/appwrite/behavior/appwrite_attribute_behavior_modifier.dart';
import 'package:ops/src/appwrite/util/appwrite_consts.dart';

class StringFieldBehaviorModifier
    extends AppwriteAttributeBehaviorModifier<SimpleValueObjectProperty<String?>> {
  @override
  String getType(SimpleValueObjectProperty<String?> behavior) {
    return 'string';
  }

  @override
  int? getSize(SimpleValueObjectProperty<String?> behavior) {
    return AppwriteConsts.mediumTextSize;
  }
}
