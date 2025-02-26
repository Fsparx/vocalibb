import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vocalibb/Pages/BookResult.dart';
import 'firebase_options.dart';
import 'package:vocalibb/Pages/Login.dart';
import 'package:vocalibb/Pages/MainPage.dart';
import 'package:vocalibb/Pages/SelectGenre.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
//import 'package:vocalib/Pages/MainPage.dart';
//import 'package:vocalib/Pages/SelectGenre.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    
    MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
   bool _isloggedin=false;
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }
  void _checkLoginStatus() async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    bool isloggedin=prefs.getBool("islogged") ?? false;
    print(isloggedin);
    setState(() {
      _isloggedin=isloggedin;
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: GoogleFonts.openSans().fontFamily,
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xff2A2E34)),
        useMaterial3: true,
      ),
      home:LoginPage(),
    );
  }
}