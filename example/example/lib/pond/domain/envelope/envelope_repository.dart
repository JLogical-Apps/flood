import 'package:jlogical_utils/jlogical_utils.dart';

import 'envelope.dart';
import 'envelope_entity.dart';

class LocalEnvelopeRepository extends DefaultLocalRepository<EnvelopeEntity, Envelope> {
  @override
  EnvelopeEntity createEntity() {
    return EnvelopeEntity();
  }

  @override
  Envelope createValueObject() {
    return Envelope();
  }
}
