import 'package:jlogical_utils/jlogical_utils.dart';

import 'envelope.dart';
import 'envelope_entity.dart';

class LocalEnvelopeRepository extends EntityRepository
    with
        WithMonoEntityRepository<EnvelopeEntity>,
        WithLocalEntityRepository,
        WithIdGenerator,
        WithDomainRegistrationsProvider<Envelope, EnvelopeEntity>
    implements RegistrationsProvider {
  @override
  EnvelopeEntity createEntity(Envelope initialValue) {
    return EnvelopeEntity(initialValue: initialValue);
  }

  @override
  Envelope createValueObject() {
    return Envelope();
  }
}
