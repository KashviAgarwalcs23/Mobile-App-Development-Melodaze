import 'package:flutter/material.dart';
import 'package:untitled/themes/dark_mode.dart';
import 'package:untitled/themes/light_mode.dart';

class ThemeProvider extends ChangeNotifier{
  //initially, dark mode
  ThemeData _themeData = darkMode; // Changed to darkMode

  //get Theme
  ThemeData get themeData => _themeData;

  //is dark mode
  bool get isDarkMode=> _themeData == darkMode;

  // set Theme
  set themeData(ThemeData themeData)
  {
    _themeData = themeData;

    //update UI
    notifyListeners();
  }

  // toggle theme
  void toggleTheme()
  {
    if(themeData == lightMode)
    {
      themeData=darkMode;
    }
    else
    {
      themeData=lightMode;
    }
  }
}