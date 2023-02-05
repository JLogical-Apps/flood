import 'package:example/features/envelope/envelope.dart';
import 'package:example/features/envelope/envelope_entity.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class EnvelopeRepository with IsRepositoryWrapper {
  @override
  late Repository repository = Repository.memory().forType<EnvelopeEntity, Envelope>(
    EnvelopeEntity.new,
    Envelope.new,
    entityTypeName: 'EnvelopeEntity',
    valueObjectTypeName: 'Envelope',
  );
}
