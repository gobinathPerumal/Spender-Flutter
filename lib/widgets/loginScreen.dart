import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:spender/color/appcolors.dart';
import 'package:spender/dimens/appDimens.dart';
import 'package:spender/dimens/stringFile.dart';
import 'package:spender/utils/customdialog.dart';
import 'package:spender/utils/validatorFile.dart';
import 'package:spender/widgets/welcomeScreen.dart';
import 'package:string_validator/string_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatelessWidget {
  var color = ColorsFile();
  LoginScreen();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: color.primaryColor,
        fontFamily: 'Poppins',
      ),
      home: LoginScreenPage(),
    );
  }
}

class LoginScreenPage extends StatefulWidget {
  LoginScreenPage();
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginScreenPage> {
  var colors = ColorsFile();
  BuildContext buildContext;
  String userName = "",
      password = "";
  final nameController = TextEditingController();
  final fullnameController = TextEditingController();
  final emailController = TextEditingController();
  var validator = Validator();
  var dimens = DimensFile();
  var strings = StringFiles();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<String> genderItems = [];
  bool isPasswordScreen = false;
  String genderSelction = "Select Gender";
  bool checkBoxValue=false;
  _LoginPageState();

  @override
  Widget build(BuildContext context) {
    buildContext = context;
    return WillPopScope(child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Theme
            .of(context)
            .primaryColor,
        body:Center(
          child: loginForm(),
        ),
        ),onWillPop: _onWillPop,);
  }

  @override
  void initState() {
    genderItems.add(strings.gender);
    genderItems.add(strings.male);
    genderItems.add(strings.female);
    genderItems.add(strings.others);
  }


