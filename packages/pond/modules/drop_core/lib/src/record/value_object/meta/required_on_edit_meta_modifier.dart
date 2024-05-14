import 'package:drop_core/drop_core.dart';

class RequiredOnEditMetaModifier extends WrapperBehaviorMetaModifier<RequiredOnEditValueObjectProperty> {
  @override
  bool isRequiredOnEdit(RequiredOnEditValueObjectProperty behavior) {
    return behavior.requiredOnEdit;
  }
}
