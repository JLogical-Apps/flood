import 'package:drop_core/drop_core.dart';
import 'package:utils/utils.dart';

class AppwriteValueObjectStatePersisterModifier extends StatePersisterModifier {
  final DropCoreContext context;
  final StatePersister<Map<String, dynamic>> Function() statePersisterGetter;

  AppwriteValueObjectStatePersisterModifier(this.context, {required this.statePersisterGetter});

  @override
  Map<String, dynamic> persist(Map<String, dynamic> data) {
    return data.copy().replaceWhereTraversed(
      (key, value) => value is ValueObject,
      (key, value) {
        final state = (value as ValueObject).getState(context);
        return statePersisterGetter().persist(state);
      },
    ).cast<String, dynamic>();
  }
}
