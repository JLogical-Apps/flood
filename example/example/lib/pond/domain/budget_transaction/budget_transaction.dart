import 'package:example/pond/domain/envelope/envelope_entity.dart';
import 'package:example/pond/domain/user/user_entity.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class BudgetTransaction extends ValueObject {
  late final nameProperty = FieldProperty<String>(name: 'name').required();
  late final amountProperty = FieldProperty<int>(name: 'amount').required();
  late final envelopeProperty = ReferenceFieldProperty<EnvelopeEntity>(name: 'envelope').required();
  late final ownerProperty = ReferenceFieldProperty<UserEntity>(name: 'owner').required();

  @override
  List<Property> get properties => [nameProperty, amountProperty, envelopeProperty, ownerProperty];
}
