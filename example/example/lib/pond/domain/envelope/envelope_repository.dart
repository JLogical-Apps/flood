import 'package:jlogical_utils/jlogical_utils.dart';

import 'envelope.dart';
import 'envelope_entity.dart';

class EnvelopeRepository extends DefaultAdaptingRepository<EnvelopeEntity, Envelope> {
  @override
  String get dataPath => 'envelopes';

  @override
  EnvelopeEntity createEntity() {
    return EnvelopeEntity();
  }

  @override
  Envelope createValueObject() {
    return Envelope();
  }
}
