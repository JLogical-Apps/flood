import 'package:drop_core/drop_core.dart';

class DisplayNameValueObjectProperty<G, S, L>
    with IsValueObjectPropertyWrapper<G, S, L, DisplayNameValueObjectProperty<G, S, L>> {
  @override
  final ValueObjectProperty<G, S, L, dynamic> property;

  final String? Function() displayNameGetter;

  DisplayNameValueObjectProperty({required this.property, required this.displayNameGetter});

  @override
  DisplayNameValueObjectProperty<G, S, L> copy() {
    return DisplayNameValueObjectProperty<G, S, L>(property: property.copy(), displayNameGetter: displayNameGetter);
  }
}
