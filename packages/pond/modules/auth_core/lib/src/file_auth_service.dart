import 'package:auth_core/src/account.dart';
import 'package:auth_core/src/auth_credentials/auth_credentials.dart';
import 'package:auth_core/src/auth_service.dart';
import 'package:auth_core/src/drop/account.dart';
import 'package:auth_core/src/drop/account_entity.dart';
import 'package:auth_core/src/drop/account_repository.dart';
import 'package:auth_core/src/login_failure.dart';
import 'package:auth_core/src/otp/otp_provider.dart';
import 'package:auth_core/src/otp/otp_request_type.dart';
import 'package:auth_core/src/signup_failure.dart';
import 'package:drop_core/drop_core.dart';
import 'package:environment_core/environment_core.dart';
import 'package:persistence_core/persistence_core.dart';
import 'package:pond_core/pond_core.dart';
import 'package:rxdart/rxdart.dart';
import 'package:utils_core/utils_core.dart';
import 'package:uuid/uuid.dart';

class FileAuthService with IsAuthService, IsCorePondComponent {
  CrossDirectory get authDirectory => context.fileSystem.storageDirectory / 'auth';

  late DataSource<String?> loggedInUserIdDataSource =
      DataSource.static.crossFile(authDirectory - 'logged_in_user_token.txt').map(
            getMapper: (string) => string.nullIfBlank,
            setMapper: (string) => string ?? '',
          );

  final BehaviorSubject<FutureValue<Account?>> _accountX = BehaviorSubject.seeded(FutureValue.empty());

  @override
  late final List<CorePondComponentBehavior> behaviors = [
    CorePondComponentBehavior(
      onRegister: (context, _) async {
        await context.register(AccountRepository().file('_auth'));
        final userId = await loggedInUserIdDataSource.getOrNull();
        final accountEntity = await Query.from<AccountEntity>()
            .where(AccountValueObject.accountIdField)
            .isEqualTo(userId)
            .firstOrNull()
            .get(context.dropCoreComponent);
        _accountX.value = FutureValue.loaded(accountEntity?.value.toAccount());
      },
      onReset: (context, __) async => await loggedInUserIdDataSource.delete(),
    ),
  ];

  @override
  Future<Account> login(AuthCredentials authCredentials) async {
    final accountEntity =
        await AccountEntity.accountFromCredentialsQuery(authCredentials).firstOrNull().get(context.dropCoreComponent);
    if (accountEntity == null) {
      throw LoginFailure.userNotFound();
    }

    final account = accountEntity.value.toAccount();
    if (!accountEntity.value.authCredentialProperty.value.matches(authCredentials)) {
      throw LoginFailure.wrongPassword();
    }

    await loggedInUserIdDataSource.set(account.accountId);
    _accountX.value = FutureValue.loaded(account);

    return account;
  }

  @override
  Future<Account> loginWithOtp(OtpProvider otpProvider) async {
    final code = '123456';
    var requestType = OtpRequestType.initial;
    var attempts = 0;
    do {
      final userCode = await otpProvider.getOtpUserCode(requestType);
      if (userCode == code) {
        return await loginOrSignup(otpProvider.generateAuthCredentials());
      }
      requestType = OtpRequestType.retry;
      attempts++;
    } while (attempts < 3);
    throw Exception('Failed OTP verification');
  }

  @override
  Future<Account> signup(AuthCredentials authCredentials) async {
    final existingAccountEntity =
        await AccountEntity.accountFromCredentialsQuery(authCredentials).firstOrNull().get(context.dropCoreComponent);
    if (existingAccountEntity != null) {
      throw SignupFailure.emailAlreadyUsed();
    }

    final account = Account(
      accountId: Uuid().v4(),
      isAdmin: false,
    );

    await Future.wait([
      context.dropCoreComponent.update(AccountEntity()..set(AccountValueObject.fromAccount(account, authCredentials))),
      loggedInUserIdDataSource.set(account.accountId),
    ]);

    _accountX.value = FutureValue.loaded(account);

    return account;
  }

  @override
  Future<void> logout() async {
    await loggedInUserIdDataSource.delete();
    _accountX.value = FutureValue.loaded(null);
  }

  @override
  Future<void> delete() async {
    final loggedInUserId = this.loggedInUserId;
    if (loggedInUserId == null) {
      throw Exception('Cannot delete an account when you are not logged in!');
    }

    await logout();

    final accountEntity =
        await AccountEntity.accountFromIdQuery(loggedInUserId).firstOrNull().get(context.dropCoreComponent);
    if (accountEntity != null) {
      await context.dropCoreComponent.delete(accountEntity);
    }
  }

  @override
  ValueStream<FutureValue<Account?>> get accountX => _accountX;
}
