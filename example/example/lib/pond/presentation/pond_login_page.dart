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
    final smartFormController = useMemoized(() => SmartFormController());
    return StyleProvider(
        style: style,
        child: Builder(
            builder: (context) => StyledPage(
                  titleText: 'Login',
                  body: ScrollColumn.withScrollbar(
                    children: [
                      SmartForm(
                        controller: smartFormController,
                        child: StyledCategory.medium(
                          headerText: 'Login',
                          children: [
                            StyledSmartTextField(
                              name: 'email',
                              label: 'Email',
                              validators: [
                                Validation.required(),
                                Validation.isEmail(),
                              ],
                            ),
                            StyledSmartTextField(
                              name: 'password',
                              label: 'Password',
                              validators: [
                                Validation.required(),
                                Validation.isPassword(),
                              ],
                              obscureText: true,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                StyledButton.low(
                                  text: 'Log In',
                                  onTapped: () async {
                                    final result = await smartFormController.validate();
                                    if (!result.isValid) {
                                      return;
                                    }
                                    final data = result._valueByName!;

                                    late String userId;
                                    try {
                                      userId = await AppContext.global.locate<AuthService>().login(
                                            email: data['email'],
                                            password: data['password'],
                                          );
                                    } catch (e) {
                                      logError(e);
                                      smartFormController.setError(name: 'email', error: e.toString());
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
                                    final smartFormController = SmartFormController();
                                    final signupDialog = StyledDialog(
                                      titleText: 'Sign Up',
                                      body: SmartForm(
                                        controller: smartFormController,
                                        child: Column(
                                          children: [
                                            StyledSmartTextField(
                                              name: 'name',
                                              label: 'Name',
                                              validators: [
                                                Validation.required(),
                                              ],
                                            ),
                                            StyledSmartTextField(
                                              name: 'email',
                                              label: 'Email',
                                              validators: [
                                                Validation.required(),
                                                Validation.isEmail(),
                                              ],
                                            ),
                                            StyledSmartTextField(
                                              name: 'password',
                                              label: 'Password',
                                              validators: [
                                                Validation.required(),
                                                Validation.isPassword(),
                                              ],
                                              obscureText: true,
                                            ),
                                            StyledButton.high(
                                              text: 'Sign Up',
                                              onTapped: () async {
                                                final result = await smartFormController.validate();
                                                if (!result.isValid) {
                                                  return;
                                                }

                                                final data = result._valueByName!;
                                                late String userId;
                                                try {
                                                  userId = await AppContext.global.locate<AuthService>().signup(
                                                        email: data['email'],
                                                        password: data['password'],
                                                      );
                                                } catch (e) {
                                                  smartFormController.setError(name: 'email', error: e.toString());
                                                  return;
                                                }

                                                final user = User()
                                                  ..nameProperty.value = data['name']
                                                  ..emailProperty.value = data['email'];

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
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )));
  }
}
