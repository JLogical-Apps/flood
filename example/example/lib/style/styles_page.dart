import 'package:example/style/test_onboarding_page.dart';
import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class StylesPage extends StatelessWidget {
  const StylesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('STYLES'),
      ),
      body: ScrollColumn.withScrollbar(
        children: [
          NavigationCard(
            title: Text('Flat Light'),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => TestOnboardingPage(
                      style: FlatStyle(
                        backgroundColor: Color(0xFFEEEEEE),
                        primaryColor: Colors.blue,
                        accentColor: Color(0xFF7F35BF),
                      ),
                      styleName: 'Flat Light',
                    ))),
          ),
          NavigationCard(
            title: Text('Flat Dark'),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => TestOnboardingPage(
                      style: FlatStyle(
                          backgroundColor: Color(0xFF030413),
                          primaryColor: Colors.green,
                          accentColor: Color(0xFF1C7D75)),
                      styleName: 'Flat Dark',
                    ))),
          ),
          NavigationCard(
            title: Text('Delta'),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => TestOnboardingPage(
                      style: DeltaStyle(
                          backgroundColor: Color(0xFF172434),
                          primaryColor: Color(0xFF88df91),
                          accentColor: Color(0xFF0ab0bc)),
                      styleName: 'Delta',
                    ))),
          ),
        ],
      ),
    );
  }
}
