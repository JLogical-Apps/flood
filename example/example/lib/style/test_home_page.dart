import 'package:example/style/test_login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class TestHomePage extends HookWidget {
  final Style style;

  const TestHomePage({Key? key, required this.style}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final envelopes = [
      {
        'name': 'Insurance',
        'amount': 2524,
      },
      {
        'name': 'Car',
        'amount': 4993,
      },
      {
        'name': 'House',
        'amount': 12272,
      },
    ];
    final transactions = [
      {
        'name': 'Payment',
        'envelopeName': 'Car',
        'amount': 25922,
      },
      {
        'name': 'Payment',
        'envelopeName': 'Insurance',
        'amount': 7942,
      },
      {
        'name': 'Rent',
        'envelopeName': 'House',
        'amount': 58241,
      },
    ];
    return StyleProvider(
      style: style,
      child: Builder(
        builder: (context) => StyledTabbedPage(
          pages: [
            StyledTab(
              title: 'Budget',
              actions: [
                ActionItem(
                  name: 'View Message',
                  onPerformWithContext: (context) {
                    style.showMessage(context: context, message: StyledMessage(messageText: 'Kachow'));
                  },
                ),
                ActionItem(
                  name: 'Create Envelope',
                  color: Colors.green,
                  description: 'Create a new envelope.',
                  leading: StyledIcon(Icons.create),
                  onPerform: () {
                    final form = FormModel(fields: [
                      StringFormField(
                        name: 'name',
                      ),
                    ]);
                    style.showDialog(
                      context: context,
                      dialog: StyledDialog(
                        body: FormModelBuilder(
                          form: form,
                          child: ScrollColumn.withScrollbar(
                            children: [
                              StyledStringFormField(
                                name: 'name',
                                labelText: 'Name',
                                maxLength: 25,
                              ),
                              StyledButton.high(
                                text: 'Save',
                                onTapped: () async {
                                  await form.submit();
                                  await Future.delayed(Duration(seconds: 1));
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                ActionItem(
                  name: 'Login',
                  color: Colors.blue,
                  leading: StyledIcon(Icons.face),
                  onPerform: () {
                    style.navigateTo(context: context, page: (context) => TestLoginPage(style: style));
                  },
                ),
              ],
              icon: Icon(Icons.attach_money),
              body: ScrollColumn.withScrollbar(
                children: [
                  StyledContent.high(
                    headerText: 'Create Transaction',
                    leading: StyledIcon(Icons.compare_arrows),
                    onTapped: () async {
                      StyledDialog.form(
                        context: context,
                        form: FormModel(
                          fields: [
                            StringFormField(name: 'name').required(),
                            StringFormField(name: 'amount').isCurrency(),
                          ],
                        ),
                        titleText: 'Create Transaction',
                        children: [
                          StyledTextFormField(
                            name: 'name',
                            labelText: 'Name',
                          ),
                          StyledSmartTextField(
                            name: 'amount',
                            labelText: 'Amount (\$)',
                          ),
                          StyledSmartDateField(
                            name: 'date',
                            labelText: 'Transaction Date',
                          ),
                          StyledSmartTextField(
                            name: 'notes',
                            labelText: 'Notes',
                            maxLines: 3,
                            keyboardType: TextInputType.multiline,
                          ),
                          SmartRadioGroup(
                            group: 'type',
                            initialValue: 'payment',
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              StyledSmartRadioOptionField(radioValue: 'payment', group: 'type', labelText: 'Payment'),
                              StyledSmartRadioOptionField(radioValue: 'refund', group: 'type', labelText: 'Refund'),
                            ],
                          ),
                        ],
                      ).show(context);
                    },
                    trailing: StyledIcon(Icons.chevron_right),
                  ),
                  StyledCategory.medium(
                    headerText: 'Budget',
                    bodyText: '\$252.49',
                    leading: StyledIcon(Icons.attach_money),
                    children: [
                      GridView.count(
                        crossAxisCount: 2,
                        physics: NeverScrollableScrollPhysics(),
                        children: envelopes
                            .map((envelope) => StyledContent.medium(
                                  headerText: envelope['name']!.as<String>(),
                                  bodyText: (envelope['amount']!.as<int>()! / 100).formatCurrency(),
                                  trailing: StyledIcon(
                                    Icons.chevron_right,
                                  ),
                                  actions: [
                                    ActionItem(
                                      name: 'Test',
                                      type: ActionItemType.secondary,
                                    ),
                                  ],
                                ))
                            .toList(),
                        childAspectRatio: 100 / 50,
                        shrinkWrap: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            StyledTab(
              title: 'Transactions',
              icon: Icon(Icons.compare_arrows),
              body: ScrollColumn.withScrollbar(
                children: [
                  StyledCategory.medium(
                    headerText: 'Transactions',
                    leading: StyledIcon(Icons.compare_arrows),
                    children: transactions
                        .map((transaction) => StyledContent.medium(
                              headerText: transaction['name']!.as<String>()! +
                                  ' - ' +
                                  transaction['envelopeName']!.as<String>()!,
                              bodyText: (transaction['amount']!.as<int>()! / 100).formatCurrency(),
                              emphasisColorOverride: Colors.redAccent,
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
