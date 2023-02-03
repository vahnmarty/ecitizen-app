import 'package:citizen/providers/providers.dart';
import 'package:citizen/screens/home_screen.dart';
import 'package:citizen/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [...providers],
      child: MaterialApp(
        localizationsDelegates: const [
          RefreshLocalizations.delegate,
        ],
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.grey,
        ),
        home: HomeScreen(),
      ),
    );
  }
}
