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
                  icon: Icons.create,
                  onPerform: () {
                    final port = Port(
                      fields: [
                        StringPortField(
                          name: 'name',
                        ),
                        AssetPortField(
                          name: 'image',
                        ),
                      ],
                    );
                    style.showDialog(
                      context: context,
                      dialog: StyledDialog(
                        body: PortBuilder(
                          port: port,
                          child: ScrollColumn.withScrollbar(
                            children: [
                              StyledTextPortField(
                                name: 'name',
                                labelText: 'Name',
                                maxLength: 25,
                              ),
                              StyledUploadPortField(name: 'image', uploadType: UploadType.image),
                              StyledButton.high(
                                text: 'Save',
                                onTapped: () async {
                                  await port.submit();
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
                  icon: Icons.face,
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
                      StyledDialog.port(
                        context: context,
                        port: Port(
                          fields: [
                            StringPortField(name: 'name').required(),
                            CurrencyPortField(name: 'amount'),
                            DatePortField(name: 'date'),
                            StringPortField(name: 'notes'),
                            OptionsPortField(name: 'type', options: ['payment', 'refund'], initialValue: 'payment')
                                .required(),
                          ],
                        ),
                        titleText: 'Create Transaction',
                        children: [
                          StyledTextPortField(
                            name: 'name',
                            labelText: 'Name',
                          ),
                          StyledCurrencyPortField(
                            name: 'amount',
                            labelText: 'Amount (\$)',
                          ),
                          StyledDatePortField(
                            name: 'date',
                            labelText: 'Transaction Date',
                          ),
                          StyledTextPortField(
                            name: 'notes',
                            labelText: 'Notes',
                            maxLines: 3,
                            keyboardType: TextInputType.multiline,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              StyledRadioOptionPortField(
                                radioValue: 'payment',
                                groupName: 'type',
                                labelText: 'Payment',
                              ),
                              StyledRadioOptionPortField(
                                radioValue: 'refund',
                                groupName: 'type',
                                labelText: 'Refund',
                              ),
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
                                    ActionItem.low(
                                      name: 'Test',
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
