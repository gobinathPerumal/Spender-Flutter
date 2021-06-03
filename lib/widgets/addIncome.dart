import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_strip/month_picker_strip.dart';
import 'package:spender/color/appcolors.dart';
import 'package:spender/database/DBHelper.dart';
import 'package:spender/dimens/appDimens.dart';
import 'package:spender/dimens/stringFile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spender/model/expenseModel.dart';
import 'package:spender/model/incomeModel.dart';
import 'package:spender/widgets/listIncome.dart';
import 'package:string_validator/string_validator.dart';

import 'homeScreen.dart';

class AddIncome extends StatelessWidget {
  bool isList=false;
  DateTime selectedMonth;
  AddIncome(this.isList,this.selectedMonth);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: ColorsFile().primaryColor,
        fontFamily: 'Poppins',
      ),
      home: AddIncomePage(this.isList,this.selectedMonth),
    );
  }
}

class AddIncomePage extends StatefulWidget {
  bool isList=false;
  DateTime selectedMonth;
  AddIncomePage(this.isList,this.selectedMonth);

  @override
  _AddIncomePageState createState() => _AddIncomePageState();
}

class _AddIncomePageState extends State<AddIncomePage> {
  BuildContext bcontext;

  bool isAdded = false;
  DateTime selectedMonth;
  List<dynamic>  monthItemList = [];
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    bcontext = context;
    return WillPopScope(child: Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          centerTitle: true,
          title: new Text(
            "Add Income",
            style: new TextStyle(color: Colors.white),
          ),
        ),
        body: isAdded
            ? Center(
          child: CircularProgressIndicator(),
        )
            : Column(children: <Widget>[

          new Divider(
            height: 1.0,
          ),
          new MonthStrip(
            format: 'MMM yyyy',
            from: new DateTime(2020, 1),
            to: new DateTime(2030, 1),
            initialMonth: selectedMonth,
            height: 48.0,
            viewportFraction: 0.25,
            onMonthChanged: (v) {
              setState(() {
                selectedMonth = v;
                getCurrentMonthList();
              });
            },
          ),
          new Divider(
            height: 1.0,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: addIncome(),
            ),
          )
        ],)), onWillPop: _onWillPop);
  }

  Widget addIncome() {
    return Form(
      key: _formKey,
      child: Container(
        margin: EdgeInsets.all(15),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 10),
              child: TextFormField(
                maxLines: 1,
                controller: titleController,
                style: TextStyle(fontFamily: "Poppins", fontSize: 14),
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.title,
                    color: ColorsFile().primaryColor,
                  ),
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
              margin: EdgeInsets.only(top: 10),
              child: TextFormField(
                maxLines: 1,
                inputFormatters: [new WhitelistingTextInputFormatter(RegExp("[0-9]")),],
                controller: amountController,
                style: TextStyle(fontFamily: "Poppins", fontSize: 14),
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.attach_money,
                    color: ColorsFile().primaryColor,
                  ),
                  hintText: "Income Amount",
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
            Container(
              margin: EdgeInsets.only(top: 20),
              alignment: Alignment.topLeft,
              child: Text(
                    "This Income is added to your Income list",
                maxLines: 2,
                style: TextStyle(fontSize: 14, fontFamily: "Poppins"),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 5),
              alignment: Alignment.topLeft,
              child: Text(
                  DateFormat('MMM')
                      .format(selectedMonth).toString()+"/"+DateFormat('yyyy')
                      .format(selectedMonth).toString(),
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
                  "Add Income",
                  style: TextStyle(fontFamily: "Poppins", fontSize: 14),
                ),
                onPressed: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  incomeValidation();
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  incomeValidation() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      dialog("", "Are you sure want to add this Income?", true,
          Colors.transparent);
    }
  }


  addDetails() {
    setState(() {
      isAdded = true;
    });
    var data;

    data = IncomeModel(
      id:  monthItemList.isNotEmpty ? ( monthItemList[0]["id"] + 1) : 1,
      month: DateFormat('MMM')
          .format(selectedMonth),
      year: DateFormat('yyyy')
          .format(selectedMonth),
      title: titleController.text,
      amount: amountController.text,
    );
    DBHelper().addIncome(data);
    setState(() {
       monthItemList.clear();
       getCurrentMonthList();
        isAdded = false;
      _scaffoldKey.currentState.showSnackBar(new SnackBar(
        content: Row(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width / 1.5,
              child: new Text("Income Added Successfully",
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
    });
  }

  Future getCurrentMonthList() async {
    var list = await DBHelper().getIncomeMonthList(
        int.parse(DateFormat('yyyy')
            .format(selectedMonth)),
        DateFormat('MMM')
            .format(selectedMonth));
    print(list.toString());
    await new Future.delayed(const Duration(seconds: 1));
    setState(() {
       monthItemList.clear();
      if (!list.isEmpty) {
        for (int i = list.length - 1; i >= 0; i--) {
           monthItemList.add(list[i]);
        }
      }
      print( monthItemList.length.toString());
    });
  }


  @override
  void initState() {
    selectedMonth=widget.selectedMonth;
    getCurrentMonthList();
  }

  Future<bool> _onWillPop() async {
  if(widget.isList)
    {
      Navigator.pushAndRemoveUntil(bcontext,  MaterialPageRoute(builder: (_) {
        return ListIncome();
      }), (e) => false);
    }
  else{
    Navigator.of(bcontext).pushReplacement(
      MaterialPageRoute(builder: (_) {
        return SpenderHome();
      }),
    );
  }
  }

  dialog(String title, String desc, bool isAllbutton, Color symbolColor) {
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
                              addDetails();
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
                          addDetails();
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "Submit",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            color: ColorsFile.headerColor,
                            fontSize: 16,
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
