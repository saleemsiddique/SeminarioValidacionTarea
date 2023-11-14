import 'package:flutter/material.dart';
import 'package:seminariovalidacion/screens/screens.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
   return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Productos App',
      initialRoute: '/',
      routes: {
        '/': (_) => LoginScreen(),
        'home': (_) => HomeScreen(),
        'registrar': (_) => RegisterScreen()
      },
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.grey[300],
      ),
    );
  }
}