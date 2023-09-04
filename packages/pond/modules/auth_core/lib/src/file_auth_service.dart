import 'package:auth_core/src/auth_service.dart';
import 'package:auth_core/src/login_failure.dart';
import 'package:auth_core/src/signup_failure.dart';
import 'package:environment_core/environment_core.dart';
import 'package:equatable/equatable.dart';
import 'package:persistence_core/persistence_core.dart';
import 'package:pond_core/pond_core.dart';
import 'package:rxdart/rxdart.dart';
import 'package:utils_core/utils_core.dart';
import 'package:uuid/uuid.dart';

class FileAuthService with IsAuthService, IsCorePondComponent {
  CrossDirectory get authDirectory => context.fileSystem.storageDirectory / 'auth';

  DataSource<String?>? _loggedInUserIdDataSource;
  late DataSource<String?> loggedInUserIdDataSource =
      _loggedInUserIdDataSource ??= DataSource.static.crossFile(authDirectory - 'logged_in_user_token.txt').map(
            getMapper: (string) => string.nullIfBlank,
            setMapper: (string) => string ?? '',
          );

  DataSource<Map<LoginToken, String>?>? _registeredUsersDataSource;
  late DataSource<Map<LoginToken, String>?> registeredUsersDataSource =
      _registeredUsersDataSource ??= DataSource.static.crossFile(authDirectory - 'registered_users.json').mapJson().map(
            getMapper: (json) {
              final registeredUsers = json['registeredUsers'] as Map<String, dynamic>;
              return registeredUsers.map((email, data) => MapEntry(
                    LoginToken(
                      email: email,
                      password: data['password'],
                    ),
                    data['userId'] as String,
                  ));
            },
            setMapper: (registeredUsers) => {
              'registeredUsers': (registeredUsers ?? {}).map((loginToken, userId) => MapEntry(
                    loginToken.email,
                    {
                      'userId': userId,
                      'password': loginToken.password,
                    },
                  ))
            },
          );

  final BehaviorSubject<FutureValue<String?>> _userIdX = BehaviorSubject.seeded(FutureValue.empty());

  @override
  late final List<CorePondComponentBehavior> behaviors = [
    CorePondComponentBehavior(
      onRegister: (context, _) async {
        final userId = await loggedInUserIdDataSource.getOrNull();
        _userIdX.value = FutureValue.loaded(userId);
      },
      onReset: (context, __) async {
        await loggedInUserIdDataSource.delete();
        await registeredUsersDataSource.delete();
      },
    ),
  ];

  @override
  Future<String> login(String email, String password) async {
    final loginToken = LoginToken(email: email, password: password);

    final registeredUsers = await registeredUsersDataSource.getOrNull() ?? {};
    final userId = registeredUsers[loginToken];
    if (userId == null) {
      throw LoginFailure.userNotFound();
    }

    await loggedInUserIdDataSource.set(userId);
    _userIdX.value = FutureValue.loaded(userId);

    return userId;
  }

  @override
  Future<String> signup(String email, String password) async {
    final loginToken = LoginToken(email: email, password: password);

    final registeredUsers = await registeredUsersDataSource.getOrNull() ?? {};
    final existingUser = registeredUsers[loginToken];
    if (existingUser != null) {
      throw SignupFailure.emailAlreadyUsed();
    }

    final userId = Uuid().v4();

    registeredUsers[loginToken] = userId;

    await Future.wait([
      registeredUsersDataSource.set(registeredUsers),
      loggedInUserIdDataSource.set(userId),
    ]);

    _userIdX.value = FutureValue.loaded(userId);

    return userId;
  }

  @override
  Future<void> logout() async {
    await loggedInUserIdDataSource.delete();
    _userIdX.value = FutureValue.loaded(null);
  }

  @override
  ValueStream<FutureValue<String?>> get userIdX => _userIdX;
}

/// Token used to simulate logging in. Only used for local testing purposes.
class LoginToken extends Equatable {
  final String email;
  final String password;

  const LoginToken({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}
