import 'package:auth_core/src/account.dart';
import 'package:auth_core/src/auth_service.dart';
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
      throw Exception('Email [$email] does not exist!');
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
      throw Exception('Email [$email] already exists!');
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
