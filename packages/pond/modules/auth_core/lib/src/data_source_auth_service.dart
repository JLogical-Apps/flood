import 'package:auth_core/src/auth_service.dart';
import 'package:collection/collection.dart';
import 'package:persistence_core/persistence_core.dart';
import 'package:pond_core/pond_core.dart';
import 'package:rxdart/rxdart.dart';
import 'package:utils_core/utils_core.dart';
import 'package:uuid/uuid.dart';

class DataSourceAuthService with IsAuthService, IsCorePondComponent {
  final DataSource<String?> currentUserDataSource;
  final DataSource<List<UserToken>> userTokensDataSource;

  final BehaviorSubject<FutureValue<String?>> _userIdX = BehaviorSubject.seeded(FutureValue.empty());

  DataSourceAuthService({required this.currentUserDataSource, required this.userTokensDataSource});

  @override
  List<CorePondComponentBehavior> get behaviors => [
        CorePondComponentBehavior(
          onRegister: (context, component) async {
            final userId = await currentUserDataSource.getOrNull();
            _userIdX.value = FutureValue.loaded(userId);
          },
        ),
      ];

  @override
  ValueStream<FutureValue<String?>> get userIdX => _userIdX;

  @override
  Future<String> login(String email, String password) async {
    if (loggedInUserId != null) {
      throw Exception('Cannot login when already logged in!');
    }

    final tokens = await userTokensDataSource.getOrNull() ?? [];
    final existingToken = tokens.firstWhereOrNull((token) => token.email == email);
    if (existingToken == null) {
      throw Exception('Email [$email] does not exist!');
    }

    await currentUserDataSource.set(existingToken.userId);
    return existingToken.userId;
  }

  @override
  Future<String> signup(String email, String password) async {
    if (loggedInUserId != null) {
      throw Exception('Cannot signup when already logged in!');
    }

    final tokens = await userTokensDataSource.getOrNull() ?? [];
    final existingToken = tokens.firstWhereOrNull((token) => token.email == email);
    if (existingToken != null) {
      throw Exception('Email [$email] already exists!');
    }

    final id = Uuid().v4();
    tokens.add(UserToken(userId: id, email: email, password: password));
    await userTokensDataSource.set(tokens);
    await currentUserDataSource.set(id);

    return id;
  }

  @override
  Future<void> logout() async {
    await currentUserDataSource.set(null);
  }
}

class UserToken {
  final String userId;
  final String email;
  final String password;

  const UserToken({required this.userId, required this.email, required this.password});
}