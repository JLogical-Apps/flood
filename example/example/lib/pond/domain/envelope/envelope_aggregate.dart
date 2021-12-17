import 'package:example/pond/domain/envelope/envelope_entity.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class EnvelopeAggregate extends Aggregate<EnvelopeEntity> {
  EnvelopeAggregate({required EnvelopeEntity entity}) : super(entity: entity);
}
