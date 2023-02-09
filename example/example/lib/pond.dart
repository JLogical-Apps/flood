import 'package:example/features/budget/budget.dart';
import 'package:example/features/budget/budget_entity.dart';
import 'package:example/features/budget/budget_repository.dart';
import 'package:example/features/envelope/envelope.dart';
import 'package:example/features/envelope/envelope_entity.dart';
import 'package:example/features/envelope/envelope_repository.dart';
import 'package:example/features/user/user.dart';
import 'package:example/features/user/user_entity.dart';
import 'package:example/features/user/user_repository.dart';
import 'package:jlogical_utils_core/jlogical_utils_core.dart';

const bool testingLoggedIn = true;

Future<CorePondContext> getCorePondContext({required EnvironmentConfig environmentConfig}) async {
  final corePondContext = CorePondContext();
  await corePondContext.register(TypeCoreComponent());
  await corePondContext.register(DropCoreComponent());
  await corePondContext.register(LogCoreComponent.console());
  await corePondContext.register(
      ActionCoreComponent(actionWrapper: <P, R>(Action<P, R> action) => action.log(context: corePondContext)));
  await corePondContext.register(EnvironmentConfigCoreComponent(environmentConfig: environmentConfig));
  await corePondContext.register(AuthCoreComponent.memory());
  await corePondContext.register(UserRepository());
  await corePondContext.register(BudgetRepository());
  await corePondContext.register(EnvelopeRepository());
  await corePondContext.register(TestingSetupCoreComponent(onSetup: () async {
    if (testingLoggedIn) {
      final authComponent = corePondContext.locate<AuthCoreComponent>();
      final dropComponent = corePondContext.locate<DropCoreComponent>();

      final userId = await authComponent.signup('test@test.com', 'password');

      final user = User()..nameProperty.set('John Doe');
      final userEntity = UserEntity()
        ..id = userId
        ..value = user;
      await dropComponent.update(userEntity);

      final budget = Budget()
        ..nameProperty.set('Budget')
        ..ownerProperty.set(userEntity.id!);
      final budgetEntity = BudgetEntity()..value = budget;
      final updatedBudgetState = await dropComponent.update(budgetEntity);

      await Future.wait(List.generate(
              100,
              (i) => Envelope()
                ..nameProperty.set('Envelope $i')
                ..budgetProperty.set(updatedBudgetState.id))
          .map((envelope) => EnvelopeEntity()..value = envelope)
          .map((entity) => dropComponent.update(entity)));
    }
  }));
  return corePondContext;
}
