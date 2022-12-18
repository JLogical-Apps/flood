import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class Styleguide {
  final List<StyleguidePage> pages;

  Styleguide({required this.pages});

  StyleguidePage getPageByNameOrCreate(String name, {required IconData icon}) {
    final page = pages.firstWhereOrNull((page) => page.name == name);
    if (page != null) {
      return page;
    }

    final newPage = StyleguidePage(
      name: name,
      icon: icon,
      sections: [],
    );

    pages.add(newPage);

    return newPage;
  }
}

class StyleguidePage {
  final String name;
  final IconData icon;
  final List<StyleguideSection> sections;

  StyleguidePage({required this.name, required this.icon, required this.sections});

  StyleguideSection getSectionByNameOrCreate(String name) {
    final section = sections.firstWhereOrNull((section) => section.name == name);
    if (section != null) {
      return section;
    }

    final newSection = StyleguideSection(name: name, widgets: []);
    sections.add(newSection);

    return newSection;
  }
}

class StyleguideSection {
  final String name;
  final List<Widget> widgets;

  StyleguideSection({required this.name, required this.widgets});

  void add(Widget widget) {
    widgets.add(widget);
  }
}
