import 'dart:async';

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
import 'package:pond_core/pond_core.dart';
import 'package:rxdart/rxdart.dart';
import 'package:utils_core/utils_core.dart';
import 'package:uuid/uuid.dart';

class MemoryAuthService with IsAuthService, IsCorePondComponent {
  final bool isAdmin;

  final BehaviorSubject<Account?> _accountX = BehaviorSubject.seeded(null);

  MemoryAuthService({this.isAdmin = false});

  @override
  List<CorePondComponentBehavior> get behaviors => [
        CorePondComponentBehavior(
          onRegister: (context, _) async => await context.register(AccountRepository().memory()),
        ),
      ];

  @override
  ValueStream<FutureValue<Account?>> get accountX => _accountX.mapWithValue((userId) => FutureValue.loaded(userId));

  @override
  Future<Account> login(AuthCredentials authCredentials) async {
    if (loggedInUserId != null) {
      throw Exception('Cannot login when already logged in!');
    }

    final accountEntity =
        await AccountEntity.accountFromCredentialsQuery(authCredentials).firstOrNull().get(context.dropCoreComponent);
    if (accountEntity == null) {
      throw LoginFailure.userNotFound();
    }

    final account = accountEntity.value.toAccount();
    if (!accountEntity.value.authCredentialProperty.value.matches(authCredentials)) {
      throw LoginFailure.wrongPassword();
    }

    _accountX.value = account;
    return _accountX.value!;
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

    await context.dropCoreComponent
        .update(AccountEntity()..set(AccountValueObject.fromAccount(account, authCredentials)));

    _accountX.value = account;

    return account;
  }

  @override
  Future<void> logout() async {
    _accountX.value = null;
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
}
