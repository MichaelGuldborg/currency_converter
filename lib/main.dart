import 'package:currency_converter/pages/home_page.dart';
import 'package:currency_converter/theme.dart';
import 'package:flutter/material.dart';

void main() => runApp(App());

// TODO WRAP IN STATE PROVIDER
// BLOC ? INHERITED WIDGET ?
class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
      },
    );
  }
}
