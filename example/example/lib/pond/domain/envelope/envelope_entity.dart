import 'package:example/pond/domain/envelope/envelope.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

import 'envelope_schema.dart';

class EnvelopeEntity extends Entity<Envelope> with WithSchemaMigrationInitializer<Envelope> {
  Schema get schema => EnvelopeSchema.schema;
}
