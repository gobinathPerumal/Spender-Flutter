import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spender/color/appcolors.dart';
import 'package:spender/dimens/appDimens.dart';
import 'package:spender/dimens/stringFile.dart';

import 'homeScreen.dart';

class WelcomeScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      theme: ThemeData(
        primarySwatch: ColorsFile().primaryColor,
        fontFamily: 'Poppins',
      ),
      home: WelcomeScreenPage(),
    );
  }
}

class WelcomeScreenPage extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreenPage> {
  BuildContext buildContext;
  String fullName="",isLogin="";
  bool isFound=false;
  @override
  Widget build(BuildContext context) {
    buildContext=context;
    return WillPopScope(child:
    Scaffold(
        body: isFound?Center(
          child: CircularProgressIndicator(),
        ):Container(
          child: Container(
            padding: EdgeInsets.only(top: 20),
            margin: EdgeInsets.all(DimensFile().basePadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  alignment: Alignment.topLeft,
                  child: Text("Welcome to Spender App", style: TextStyle(fontSize: 22,fontFamily: "Poppins",color: ColorsFile().primaryColor),),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10),
                  alignment: Alignment.topLeft,
                  child: Text("Hi "+fullName+" ,", style: TextStyle(fontSize: 18,fontFamily: "Poppins"),),
                ),
                Center(
                  child:Container(
                    height: MediaQuery.of(context).size.width/2.2,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("images/home_clipart.png"),
                          fit: BoxFit.fill),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10),
                  alignment: Alignment.topLeft,
                  child: Text("Keep Your Income & Expensive Record's in Your Hand. ", style: TextStyle(fontSize: 18,fontFamily: "Poppins"),),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(left: 30,right: 30,bottom: 20),
                  child: RaisedButton(
                    color: ColorsFile().fabColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2.0),
                        side: BorderSide(color: ColorsFile().fabColor)),
                    child: Text(
                      isLogin=="yes"?"CONTINUE":"START",
                      style: TextStyle(fontFamily: "Poppins",fontSize: 14),
                    ),
                    onPressed: () {
                      storedProfile();
                    },
                  ),
                )
              ],
            ),
          ),
        )
    ), onWillPop: _onWillPop);
  }

  @override
  void initState() {
    isFound=true;
    getUserDetails();
  }

  getUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    fullName = prefs.getString(StringFiles().userName);
    isLogin = prefs.getString("isFirst");
    if(isLogin==null || isLogin=="yes")
      {
        setState(() {
          isFound=false;
        });
      }
    print(isLogin);
  }
  storedProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("isFirst", "yes");
    Navigator.of(buildContext).pushReplacement(
      MaterialPageRoute(builder: (_) {
        return SpenderHome();
      }),
    );
  }
  Future<bool> _onWillPop() async {
      return (await showDialog(
        context: buildContext,
        builder: (context) => new AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min, // To make the card compact
            children: <Widget>[
              Text(
                "Alert",
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                    color: Colors.purple,
                    fontSize: 26,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.0),
              Text(
                "Are you want to exit this app ?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 24.0),
              Visibility(
                visible: true,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.bottomRight,
                      child: FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // To close the dialog
                        },
                        child: Text(
                          "No",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: FlatButton(
                        onPressed: () {
                          exit(0);
                          Navigator.of(context).pop(); // To close the dialog
                        },
                        child: Text(
                          "Yes",
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )) ??
          false;
  }
}
