import 'package:drop_core/drop_core.dart';

class LabelValueObjectBehavior with IsValueObjectBehavior {
  @override
  late ValueObject valueObject;

  final String? Function() labelGetter;

  LabelValueObjectBehavior({required this.labelGetter});

  String? getLabel() {
    return labelGetter();
  }
}

extension LabelValueObjectExtensions on ValueObject {
  String? getLabel() {
    final explicitLabel = behaviors.whereType<LabelValueObjectBehavior>().firstOrNull?.getLabel();
    if (explicitLabel != null) {
      return explicitLabel;
    }

    final stringField = behaviors.whereType<ValueObjectProperty<String?, dynamic, dynamic>>().firstOrNull?.value;
    if (stringField != null) {
      return stringField;
    }

    final displayName = getDisplayName();
    if (displayName == null) {
      return displayName;
    }

    return null;
  }
}
