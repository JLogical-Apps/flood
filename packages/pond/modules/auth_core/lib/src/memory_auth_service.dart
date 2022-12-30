import 'package:auth_core/src/auth_service.dart';
import 'package:collection/collection.dart';
import 'package:pond_core/pond_core.dart';
import 'package:uuid/uuid.dart';

class MemoryAuthService with IsAuthService, IsCorePondComponent {
  final List<_UserToken> _userTokens = [];
  String? _currentUserId;

  @override
  Future<String?> getLoggedInUser() async {
    return _currentUserId;
  }

  @override
  Future<String> login(String email, String password) async {
    if (_currentUserId != null) {
      throw Exception('Cannot login when already logged in!');
    }

    final existingToken = _userTokens.firstWhereOrNull((token) => token.email == email);
    if (existingToken == null) {
      throw Exception('Email [$email] does not exist!');
    }

    _currentUserId = existingToken.userId;
    return _currentUserId!;
  }

  @override
  Future<String> signup(String email, String password) async {
    if (_currentUserId != null) {
      throw Exception('Cannot login when already logged in!');
    }

    final existingToken = _userTokens.firstWhereOrNull((token) => token.email == email);
    if (existingToken != null) {
      throw Exception('Email [$email] already exists!');
    }

    final id = Uuid().v4();
    _userTokens.add(_UserToken(userId: id, email: email, password: password));

    _currentUserId = id;
    return id;
  }

  @override
  Future<void> logout() async {
    _currentUserId = null;
  }
}

class _UserToken {
  final String userId;
  final String email;
  final String password;

  const _UserToken({required this.userId, required this.email, required this.password});
}
