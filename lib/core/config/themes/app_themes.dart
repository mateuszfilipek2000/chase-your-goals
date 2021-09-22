import 'package:flutter/material.dart';

class AppThemes {
  // static ThemeData dark = ThemeData.dark().copyWith(
  //   primaryColor: Color(0xff141417),
  //   scaffoldBackgroundColor: Color(0xff141417),
  //   colorScheme: ColorScheme.dark().copyWith(
  //     surface: Color(0xff1d1d21),
  //   ),
  // );

  static ThemeData light = ThemeData.light().copyWith(
    //scaffoldBackgroundColor: const Color(0xffe3f2fd),
    bottomAppBarColor: const Color(0xffe3f2fd),
    colorScheme: const ColorScheme.light().copyWith(
      primary: const Color(0xff2196f3),
      secondary: const Color(0xffffcc80),
    ),
  );
}
