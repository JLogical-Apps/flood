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
      child: StyledPage(
        title: 'Budget',
        actions: [
          ActionItem(
            name: 'Create',
            color: Colors.green,
            lead: StyledIcon(Icons.add),
            description: 'Create a new envelope.',
            onPerform: () {
              print('Ouch you poked me!');
            },
          )
        ],
        body: ScrollColumn.withScrollbar(
          children: [
            StyledContent.high(
              header: 'Create Transaction',
              lead: StyledIcon(Icons.compare_arrows),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => TestLoginPage(style: style))),
              trailing: StyledIcon(Icons.chevron_right),
            ),
            StyledContent.medium(
              header: 'Budget',
              content: '\$252.49',
              lead: StyledIcon(Icons.attach_money),
              children: [
                GridView.count(
                  crossAxisCount: 2,
                  physics: NeverScrollableScrollPhysics(),
                  children: envelopes
                      .map((envelope) => StyledCategory.medium(
                            header: envelope['name']!.as<String>(),
                            content: (envelope['amount']!.as<int>()! / 100).formatCurrency(),
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
            StyledContent.medium(
              header: 'Transactions',
              lead: StyledIcon(Icons.compare_arrows),
              children: transactions
                  .map((transaction) => StyledCategory.medium(
                        header: transaction['name']!.as<String>()! + ' - ' + transaction['envelopeName']!.as<String>()!,
                        content: (transaction['amount']!.as<int>()! / 100).formatCurrency(),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
