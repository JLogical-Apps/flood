import 'package:example/pond/domain/envelope/envelope_schema.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

import 'envelope.dart';
import 'envelope_entity.dart';

class EnvelopeRepository extends DefaultAdaptingRepository<EnvelopeEntity, Envelope>
    with WithSchemaMigrationStateInitializer {
  @override
  Schema get schema => EnvelopeSchema.schema;

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

  @override
  EntityRepository getFirestoreRepository() {
    return super.getFirestoreRepository().asSyncingRepository(localRepository: getFileRepository());
  }
}
