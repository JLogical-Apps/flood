import 'package:jlogical_utils/src/pond/context/registration/registrations_provider.dart';
import 'package:jlogical_utils/src/pond/context/registration/with_domain_registrations_provider.dart';
import 'package:jlogical_utils/src/pond/record/entity.dart';
import 'package:jlogical_utils/src/pond/record/value_object.dart';
import 'package:jlogical_utils/src/pond/repository/entity_repository.dart';
import 'package:jlogical_utils/src/pond/repository/local/with_local_entity_repository.dart';

import '../with_id_generator.dart';
import '../with_mono_entity_repository.dart';
import '../with_transactions_and_cache_entity_repository.dart';

abstract class DefaultLocalRepository<E extends Entity<V>, V extends ValueObject> = EntityRepository
    with
        WithMonoEntityRepository<E>,
        WithLocalEntityRepository,
        WithIdGenerator,
        WithDomainRegistrationsProvider<V, E>,
        WithTransactionsAndCacheEntityRepository
    implements RegistrationsProvider;
