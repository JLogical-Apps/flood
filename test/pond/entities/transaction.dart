import 'package:jlogical_utils/src/pond/export.dart';

import 'envelope_entity.dart';

class EnvelopeTransaction extends ValueObject {
  late final ReferenceFieldProperty<EnvelopeEntity> envelopeProperty = ReferenceFieldProperty(name: 'envelope');

  @override
  List<Property> get properties => [envelopeProperty];
}
