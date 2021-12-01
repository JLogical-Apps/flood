import 'package:example/model/model_page.dart';
import 'package:example/pond/presentation/pond_page.dart';
import 'package:example/style/styles_page.dart';
import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

import 'form/form_page.dart';
import 'repository/repository_page.dart';

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
            title: Text('Pond'),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => PondPage())),
          ),
          NavigationCard(
            title: Text('Forms'),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => FormPage())),
          ),
          NavigationCard(
            title: Text('Repository'),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => RepositoryPage())),
          ),
          NavigationCard(
            title: Text('Models'),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => ModelPage())),
          ),
          NavigationCard(
            title: Text('Style'),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => StylesPage())),
          ),
        ],
      ),
    );
  }
}
