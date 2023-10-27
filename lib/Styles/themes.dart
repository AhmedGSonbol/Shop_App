import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shopapp/Styles/colors.dart';

ThemeData darkTheme = ThemeData(

  primarySwatch: DefaultColor,

  appBarTheme: AppBarTheme(
    //Control Status bar

      systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: darkColor,
          statusBarIconBrightness: Brightness.light),
      /////////////////////
      titleSpacing: 20.0,
      backgroundColor: darkColor,
      elevation: 0.0,
      titleTextStyle:const TextStyle(
        color: Colors.white,
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
      ),

      iconTheme:const IconThemeData(color: Colors.white)),

  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    selectedItemColor: DefaultColor,
    unselectedItemColor: Colors.white,
    selectedLabelStyle: TextStyle(color: Colors.orange, fontSize: 15.0),
    elevation: 20.0,
    backgroundColor: darkColor,

  ),

  scaffoldBackgroundColor: darkColor,

  textTheme:const TextTheme(bodyLarge: TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.w600,
      color: Colors.white
  ),
  ),

    fontFamily: 'Jannah',

);


ThemeData lightTheme = ThemeData(
  primarySwatch: DefaultColor,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    //Control Status bar
      systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark),
      /////////////////////
      titleSpacing: 20.0,
      backgroundColor: Colors.white,
      elevation: 0.0,
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: Colors.black)),
  bottomNavigationBarTheme:const BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: DefaultColor,
      selectedLabelStyle:
      TextStyle(color: Colors.orange, fontSize: 15.0),
      elevation: 20.0),
  textTheme:const TextTheme(bodyText1: TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.w600,
      color: Colors.black
  )
  ),
  fontFamily: 'Jannah',
);