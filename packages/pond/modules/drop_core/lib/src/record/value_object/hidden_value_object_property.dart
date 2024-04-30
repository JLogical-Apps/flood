import 'package:drop_core/drop_core.dart';

class HiddenValueObjectProperty<G, S> with IsValueObjectPropertyWrapper<G, S, HiddenValueObjectProperty<G, S>> {
  @override
  final ValueObjectProperty<G, S, dynamic> property;

  final bool Function()? isHiddenGetter;

  HiddenValueObjectProperty({required this.property, required this.isHiddenGetter});

  bool get isHidden => isHiddenGetter?.call() ?? true;

  @override
  HiddenValueObjectProperty<G, S> copy() {
    return HiddenValueObjectProperty<G, S>(property: property.copy(), isHiddenGetter: isHiddenGetter);
  }
}
