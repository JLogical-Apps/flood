import 'package:jlogical_utils/jlogical_utils.dart';

import 'envelope_entity.dart';

class EnvelopeTransaction extends ValueObject {
  late final envelopeProperty = ReferenceFieldProperty<EnvelopeEntity>(name: 'envelope');

  @override
  List<Property> get properties => [envelopeProperty];
}
