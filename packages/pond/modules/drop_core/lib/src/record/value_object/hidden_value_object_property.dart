import 'package:drop_core/drop_core.dart';

class HiddenValueObjectProperty<G, S, L> with IsValueObjectPropertyWrapper<G, S, L> {
  @override
  final ValueObjectProperty<G, S, L> property;

  final bool Function()? isHiddenGetter;

  HiddenValueObjectProperty({required this.property, required this.isHiddenGetter});

  bool get isHidden => isHiddenGetter?.call() ?? true;
}
