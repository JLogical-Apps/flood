import 'dart:io';

import 'package:example/pond/domain/budget/budget_repository.dart';
import 'package:example/pond/domain/budget_transaction/budget_transaction_repository.dart';
import 'package:example/pond/domain/envelope/envelope_repository.dart';
import 'package:example/pond/domain/user/user.dart';
import 'package:example/pond/domain/user/user_entity.dart';
import 'package:example/pond/domain/user/user_repository.dart';
import 'package:example/pond/presentation/pond_home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class PondLoginPage extends HookWidget {
  static Style style = DeltaStyle(backgroundColor: Color(0xff030818));

  final Directory baseDirectory;

  const PondLoginPage({Key? key, required this.baseDirectory}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    useOneTimeEffect(() {
      _initPond();
    });
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
                                    final data = result.valueByName!;

                                    late String userId;
                                    try {
                                      userId = await AppContext.global.locate<AuthService>().login(
                                            email: data['email'],
                                            password: data['password'],
                                          );
                                    } catch (e) {
                                      print(e);
                                      smartFormController.setError(name: 'email', error: e.toString());
                                      return;
                                    }

                                    context
                                        .style()
                                        .navigateTo(context: context, page: (_) => PondHomePage(userId: userId));
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

                                                final data = result.valueByName!;
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

  void _initPond() {
    final appContext = AppContext(
      registration: DatabaseAppRegistration(
        repositories: [
          FileBudgetRepository(baseDirectory: baseDirectory / 'budgets'),
          FileBudgetTransactionRepository(baseDirectory: baseDirectory / 'transactions'),
          FileEnvelopeRepository(baseDirectory: baseDirectory / 'envelopes'),
          FileUserRepository(baseDirectory: baseDirectory / 'users'),
        ],
        environment: Environment.local,
      ),
    );
    appContext.registerModule(DefaultAuthModule(parentDirectory: baseDirectory / 'auth'));
    AppContext.global = appContext;
  }
}
