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
      child: StyledTabbedPage(
        pages: [
          StyledTab(
            title: 'Budget',
            actions: [
              ActionItem(
                name: 'Create Envelope',
                color: Colors.green,
                description: 'Create a new envelope.',
                leading: StyledIcon(Icons.create),
                onPerform: () {
                  final controller = SmartFormController();
                  style.showDialog(
                    context: context,
                    dialog: StyledDialog(
                      body: SmartForm(
                        controller: controller,
                        child: ScrollColumn.withScrollbar(
                          children: [
                            StyledSmartTextField(
                              name: 'name',
                              label: 'Name',
                            ),
                            StyledButton.high(
                              text: 'Save',
                              onTapped: () {},
                              icon: Icons.save,
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
                  style.navigateTo(context: context, page: () => TestLoginPage(style: style));
                },
              ),
            ],
            icon: Icon(Icons.attach_money),
            body: ScrollColumn.withScrollbar(
              children: [
                StyledContent.high(
                  headerText: 'Create Transaction',
                  leading: StyledIcon(Icons.compare_arrows),
                  onTapped: () {
                    final smartFormController = SmartFormController();
                    style.showDialog(
                      context: context,
                      dialog: StyledDialog(
                        titleText: 'Create Transaction',
                        body: SmartForm(
                          controller: smartFormController,
                          child: Column(
                            children: [
                              StyledSmartTextField(
                                name: 'name',
                                label: 'Name',
                              ),
                              StyledSmartTextField(
                                name: 'amount',
                                label: 'Amount (\$)',
                              ),
                              StyledSmartDateField(
                                name: 'date',
                                label: 'Transaction Date',
                              ),
                              StyledSmartTextField(
                                name: 'notes',
                                label: 'Notes',
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
                                  StyledSmartRadioOptionField(radioValue: 'payment', group: 'type', label: 'Payment'),
                                  StyledSmartRadioOptionField(radioValue: 'refund', group: 'type', label: 'Refund'),
                                ],
                              ),
                              StyledButton.high(
                                text: 'Save',
                                onTapped: () {
                                  style.navigateBack(context: context);
                                },
                                icon: Icons.save,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                    // return style.navigateTo(context: context, page: () => TestLoginPage(style: style));
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
                              ))
                          .toList(),
                      childAspectRatio: 100 / 50,
                      shrinkWrap: true,
                    ),
                  ],
                ),
                Wrap(
                  children: [
                    StyledBodyText('This is text that is '),
                    StyledBodyText(
                      'NOT',
                      textOverrides: StyledTextOverrides(fontWeight: FontWeight.bold),
                    ),
                    StyledBodyText(' dense. '),
                    StyledBodyText(
                      'Dense',
                      textOverrides: StyledTextOverrides(fontColor: Colors.orange),
                    ),
                    StyledBodyText(' will shrink padding of text widgets.'),
                  ],
                ),
                Dense(
                  child: Wrap(
                    children: [
                      StyledBodyText('This is text that is '),
                      StyledBodyText(
                        'ACTUALLY',
                        textOverrides: StyledTextOverrides(fontWeight: FontWeight.bold),
                      ),
                      StyledBodyText(' dense. '),
                      StyledBodyText(
                        'Dense',
                        textOverrides: StyledTextOverrides(fontColor: Colors.orange),
                      ),
                      StyledBodyText(' will shrink padding of text widgets.'),
                    ],
                  ),
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
                            headerText:
                                transaction['name']!.as<String>()! + ' - ' + transaction['envelopeName']!.as<String>()!,
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
    );
  }
}
