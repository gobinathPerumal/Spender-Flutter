import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:spender/color/appcolors.dart';
import 'package:spender/database/DBHelper.dart';
import 'package:spender/dimens/appDimens.dart';
import 'package:spender/dimens/stringFile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spender/model/expenseModel.dart';
import 'package:string_validator/string_validator.dart';

import 'homeScreen.dart';

class AddExpenses extends StatelessWidget {
  bool isToday = false;

  AddExpenses(this.isToday);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: ColorsFile().primaryColor,
        fontFamily: 'Poppins',
      ),
      home: AddExpensesPage(this.isToday),
    );
  }
}

class AddExpensesPage extends StatefulWidget {
  bool isToday = false;

  AddExpensesPage(this.isToday);

  @override
  _AddExpensesPageState createState() => _AddExpensesPageState();
}

class _AddExpensesPageState extends State<AddExpensesPage> {
  BuildContext bcontext;
  bool isAdded = false;
  List<dynamic> todayslist = [];
  String userName = "", isLogin = "", passWord = "";
  String formattedDate, currentDay;
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descController = TextEditingController();
  final amountController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime.now());
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        getTodaysList();
      });
  }

  @override
  Widget build(BuildContext context) {
    bcontext = context;
    return WillPopScope(child: Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          centerTitle: true,
          title: new Text(
            widget.isToday ? "Add Today Expenses" : "Add Past Day Expenses",
            style: new TextStyle(color: Colors.white),
          ),
        ),
        body: isAdded
            ? Center(
          child: CircularProgressIndicator(),
        )
            : SingleChildScrollView(
          child: widget.isToday ? addToday() : addPastDay(),
        )), onWillPop: _onWillPop);
  }

  Widget addToday() {
    return Form(
      key: _formKey,
      child: Container(
        margin: EdgeInsets.all(15),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width / 2.5,
                  margin: EdgeInsets.only(right: 10),
                  child: TextFormField(
                    maxLines: 1,
                    controller: titleController,
                    style: TextStyle(fontFamily: "Poppins", fontSize: 14),
                    decoration: InputDecoration(
                      hintText: "Expense Title",
                      labelText: StringFiles.title,
                      enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: ColorsFile().primaryColor),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: ColorsFile().positiveColor),
                      ),
                    ),
                    keyboardType: TextInputType.text,
                    obscureText: false,
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'Please Enter Title';
                      }
                      if(text.length<3)
                      {
                        return "Title is too small";
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 2.5,
                  margin: EdgeInsets.only(left: 20),
                  child: TextFormField(
                    maxLines: 1,
                    inputFormatters: [new WhitelistingTextInputFormatter(RegExp("[0-9]")),],
                    controller: amountController,
                    style: TextStyle(fontFamily: "Poppins", fontSize: 14),
                    decoration: InputDecoration(
                      hintText: "Spent Amount",
                      labelText: StringFiles.amount,
                      enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: ColorsFile().primaryColor),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: ColorsFile().positiveColor),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    obscureText: false,
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'Please Enter Your Amount';
                      } else if (!isNumeric(text)) {
                        return 'Enter Valid Amount';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              // margin: EdgeInsets.fromLTRB(0, dimens.baseTextMargin, 0, 0),
              child: TextFormField(
                maxLines: 1,
                controller: descController,
                style: TextStyle(fontFamily: "Poppins", fontSize: 14),
                decoration: InputDecoration(
                  hintText: "Expense Description",
                  labelText: StringFiles.descrption,
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: ColorsFile().primaryColor),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: ColorsFile().positiveColor),
                  ),
                  prefixIcon: Icon(
                    Icons.description,
                    color: ColorsFile().primaryColor,
                  ),
                ),
                keyboardType: TextInputType.text,
                obscureText: false,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              alignment: Alignment.topLeft,
              child: Text(
                widget.isToday
                    ? "This Expense added to Today's expenses list"
                    : "This Expense is added to expenses list",
                maxLines: 2,
                style: TextStyle(fontSize: 14, fontFamily: "Poppins"),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 5),
              alignment: Alignment.topLeft,
              child: Text(
                widget.isToday ? formattedDate : selectedDate,
                style: TextStyle(
                    fontSize: 16,
                    fontFamily: "Poppins",
                    color: ColorsFile().positiveColor),
              ),
            ),
            Container(
              alignment: Alignment.center,
              width: double.infinity,
              margin: EdgeInsets.only(top: 10, left: 40, right: 40, bottom: 10),
              child: RaisedButton(
                color: ColorsFile().fabColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2.0),
                    side: BorderSide(color: ColorsFile().fabColor)),
                child: Text(
                  "Add Expense",
                  style: TextStyle(fontFamily: "Poppins", fontSize: 14),
                ),
                onPressed: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  expenseValidation();
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  expenseValidation() {
    var isSuccess = false;
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      if (!widget.isToday) {
        if (DateFormat('dd').format(selectedDate).toString() ==
            DateFormat('dd').format(DateTime.now()).toString()) {
          _scaffoldKey.currentState.showSnackBar(
              new SnackBar(
            content: Row(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width / 1.5,
                  child: new Text("Please Select past date!",
                      maxLines: 2,
                      style: TextStyle(fontFamily: "Poppins", fontSize: 14)),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    _scaffoldKey.currentState.hideCurrentSnackBar();

                  },
                  child: new Text("Ok",
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 16,
                          color: Colors.red)),
                )
              ],
            ),
          ));
        } else
          isSuccess = true;
      }
      if (widget.isToday) {
        weekSelection(DateTime.now());
      } else {
        if (isSuccess) weekSelection(selectedDate);
      }
    }
  }

  weekSelection(DateTime selectedDate) {
    var week;
    if (int.parse(DateFormat('dd').format(selectedDate)) <= 7)
      week = 1;
    else if (int.parse(DateFormat('dd').format(selectedDate)) > 7 &&
        int.parse(DateFormat('dd').format(selectedDate)) <= 14)
      week = 2;
    else if (int.parse(DateFormat('dd').format(selectedDate)) > 14 &&
        int.parse(DateFormat('dd').format(selectedDate)) <= 21)
      week = 3;
    else if (int.parse(DateFormat('dd').format(selectedDate)) > 21 &&
        int.parse(DateFormat('dd').format(selectedDate)) <= 28)
      week = 4;
    else
      week = 5;
    dialog("", "Are you sure want to add this Expense?", true,
        Colors.transparent, week);
  }

  addDetails(int week) {
    setState(() {
      isAdded = true;
    });
    var data;
    data = ExpenseModel(
      id: todayslist.isNotEmpty ? (todayslist[0]["id"] + 1) : 1,
      month: DateFormat('MMM')
          .format(widget.isToday ? DateTime.now() : selectedDate),
      year: DateFormat('yyyy')
          .format(widget.isToday ? DateTime.now() : selectedDate),
      date: int.parse(DateFormat('dd')
          .format(widget.isToday ? DateTime.now() : selectedDate)),
      day: widget.isToday
          ? currentDay
          : (DateFormat('EEEE').format(selectedDate).toString()).substring(0,3),
      title: titleController.text,
      amount: amountController.text,
      description: descController.text,
      week: week,
    );
    DBHelper().add(data);
    setState(() {
      todayslist.clear();
      getTodaysList();
      selectedDate = DateTime.now();
      isAdded = false;
      _scaffoldKey.currentState.showSnackBar(new SnackBar(
        content: Row(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width / 1.5,
              child: new Text("Expense Added Successfully",
                  maxLines: 2,
                  style: TextStyle(fontFamily: "Poppins", fontSize: 14)),
            ),
            Spacer(),
            GestureDetector(
              onTap: () {
                _scaffoldKey.currentState.hideCurrentSnackBar();
              },
              child: new Text("Ok",
                  style: TextStyle(
                      fontFamily: "Poppins", fontSize: 16, color: Colors.red)),
            )
          ],
        ),
      ));
      amountController.text = "";
      titleController.text = "";
      descController.text = "";
    });
  }

  Future getTodaysList() async {
    var list = await DBHelper().getTodaysList(
        int.parse(DateFormat('dd')
            .format(widget.isToday ? DateTime.now() : selectedDate)),
        int.parse(DateFormat('yyyy')
            .format(widget.isToday ? DateTime.now() : selectedDate)),
        DateFormat('MMM')
            .format(widget.isToday ? DateTime.now() : selectedDate));
    print(list.toString());
    await new Future.delayed(const Duration(seconds: 1));
    setState(() {
      todayslist.clear();
      if (!list.isEmpty) {
        for (int i = list.length - 1; i >= 0; i--) {
          todayslist.add(list[i]);
        }
      }
      print(todayslist.length.toString());
    });
  }

  Widget addPastDay() {
    return Form(
      key: _formKey,
      child: Container(
        margin: EdgeInsets.all(15),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  DateFormat('dd/MMM/yyyy').format(selectedDate).toString(),
                  style: TextStyle(
                    fontFamily: "Poppins",
                    color: Colors.black,
                    fontSize: 16,
                    decoration: TextDecoration.underline,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.date_range,
                    color: Colors.purple,
                  ),
                  onPressed: () {
                    _selectDate(bcontext);
                  },
                )
              ],
            ),
            Row(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width / 2.5,
                  margin: EdgeInsets.only(right: 10),
                  child: TextFormField(
                    maxLines: 1,
                    controller: titleController,
                    style: TextStyle(fontFamily: "Poppins", fontSize: 14),
                    decoration: InputDecoration(
                      hintText: "Expense Title",
                      labelText: StringFiles.title,
                      enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: ColorsFile().primaryColor),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: ColorsFile().positiveColor),
                      ),
                    ),
                    keyboardType: TextInputType.text,
                    obscureText: false,
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'Please Enter Title';
                      }
                      if(text.length<3)
                      {
                        return "Title is too small";
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 2.5,
                  margin: EdgeInsets.only(left: 20),
                  child: TextFormField(
                    maxLines: 1,
                    inputFormatters: [new WhitelistingTextInputFormatter(RegExp("[0-9]")),],
                    controller: amountController,
                    style: TextStyle(fontFamily: "Poppins", fontSize: 14),
                    decoration: InputDecoration(
                      hintText: "Spent Amount",
                      labelText: StringFiles.amount,
                      enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: ColorsFile().primaryColor),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: ColorsFile().positiveColor),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    obscureText: false,
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'Please Enter Your Amount';
                      } else if (!isNumeric(text)) {
                        return 'Enter Valid Amount';
                      } 
                      return null;
                    },
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              // margin: EdgeInsets.fromLTRB(0, dimens.baseTextMargin, 0, 0),
              child: TextFormField(
                maxLines: 1,
                controller: descController,
                style: TextStyle(fontFamily: "Poppins", fontSize: 14),
                decoration: InputDecoration(
                  hintText: "Expense Description",
                  labelText: StringFiles.descrption,
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: ColorsFile().primaryColor),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: ColorsFile().positiveColor),
                  ),
                  prefixIcon: Icon(
                    Icons.description,
                    color: ColorsFile().primaryColor,
                  ),
                ),
                keyboardType: TextInputType.text,
                obscureText: false,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              alignment: Alignment.topLeft,
              child: Text(
                widget.isToday
                    ? "This Expense added to Today's expenses list"
                    : "This Expense is added to expenses list",
                maxLines: 2,
                style: TextStyle(fontSize: 14, fontFamily: "Poppins"),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 5),
              alignment: Alignment.topLeft,
              child: Text(
                widget.isToday
                    ? formattedDate
                    : DateFormat('dd/MMM/yyyy').format(selectedDate).toString(),
                style: TextStyle(
                    fontSize: 16,
                    fontFamily: "Poppins",
                    color: ColorsFile().positiveColor),
              ),
            ),
            Container(
              alignment: Alignment.center,
              width: double.infinity,
              margin: EdgeInsets.only(top: 10, left: 40, right: 40, bottom: 10),
              child: RaisedButton(
                color: ColorsFile().fabColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2.0),
                    side: BorderSide(color: ColorsFile().fabColor)),
                child: Text(
                  "Add Expense",
                  style: TextStyle(fontFamily: "Poppins", fontSize: 14),
                ),
                onPressed: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  expenseValidation();
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    if (widget.isToday) {
      getTodaysList();
    }
    currentDay = DateFormat('EEEE').format(DateTime.now());
    currentDay = currentDay.substring(0, 3);
    formattedDate = DateFormat('dd/MMM/yyyy').format(DateTime.now());
    getUserName();
  }

  getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userName = prefs.getString(StringFiles().fullName);
    passWord = prefs.getString(StringFiles().password);
    isLogin = prefs.getString(StringFiles().isLogined);
    print(userName);
  }
  Future<bool> _onWillPop() async {
    Navigator.of(bcontext).pushReplacement(
      MaterialPageRoute(builder: (_) {
        return SpenderHome();
      }),
    );
  }

  dialog(String title, String desc, bool isAllbutton, Color symbolColor, week) {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
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
              margin: EdgeInsets.only(top: 5),
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
                              "Cancel",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                color: Colors.red,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: FlatButton(
                            onPressed: () {
                              addDetails(week);
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "Submit",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                color: ColorsFile().positiveColor,
                                fontSize: 16,
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
                          addDetails(week);
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "Submit",
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
}
