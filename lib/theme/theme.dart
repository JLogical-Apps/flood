import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class CustomTheme {
  /// Returns a material theme that emphasizes filled colors.
  static ThemeData filledMaterialTheme({Color primaryColor, Color accentColor}) {
    return ThemeData(
      brightness: useWhiteForeground(primaryColor, bias: 1.5) ? Brightness.dark : Brightness.light,
      primaryColor: primaryColor,
      accentColor: accentColor,
      fontFamily: 'Roboto',
      backgroundColor: primaryColor,
      scaffoldBackgroundColor: primaryColor,
      appBarTheme: AppBarTheme(
        elevation: 0,
        color: primaryColor,
      ),
      buttonBarTheme: ButtonBarThemeData(
        alignment: MainAxisAlignment.center,
        buttonPadding: EdgeInsets.all(4),
        layoutBehavior: ButtonBarLayoutBehavior.padded,
      ),
      cardTheme: CardTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
        margin: EdgeInsets.all(8),
        color: Colors.white,
      ),
      cursorColor: primaryColor,
      dialogTheme: DialogTheme(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        titleTextStyle: TextStyle(
          color: primaryColor,
          fontSize: 20,
        ),
        elevation: 24,
      ),
      dividerTheme: DividerThemeData(
        color: Colors.black12,
        space: 12,
        indent: 12,
        endIndent: 12,
        thickness: 1,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(primaryColor),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          )),
          elevation: MaterialStateProperty.all(0),
        ),
      ),
      focusColor: primaryColor,
      iconTheme: IconThemeData(
        color: primaryColor,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        labelStyle: TextStyle(
          color: Colors.black87,
        ),
        errorMaxLines: 3,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.black87),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor),
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: Colors.white,
        elevation: 24,
      ),
      snackBarTheme: SnackBarThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
        ),
        elevation: 12,
        contentTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
      ),
      primaryColorBrightness: primaryColor == null
          ? Brightness.dark
          : useWhiteForeground(primaryColor, bias: 1.5)
              ? Brightness.dark
              : Brightness.light,
      accentColorBrightness: accentColor == null
          ? Brightness.dark
          : useWhiteForeground(accentColor, bias: 1.5)
              ? Brightness.dark
              : Brightness.light,
    );
  }

  static ThemeData lightTheme({Color primaryColor: Colors.blue, Color accentColor: Colors.purple}) {
    var theme = ThemeData(
      brightness: useWhiteForeground(primaryColor, bias: 1.5) ? Brightness.dark : Brightness.light,
      primaryColor: primaryColor,
      accentColor: accentColor,
      fontFamily: 'Roboto',
      backgroundColor: primaryColor,
      scaffoldBackgroundColor: Color(0xffeeeeee),
      buttonBarTheme: ButtonBarThemeData(
        alignment: MainAxisAlignment.center,
        buttonPadding: EdgeInsets.all(4),
        layoutBehavior: ButtonBarLayoutBehavior.padded,
      ),
      cardTheme: CardTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
        margin: EdgeInsets.all(8),
        color: Colors.white,
      ),
      cursorColor: primaryColor,
      dialogTheme: DialogTheme(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        titleTextStyle: TextStyle(
          color: primaryColor,
          fontSize: 20,
        ),
        elevation: 24,
      ),
      dividerTheme: DividerThemeData(
        color: Colors.black12,
        space: 12,
        indent: 12,
        endIndent: 12,
        thickness: 1,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(primaryColor),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          )),
          elevation: MaterialStateProperty.all(0),
        ),
      ),
      focusColor: primaryColor,
      iconTheme: IconThemeData(
        color: primaryColor,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        labelStyle: TextStyle(
          color: Colors.black87,
        ),
        errorMaxLines: 3,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.black87),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor),
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: Colors.white,
        elevation: 24,
      ),
      snackBarTheme: SnackBarThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
        ),
        elevation: 12,
        contentTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
      ),
      primaryColorBrightness: primaryColor == null
          ? Brightness.dark
          : useWhiteForeground(primaryColor, bias: 1.5)
              ? Brightness.dark
              : Brightness.light,
      accentColorBrightness: accentColor == null
          ? Brightness.dark
          : useWhiteForeground(accentColor, bias: 1.5)
              ? Brightness.dark
              : Brightness.light,
    );
    return theme.copyWith(
        appBarTheme: AppBarTheme(
      elevation: 0,
      color: Colors.white,
      textTheme: theme.textTheme.copyWith(
        headline6: TextStyle(
          color: theme.primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
      ),
      centerTitle: true,
      iconTheme: IconThemeData(
        color: primaryColor,
      ),
    ));
  }
}
