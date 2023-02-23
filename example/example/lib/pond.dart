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

      final userEntity = await dropComponent.updateEntity(
        UserEntity()..id = userId,
        (User user) => user.nameProperty.set('John Doe'),
      );

      final budgetEntity = await dropComponent.updateEntity(
        BudgetEntity(),
        (Budget budget) => budget
          ..nameProperty.set('Budget')
          ..ownerProperty.set(userEntity.id!),
      );

      await Future.wait(List.generate(
          5,
          (i) => dropComponent.updateEntity(
              EnvelopeEntity(),
              (Envelope envelope) => envelope
                ..nameProperty.set('Envelope ${i + 1}')
                ..budgetProperty.set(budgetEntity.id!))));
    }
  }));
  return corePondContext;
}
