import 'package:appwrite/appwrite.dart';
import 'package:appwrite_app/src/util/core_pond_context_extensions.dart';
import 'package:auth_core/auth_core.dart';
import 'package:pond_core/pond_core.dart';
import 'package:rxdart/rxdart.dart';
import 'package:utils/utils.dart';

class AppwriteAuthService with IsAuthService, IsCorePondComponent {
  late final BehaviorSubject<FutureValue<String?>> _userIdX = BehaviorSubject.seeded(FutureValue.loading());

  Account get account => context.appwriteCoreComponent.account;

  @override
  List<CorePondComponentBehavior> get behaviors => [
        CorePondComponentBehavior(
          onLoad: (context, _) async {
            try {
              final user = await account.get();
              _userIdX.value = FutureValue.loaded(user.$id);
            } catch (e) {
              FutureValue.loaded(null);
            }
          },
        ),
      ];

  @override
  Future<String> login(String email, String password) async {
    try {
      final session = await account.createEmailSession(email: email, password: password);
      final userId = session.userId;
      _userIdX.value = FutureValue.loaded(userId);
      return userId;
    } on AppwriteException catch (e) {
      switch (e.type) {
        case 'user_invalid_credentials':
          throw LoginFailure.wrongPassword();
        case 'user_blocked':
          throw LoginFailure.userDisabled();
        case 'user_not_found':
          throw LoginFailure.userNotFound();
        case 'user_password_reset_required':
          throw LoginFailure.passwordResetRequired();
        default:
          rethrow;
      }
    }
  }

  @override
  Future<String> signup(String email, String password) async {
    try {
      await account.create(userId: ID.unique(), email: email, password: password);
      final session = await account.createEmailSession(email: email, password: password);
      final userId = session.userId;
      _userIdX.value = FutureValue.loaded(userId);
      return userId;
    } on AppwriteException catch (e) {
      switch (e.type) {
        case 'user_invalid_credentials':
          throw SignupFailure.invalidEmail();
        case 'user_already_exists':
        case 'user_email_already_exists':
          throw SignupFailure.emailAlreadyUsed();
        default:
          rethrow;
      }
    }
  }

  @override
  Future<void> logout() async {
    await account.deleteSessions();
    _userIdX.value = FutureValue.loaded(null);
  }

  @override
  ValueStream<FutureValue<String?>> get userIdX => _userIdX;
}
