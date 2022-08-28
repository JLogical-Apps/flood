import 'package:jlogical_utils/src/pond/export.dart';

import '../../context/app_context.dart';
import '../../context/registration/entity_registration.dart';
import '../../context/registration/value_object_registration.dart';
import '../../repository/entity_repository.dart';
import '../../repository/with_id_generator.dart';
import 'with_syncing_repository.dart';

abstract class SyncingRepository extends EntityRepository with WithSyncingRepository, WithIdGenerator {
  @override
  final bool publishOnSave;

  SyncingRepository({this.publishOnSave: true}) {
    sourceRepository.entityInflatedX.listen((entity) {
      if (!locate<SyncingModule>().isDisabled) {
        localRepository.saveState(entity.state);
      }
    });
  }

  @override
  List<ValueObjectRegistration> get valueObjectRegistrations => localRepository.valueObjectRegistrations;

  @override
  List<EntityRegistration> get entityRegistrations => localRepository.entityRegistrations;

  Future<void> onReset(AppContext context) async {
    await Future.wait([localRepository.onReset(context), sourceRepository.onReset(context)]);
  }
}
