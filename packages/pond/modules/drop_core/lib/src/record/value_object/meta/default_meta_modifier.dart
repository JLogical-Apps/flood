import 'package:drop_core/drop_core.dart';

class DefaultMetaModifier extends WrapperBehaviorMetaModifier<DefaultValueObjectProperty> {
  @override
  dynamic getDefaultValue(DefaultValueObjectProperty behavior) {
    return behavior.getDefaultValue();
  }
}
