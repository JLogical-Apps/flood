import 'package:jlogical_utils/src/pond/export.dart';

import 'envelope_entity.dart';

class Transaction extends ValueObject {
  late final ReferenceProperty<EnvelopeEntity> envelopeProperty = ReferenceProperty(name: 'envelope');

  @override
  List<Property> get properties => [envelopeProperty];
}
