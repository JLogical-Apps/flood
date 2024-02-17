import 'package:auth_core/auth_core.dart';
import 'package:collection/collection.dart';
import 'package:pond_core/pond_core.dart';
import 'package:rxdart/rxdart.dart';
import 'package:utils_core/utils_core.dart';
import 'package:uuid/uuid.dart';

class MemoryAuthService with IsAuthService, IsCorePondComponent {
  final bool isAdmin;

  final List<_UserToken> _userTokens = [];

  final BehaviorSubject<Account?> _accountX = BehaviorSubject.seeded(null);

  MemoryAuthService({this.isAdmin = false});

  @override
  ValueStream<FutureValue<Account?>> get accountX => _accountX.mapWithValue((userId) => FutureValue.loaded(userId));

  @override
  Future<Account> login(String email, String password) async {
    if (loggedInUserId != null) {
      throw Exception('Cannot login when already logged in!');
    }

    final existingToken = _userTokens.firstWhereOrNull((token) => token.email == email);
    if (existingToken == null) {
      throw LoginFailure.invalidEmail();
    }

    if (existingToken.password != password) {
      throw LoginFailure.wrongPassword();
    }

    _accountX.value = Account(accountId: existingToken.userId, isAdmin: existingToken.isAdmin);
    return _accountX.value!;
  }

  @override
  Future<Account> signup(String email, String password) async {
    if (loggedInUserId != null) {
      throw Exception('Cannot login when already logged in!');
    }

    final existingToken = _userTokens.firstWhereOrNull((token) => token.email == email);
    if (existingToken != null) {
      throw SignupFailure.emailAlreadyUsed();
    }

    final id = Uuid().v4();
    _userTokens.add(_UserToken(userId: id, email: email, password: password, isAdmin: isAdmin));

    _accountX.value = Account(accountId: id, isAdmin: isAdmin);
    return _accountX.value!;
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

    _userTokens.removeWhere((userToken) => userToken.userId == loggedInUserId);
  }
}

class _UserToken {
  final String userId;
  final String email;
  final String password;
  final bool isAdmin;

  const _UserToken({
    required this.userId,
    required this.email,
    required this.password,
    required this.isAdmin,
  });
}
