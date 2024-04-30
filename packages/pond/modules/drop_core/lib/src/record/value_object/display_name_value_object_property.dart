import 'package:drop_core/drop_core.dart';

class DisplayNameValueObjectProperty<G, S>
    with IsValueObjectPropertyWrapper<G, S, DisplayNameValueObjectProperty<G, S>> {
  @override
  final ValueObjectProperty<G, S, dynamic> property;

  final String? Function() displayNameGetter;

  DisplayNameValueObjectProperty({required this.property, required this.displayNameGetter});

  @override
  DisplayNameValueObjectProperty<G, S> copy() {
    return DisplayNameValueObjectProperty<G, S>(property: property.copy(), displayNameGetter: displayNameGetter);
  }
}
