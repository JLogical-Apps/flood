import 'package:drop_core/drop_core.dart';

class HiddenValueObjectProperty<G, S, L>
    with IsValueObjectPropertyWrapper<G, S, L, HiddenValueObjectProperty<G, S, L>> {
  @override
  final ValueObjectProperty<G, S, L, dynamic> property;

  final bool Function()? isHiddenGetter;

  HiddenValueObjectProperty({required this.property, required this.isHiddenGetter});

  bool get isHidden => isHiddenGetter?.call() ?? true;

  @override
  HiddenValueObjectProperty<G, S, L> copy() {
    return HiddenValueObjectProperty<G, S, L>(property: property.copy(), isHiddenGetter: isHiddenGetter);
  }

  @override
  List<Object?> get props => [property];
}
