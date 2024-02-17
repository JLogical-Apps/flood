import 'package:auth_core/src/account.dart';
import 'package:auth_core/src/auth_service.dart';
import 'package:pond_core/pond_core.dart';
import 'package:rxdart/rxdart.dart';
import 'package:utils_core/utils_core.dart';

class BlankAuthService with IsAuthService, IsCorePondComponent {
  @override
  List<CorePondComponentBehavior> get behaviors => [];

  @override
  Future<Account> login(String email, String password) {
    throw UnimplementedError();
  }

  @override
  Future<void> logout() {
    throw UnimplementedError();
  }

  @override
  Future<Account> signup(String email, String password) {
    throw UnimplementedError();
  }

  @override
  Future<void> delete() {
    throw UnimplementedError();
  }

  @override
  ValueStream<FutureValue<Account?>> get accountX => BehaviorSubject.seeded(FutureValue.loaded(null));
}
