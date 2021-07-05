import 'package:example/form_page.dart';
import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: CustomTheme.lightTheme(
        primaryColor: Colors.blue,
        accentColor: Colors.purple,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('JLogical Utils')),
      body: ListView(
        children: [
          NavigationCard(
            title: Text('Forms'),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => FormPage())),
          ),
        ],
      ),
    );
  }
}
