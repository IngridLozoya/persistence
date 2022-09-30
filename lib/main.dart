import 'package:flutter/material.dart';
import 'package:persistence/Screens/home_screen.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SqliteApp());
}

class SqliteApp extends StatelessWidget {
  const SqliteApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "SQLite Example",
      initialRoute: "home",
      routes: {"home": (context) =>  HomeScreen()},
      theme: ThemeData.light().copyWith(appBarTheme: const AppBarTheme(color: Colors.blueAccent))
    );
  }
}