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

    return StyleProvider(
        style: style,
        child: Builder(
            builder: (context) => StyledPage(
                  titleText: 'Login',
                  body: ScrollColumn.withScrollbar(
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

                                                final user = User()
                                                  ..nameProperty.value = result['name']
                                                  ..emailProperty.value = result['email'];

                                                final userEntity = UserEntity()
                                                  ..value = user
                                                  ..id = userId;

                                                await userEntity.save();

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

                                    context
                                        .style()
                                        .navigateTo(context: context, page: (_) => PondHomePage(userId: userId));
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
                  ),
                )));
  }
}