  Widget loginForm() {
    return Container(
      margin: EdgeInsets.all(dimens.xlarge_baseMargin),
      child: Card(
          elevation: dimens.cardElevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(dimens.borderRadius),
          ),
          color: colors.appBackgroundColor,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Container(
                margin: EdgeInsets.all(dimens.basePadding),
                child: Column(
                  children: <Widget>[
                    Center(
                      child: Container(
                        height: 140,
                        width: 140,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image:   AssetImage("images/logo_alone.png"),
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      // margin: EdgeInsets.fromLTRB(0, dimens.baseTextMargin, 0, 0),
                      child: TextFormField(
                        maxLines: 1,
                        controller: fullnameController,
                        style: TextStyle(fontFamily: "Poppins", fontSize: 14),
                        decoration: InputDecoration(
                          hintText: "Your FullName",
                          labelText: strings.fullName,
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: colors.primaryColor),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: colors.positiveColor),
                          ),
                          prefixIcon: Icon(
                            Icons.person_add,
                            color: colors.primaryColor,
                          ),
                        ),
                        keyboardType: TextInputType.text,
                        obscureText: false,
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return 'Please Enter Your Full Name';
                          } else if (!isAlpha(text.replaceAll(" ", ""))) {
                            return 'Please Enter Your valid Full Name';
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      // margin: EdgeInsets.fromLTRB(0, dimens.baseTextMargin, 0, 0),
                      child: TextFormField(
                        controller: nameController,
                        maxLines: 1,
                        style: TextStyle(fontFamily: "Poppins", fontSize: 14),
                        decoration: InputDecoration(
                          hintText: "Your UserName",
                          labelText: strings.userName,
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: colors.primaryColor),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: colors.positiveColor),
                          ),
                          prefixIcon: Icon(
                            Icons.person,
                            color: colors.primaryColor,
                          ),
                        ),
                        keyboardType: TextInputType.text,
                        obscureText: false,
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return 'Please Enter Your UserName';
                          } else if (!isAlphanumeric(
                              text.replaceAll(" ", ""))) {
                            return 'Please Enter Your valid UserName';
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      child: TextFormField(
                        controller: emailController,
                        maxLines: 1,
                        style: TextStyle(fontFamily: "Poppins", fontSize: 14),
                        decoration: InputDecoration(
                          hintText: "Your Email Address",
                          labelText: strings.email,
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: colors.primaryColor),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: colors.positiveColor),
                          ),
                          prefixIcon: Icon(
                            Icons.mail,
                            color: colors.primaryColor,
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        obscureText: false,
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return 'Please Enter Your Email Address';
                          } else if (!validator.isEmail(text)) {
                            return 'Please Enter Your Valid Email Address';
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.fromLTRB(10, dimens.baseMargin, 0, 0),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.star,
                            color: colors.primaryColor,
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.fromLTRB(
                                  dimens.medium_padding, 0, 0, 0),
                              child: DropdownButton<String>(
                                value: genderSelction,
                                isExpanded: true,
                                icon: Icon(
                                  Icons.arrow_drop_down,
                                  color: colors.primaryColor,
                                ),
                                iconSize: 24,
                                elevation: 16,
                                style: TextStyle(
                                    fontFamily: "Poppins",
                                    color: colors.listHeadingColor,
                                    fontSize: dimens.listDescriptionText),
                                underline: Container(
                                  height: 1,
                                  color: colors.primaryColor,
                                ),
                                onChanged: (String data) {
                                  FocusScope.of(context).requestFocus(FocusNode());
                                  setState(() {
                                    genderSelction = data;
                                    print(genderSelction);
                                  });
                                },
                                items: genderItems
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value,
                                            style:
                                            TextStyle(fontFamily: "Poppins",
                                                fontSize: 14)),
                                      );
                                    }).toList(),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, dimens.baseMargin, 0, 0),
                      child: RaisedButton(
                        color: colors.fabColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: colors.fabColor)),
                        child: Text(
                          strings.next,
                          style: TextStyle(fontFamily: "Poppins", fontSize: 14),
                        ),
                        onPressed: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          loginValidation();
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          )),
    );
  }


  loginValidation() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      if (genderSelction == "Select Gender") {
        _scaffoldKey.currentState.showSnackBar(new SnackBar(
          content: Row(
            children: <Widget>[
              new Text("Please Select Gender",
                  style: TextStyle(fontFamily: "Poppins", fontSize: 14)),
              Spacer(),
              GestureDetector(
                onTap: () {
                  _scaffoldKey.currentState.hideCurrentSnackBar();
                },
                child: new Text("Ok",
                    style: TextStyle(fontFamily: "Poppins",
                        fontSize: 16,
                        color: Colors.red)),
              )
            ],
          ),
        ));
      } else {
        storedProfile();
        dialog("Great Job !", "Registered Successfully !", false,
            Colors.transparent);
      }
    }
  }

  dialog(String title, String desc, bool isAllbutton, Color symbolColor) {
    showDialog(
      context: context,
      builder: (BuildContext context) =>
          Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(DimensFile.padding),
            ),
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            child: Stack(
              children: <Widget>[
                //...bottom card part,
                //...top circlular image part,
                Container(
                  padding: EdgeInsets.only(
                    top: DimensFile.avatarRadius,
                    bottom: DimensFile.padding,
                    left: DimensFile.padding,
                    right: DimensFile.padding,
                  ),
                  margin: EdgeInsets.only(top: DimensFile.avatarRadius),
                  decoration: new BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(DimensFile.padding),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10.0,
                        offset: const Offset(0.0, 10.0),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // To make the card compact
                    children: <Widget>[
                      Text(
                        title,
                        style: TextStyle(
                            fontFamily: "Poppins",
                            color: colors.primaryColor,
                            fontSize: DimensFile.text_medium,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        desc,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: "Poppins",
                          color: ColorsFile.greyColor,
                          fontSize: DimensFile.text_xx_small,
                        ),
                      ),
                      SizedBox(height: 24.0),
                      Visibility(
                        visible: isAllbutton,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Align(
                              alignment: Alignment.bottomRight,
                              child: FlatButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // To close the dialog
                                },
                                child: Text(
                                  "No",
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    color: Colors.red,
                                    fontSize: DimensFile.text_medium,
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: FlatButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // To close the dialog
                                },
                                child: Text(
                                  "Ok",
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    color: colors.positiveColor,
                                    fontSize: DimensFile.text_medium,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: !isAllbutton,
                        child: Align(
                          alignment: Alignment.center,
                          child: FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.of(buildContext).pushReplacement(
                                MaterialPageRoute(builder: (_) {
                                  return WelcomeScreen();
                                }),
                              );
                            },
                            child: Text(
                              "Ok",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                color: ColorsFile.headerColor,
                                fontSize: DimensFile.text_medium,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
    );
  }

  storedProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(strings.fullName, fullnameController.text);
    prefs.setString(strings.userName, nameController.text);
    prefs.setString(strings.email, emailController.text);
    prefs.setString(strings.genderText, genderSelction);
    prefs.setString(strings.isLogined, "logined");
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
