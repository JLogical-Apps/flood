import 'package:drop_core/drop_core.dart';

class RequiredMetaModifier extends WrapperBehaviorMetaModifier<RequiredValueObjectProperty> {
  @override
  bool isRequiredOnEdit(RequiredValueObjectProperty behavior) {
    return true;
  }
}
