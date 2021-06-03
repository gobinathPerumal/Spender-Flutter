import 'dart:async';
import 'package:flutter/material.dart';
import 'package:spender/color/appcolors.dart';
import 'package:spender/dimens/stringFile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spender/widgets/loginScreen.dart';
import 'package:flutter/services.dart' ;
import 'package:spender/widgets/welcomeScreen.dart';
import 'database/DBHelper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  var color=ColorsFile();
  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: color.primaryColor,
        accentColor: color.fabColor,
        fontFamily: 'Poppins',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Spender'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  BuildContext bcontext;
  String userName="",isLogin="",passWord="";
  @override
  Widget build(BuildContext context) {
    bcontext=context;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image:   AssetImage("images/Splashscren_withlogo.png"),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  _startsplashscreen() async {
    var duration = const Duration(seconds: 5);
    return Timer(duration, () {
      if(isLogin==null || isLogin.isEmpty || isLogin!="logined")
        {
          Navigator.of(bcontext).pushReplacement(
            MaterialPageRoute(builder: (_) {
              return LoginScreen();
            }),
          );
        }
      else if(isLogin=="logined")
        {
          Navigator.of(bcontext).pushReplacement(
            MaterialPageRoute(builder: (_) {
              return WelcomeScreen();
            }),
          );
        }

    });
  }

  @override
  void initState() {
    getUserName();
    createDatabase();
    _startsplashscreen();
  }
  getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userName = prefs.getString(StringFiles().fullName);
    passWord = prefs.getString(StringFiles().password);
    isLogin = prefs.getString(StringFiles().isLogined);
    print(userName);
  }

  createDatabase()
  {
    DBHelper().initDatabase();
  }
}