import 'package:jlogical_utils/src/pond/export.dart';

import 'envelope.dart';

class Transaction extends Entity with WithIdPropertiesState {
  late final ReferenceProperty<Envelope> envelopeProperty = ReferenceProperty(name: 'envelope');

  @override
  List<Property> get properties => [envelopeProperty];
}
