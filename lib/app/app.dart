import 'package:application/app/screens/home_screen/home_screen.dart';
import 'package:dynamic_themes/dynamic_themes.dart';

import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeCollection = ThemeCollection(themes: {
      0: ThemeData.light(),
      1: ThemeData.dark(),
    });

    return DynamicTheme(
      builder: (context, theme) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: theme,
          home: HomeScreen(),
        );
      },
      defaultThemeId: 0,
      themeCollection: themeCollection,
    );
  }
}
