import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:style/src/styleguide.dart';

class StyleguideWidget extends HookWidget {
  final Styleguide styleguide;

  const StyleguideWidget({super.key, required this.styleguide});

  @override
  Widget build(BuildContext context) {
    final pageController = usePageController();
    return Scaffold(
      body: PageView(
        controller: pageController,
        children: styleguide.pages
            .map((page) => SingleChildScrollView(
                child: Column(children: page.sections.map((section) => Column(children: section.widgets)).toList())))
            .toList(),
      ),
    );
  }
}
