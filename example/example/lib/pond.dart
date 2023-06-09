import 'package:example/features/budget/budget_repository.dart';
import 'package:example/features/envelope/envelope_repository.dart';
import 'package:example/features/settings/settings_repository.dart';
import 'package:example/features/transaction/budget_transaction_repository.dart';
import 'package:example/features/user/user_repository.dart';
import 'package:jlogical_utils_core/jlogical_utils_core.dart';

Future<CorePondContext> getCorePondContext({EnvironmentConfig? environmentConfig}) async {
  environmentConfig ??= EnvironmentConfig.static.memory();

  final corePondContext = CorePondContext();
  await corePondContext.register(TypeCoreComponent());
  await corePondContext.register(CoreDropComponent());
  await corePondContext.register(LogCoreComponent.console());
  await corePondContext.register(
      ActionCoreComponent(actionWrapper: <P, R>(Action<P, R> action) => action.log(context: corePondContext)));
  await corePondContext.register(EnvironmentConfigCoreComponent(environmentConfig: environmentConfig));
  await corePondContext.register(CorePortDropComponent());
  await corePondContext.register(AuthCoreComponent.memory());
  await corePondContext.register(UserRepository());
  await corePondContext.register(BudgetRepository());
  await corePondContext.register(EnvelopeRepository());
  await corePondContext.register(SettingsRepository());
  await corePondContext.register(BudgetTransactionRepository());
  return corePondContext;
}
