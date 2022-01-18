import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_failure.freezed.dart';

@freezed
class LoginFailure with _$LoginFailure {
  const factory LoginFailure.invalidEmail() = InvalidEmailLoginFailure;
  const factory LoginFailure.userDisabled() = UserDisabledLoginFailure;
  const factory LoginFailure.userNotFound() = UserNotFoundLoginFailure;
  const factory LoginFailure.wrongPassword() = WrongPasswordLoginFailure;
}
