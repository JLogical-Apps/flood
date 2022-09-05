import 'dart:async';

import 'package:example/pond/domain/user/user.dart';
import 'package:example/pond/domain/user/user_entity.dart';
import 'package:example/pond/presentation/pond_home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class PondLoginPage extends HookWidget {
  static Style style = DeltaStyle(
    backgroundColor: Color(0xFF2F2F2F),
    primaryColor: Color(0xFFE0B7B7),
    accentColor: Color(0xFF94BFA7),
  );

  @override
  Widget build(BuildContext context) {
    return StyleProvider(
        style: style,
        child: Builder(
            builder: (context) => StyledTabbedPage(
                  pages: [
                    StyledTab(
                      title: 'Login with Email',
                      icon: Icon(Icons.email),
                      body: HookBuilder(builder: (_) => _emailLoginBody(context)),
                    ),
                    StyledTab(
                      title: 'Login with Phone',
                      icon: Icon(Icons.phone),
                      body: HookBuilder(builder: (_) => _phoneLoginBody(context)),
                    )
                  ],
                )));
  }

  Widget _emailLoginBody(BuildContext context) {
    final port = useMemoized(
      () => Port(
        fields: [
          StringPortField(name: 'email').required().isEmail(),
          StringPortField(name: 'password').required().isPassword(),
        ],
      ),
    );
    final canResetPassword = locate<AuthService>() is PasswordResettable;
    final resetPasswordMessage = useState<String?>(null);

    return ScrollColumn.withScrollbar(
      children: [
        PortBuilder(
          port: port,
          child: StyledCategory.medium(
            headerText: 'Login',
            children: [
              StyledTextPortField(
                name: 'email',
                labelText: 'Email',
                showRequiredIndicator: false,
              ),
              StyledTextPortField(
                name: 'password',
                labelText: 'Password',
                obscureText: true,
                showRequiredIndicator: false,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StyledButton.low(
                    text: 'Log In',
                    onTapped: () async {
                      final result = await port.submit();
                      if (!result.isValid) {
                        return;
                      }

                      late String userId;
                      try {
                        userId = await locate<AuthService>().login(
                          email: result['email'],
                          password: result['password'],
                        );
                        await locate<SyncingModule>().download();
                      } catch (e, stack) {
                        logError(e, stack: stack);
                        port.setException(name: 'email', exception: e.toString());
                        return;
                      }

                      context.style().navigateTo(
                          context: context,
                          page: (_) => PondHomePage(
                                userId: userId,
                              ));
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                  ),
                  StyledButton.high(
                    text: 'Sign Up',
                    onTapped: () async {
                      final port = Port(
                        fields: [
                          StringPortField(name: 'name').required(),
                          StringPortField(name: 'email').required().isEmail(),
                          StringPortField(name: 'password').required().isPassword(),
                          StringPortField(name: 'confirmPassword').required().isConfirmPassword(),
                        ],
                      );
                      final signupDialog = StyledDialog(
                        titleText: 'Sign Up',
                        body: PortBuilder(
                          port: port,
                          child: Column(
                            children: [
                              StyledTextPortField(
                                name: 'name',
                                labelText: 'Name',
                              ),
                              StyledTextPortField(
                                name: 'email',
                                labelText: 'Email',
                              ),
                              StyledTextPortField(
                                name: 'password',
                                labelText: 'Password',
                                obscureText: true,
                              ),
                              StyledTextPortField(
                                name: 'confirmPassword',
                                labelText: 'Confirm Password',
                                obscureText: true,
                              ),
                              StyledButton.high(
                                text: 'Sign Up',
                                onTapped: () async {
                                  final result = await port.submit();
                                  if (!result.isValid) {
                                    return;
                                  }

                                  late String userId;
                                  try {
                                    userId = await AppContext.global.locate<AuthService>().signup(
                                          email: result['email'],
                                          password: result['password'],
                                        );
                                    await locate<SyncingModule>().download();
                                  } catch (e) {
                                    port.setException(name: 'email', exception: e.toString());
                                    return;
                                  }

                                  await createUserIfNotExisting(
                                    userId: userId,
                                    nameGetter: () => result['name'],
                                    phoneNumber: result['email'],
                                  );

                                  context.style().navigateBack(context: context, result: userId);
                                },
                              )
                            ],
                          ),
                        ),
                      );
                      final userId = await signupDialog.show(context);
                      if (userId == null) {
                        return;
                      }

                      context.style().navigateTo(context: context, page: (_) => PondHomePage(userId: userId));
                    },
                  )
                ],
              ),
              if (canResetPassword)
                StyledButton.low(
                  text: 'Forgot Password?',
                  color: context.styleContext().foregroundColorSoft,
                  onTapped: () async {
                    final passwordResettable = locate<AuthService>() as PasswordResettable;
                    try {
                      final email = port['email'] ?? '';
                      await passwordResettable.onResetPassword(email);
                      resetPasswordMessage.value = 'A password reset email has been sent to $email';
                    } catch (e) {
                      resetPasswordMessage.value = e.toString();
                    }
                  },
                ),
              if (resetPasswordMessage.value != null) StyledBodyText(resetPasswordMessage.value!),
            ],
          ),
        ),
      ],
    );
  }

  Widget _phoneLoginBody(BuildContext context) {
    final port = useMemoized(
      () => Port(
        fields: [
          StringPortField(name: 'phone').required().minLength(9),
        ],
      ),
    );

    return ScrollColumn.withScrollbar(
      children: [
        PortBuilder(
          port: port,
          child: StyledCategory.medium(
            headerText: 'Login',
            children: [
              StyledTextPortField(
                name: 'phone',
                labelText: 'Phone #',
                showRequiredIndicator: false,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StyledButton.low(
                    text: 'Log In',
                    onTapped: () async {
                      final result = await port.submit();
                      if (!result.isValid) {
                        return;
                      }

                      final phone = result['phone'];

                      late String userId;
                      try {
                        userId = await locate<AuthService>().loginWithPhoneNumber(
                          phoneNumber: phone,
                          smsCodeGetter: (smsCodeType) async {
                            final smsCodeResult = await StyledDialog.port(
                              context: context,
                              port: Port(
                                fields: [
                                  StringPortField(name: 'smsCode').required(),
                                ],
                              ),
                              children: [
                                StyledBodyText(
                                    'A verification text has been sent to $phone. Type in the code you received there.'),
                                if (smsCodeType == SmsCodeRequestType.retry)
                                  StyledErrorText('Incorrect code sent. Try again.'),
                                StyledTextPortField(
                                  name: 'smsCode',
                                  labelText: 'SMS Code',
                                ),
                              ],
                            ).show(context);
                            return smsCodeResult?['smsCode'];
                          },
                        );

                        await createUserIfNotExisting(
                          userId: userId,
                          nameGetter: () => result['phone'],
                          phoneNumber: result['phone'],
                        );

                        await locate<SyncingModule>().download();
                      } catch (e, stack) {
                        logError(e, stack: stack);
                        port.setException(name: 'phone', exception: e.toString());
                        return;
                      }
                      context.style().navigateTo(
                          context: context,
                          page: (_) => PondHomePage(
                                userId: userId,
                              ));
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> createUserIfNotExisting({
    required String userId,
    required FutureOr<String> Function() nameGetter,
    String? email,
    String? phoneNumber,
  }) async {
    final existingUser = await Query.getById<UserEntity>(userId).get();
    if (existingUser != null) {
      return;
    }

    final user = User()
      ..nameProperty.value = await nameGetter()
      ..emailProperty.value = email
      ..phoneNumberProperty.value = phoneNumber;

    final userEntity = UserEntity()
      ..value = user
      ..id = userId;

    await userEntity.save();
  }
}
