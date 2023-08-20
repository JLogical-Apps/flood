import 'package:auth_core/src/auth_service.dart';
import 'package:collection/collection.dart';
import 'package:pond_core/pond_core.dart';
import 'package:rxdart/rxdart.dart';
import 'package:utils_core/utils_core.dart';
import 'package:uuid/uuid.dart';

class MemoryAuthService with IsAuthService, IsCorePondComponent {
  final List<_UserToken> _userTokens = [];

  final BehaviorSubject<String?> _userIdX = BehaviorSubject.seeded(null);

  @override
  ValueStream<FutureValue<String?>> get userIdX => _userIdX.mapWithValue((userId) => FutureValue.loaded(userId));

  @override
  Future<String> login(String email, String password) async {
    if (loggedInUserId != null) {
      throw Exception('Cannot login when already logged in!');
    }

    final existingToken = _userTokens.firstWhereOrNull((token) => token.email == email);
    if (existingToken == null) {
      throw Exception('Email [$email] does not exist!');
    }

    _userIdX.value = existingToken.userId;
    return _userIdX.value!;
  }

  @override
  Future<String> signup(String email, String password) async {
    if (loggedInUserId != null) {
      throw Exception('Cannot login when already logged in!');
    }

    final existingToken = _userTokens.firstWhereOrNull((token) => token.email == email);
    if (existingToken != null) {
      throw Exception('Email [$email] already exists!');
    }

    final id = Uuid().v4();
    _userTokens.add(_UserToken(userId: id, email: email, password: password));

    _userIdX.value = id;
    return id;
  }

  @override
  Future<void> logout() async {
    _userIdX.value = null;
  }
}

class _UserToken {
  final String userId;
  final String email;
  final String password;

  const _UserToken({required this.userId, required this.email, required this.password});
}
