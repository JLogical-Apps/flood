import 'package:auth_core/src/account.dart';
import 'package:auth_core/src/auth_service.dart';
import 'package:auth_core/src/login_failure.dart';
import 'package:auth_core/src/signup_failure.dart';
import 'package:collection/collection.dart';
import 'package:environment_core/environment_core.dart';
import 'package:equatable/equatable.dart';
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

  late DataSource<Map<LoginToken, Account>?> registeredAccountsDataSource =
      DataSource.static.crossFile(authDirectory - 'registered_users.json').mapJson().map(
            getMapper: (json) {
              final registeredUsers = json['registeredUsers'] as Map<String, dynamic>;
              return registeredUsers.map((email, data) => MapEntry(
                    LoginToken(
                      email: email,
                      password: data['password'],
                    ),
                    Account(
                      accountId: data['userId'] as String,
                      isAdmin: (data['admin'] as bool?) ?? false,
                    ),
                  ));
            },
            setMapper: (registeredUsers) => {
              'registeredUsers': (registeredUsers ?? {}).map((loginToken, account) => MapEntry(
                    loginToken.email,
                    {
                      'userId': account.accountId,
                      'password': loginToken.password,
                      'admin': account.isAdmin,
                    },
                  ))
            },
          );

  final BehaviorSubject<FutureValue<Account?>> _accountX = BehaviorSubject.seeded(FutureValue.empty());

  @override
  late final List<CorePondComponentBehavior> behaviors = [
    CorePondComponentBehavior(
      onRegister: (context, _) async {
        final userId = await loggedInUserIdDataSource.getOrNull();
        final registeredAccounts = await registeredAccountsDataSource.getOrNull() ?? {};
        final account = registeredAccounts.values.firstWhereOrNull((account) => account.accountId == userId);
        _accountX.value = FutureValue.loaded(account);
      },
      onReset: (context, __) async {
        await loggedInUserIdDataSource.delete();
        await registeredAccountsDataSource.delete();
      },
    ),
  ];

  @override
  Future<Account> login(String email, String password) async {
    final loginToken = LoginToken(email: email, password: password);

    final registeredUsers = await registeredAccountsDataSource.getOrNull() ?? {};
    final account = registeredUsers[loginToken];
    if (account == null) {
      throw LoginFailure.userNotFound();
    }

    await loggedInUserIdDataSource.set(account.accountId);
    _accountX.value = FutureValue.loaded(account);

    return account;
  }

  @override
  Future<Account> signup(String email, String password) async {
    final loginToken = LoginToken(email: email, password: password);

    final registeredAccounts = await registeredAccountsDataSource.getOrNull() ?? {};
    final existingUser = registeredAccounts[loginToken];
    if (existingUser != null) {
      throw SignupFailure.emailAlreadyUsed();
    }

    final account = Account(
      accountId: Uuid().v4(),
      isAdmin: false,
    );

    registeredAccounts[loginToken] = account;

    await Future.wait([
      registeredAccountsDataSource.set(registeredAccounts),
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
  ValueStream<FutureValue<Account?>> get accountX => _accountX;
}

/// Token used to simulate logging in. Only used for local testing purposes.
class LoginToken extends Equatable {
  final String email;
  final String password;

  const LoginToken({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}
