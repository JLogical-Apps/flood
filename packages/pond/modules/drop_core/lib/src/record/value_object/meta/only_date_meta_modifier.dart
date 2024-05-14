import 'package:drop_core/drop_core.dart';

class OnlyDateMetaModifier extends WrapperBehaviorMetaModifier<OnlyDateValueObjectProperty> {
  @override
  bool isOnlyDate(OnlyDateValueObjectProperty behavior) {
    return behavior.onlyDate;
  }
}
