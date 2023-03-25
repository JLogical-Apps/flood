import 'package:drop_core/drop_core.dart';

class DisplayNameValueObjectProperty<G, S, L> with IsValueObjectPropertyWrapper<G, S, L> {
  @override
  final ValueObjectProperty<G, S, L> property;

  final String? Function() displayNameGetter;

  DisplayNameValueObjectProperty({required this.property, required this.displayNameGetter});
}
