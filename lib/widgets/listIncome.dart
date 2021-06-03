import 'dart:async';
import 'dart:io';
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
import 'package:string_validator/string_validator.dart';

import 'addIncome.dart';
import 'homeScreen.dart';

class ListIncome extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: ColorsFile().primaryColor,
        fontFamily: 'Poppins',
      ),
      home: ListIncomePage(),
    );
  }
}

class ListIncomePage extends StatefulWidget {
  ListIncomePage();

  @override
  _ListIncomePageState createState() => _ListIncomePageState();
}

class _ListIncomePageState extends State<ListIncomePage> {
  BuildContext bcontext;
  bool isGetItem = false;
  bool isListEmpty = false;
  int totalAmount=0;
  DateTime selectedMonth;
  List<dynamic>  monthItemList = [];
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    bcontext = context;
    return WillPopScope(
        child: Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          centerTitle: true,
          title: new Text(
            "MonthWise Income List",
            style: new TextStyle(color: Colors.white),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: ColorsFile().fabColor,
          onPressed: () {
            Navigator.pushAndRemoveUntil(bcontext,  MaterialPageRoute(builder: (_) {
              return AddIncome(true,selectedMonth);
            }), (e) => false);
          },
          child: Icon(Icons.add),
        ),
        body: isGetItem
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
                isGetItem=true;
                selectedMonth = v;
                getCurrentMonthList();
              });
            },
          ),
          new Divider(
            height: 1.0,
          ),
          isListEmpty?Expanded(child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.width/2,
                    width: MediaQuery.of(context).size.width/2,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("images/no_results_found.png"),
                          fit: BoxFit.fill),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(top: 25),
                    child: Text(
                      "No Incomes found for this Month !",
                      maxLines: 2,
                      style: TextStyle(
                          fontFamily: 'Raleway',
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ))):Expanded(child: SingleChildScrollView(
            child: listView(),
          ))
        ],)), onWillPop: _onWillPop);
  }

Widget listView()
{
  return Column(
    children: <Widget>[
      Container(
        padding: EdgeInsets.only(top: 10),
        child: Card(
            color: Colors.white,
            elevation: 10,
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                "This Month total Income : Rs. " + totalAmount.toString(),
                style: TextStyle(
                    color: Colors.green,
                    fontSize: 14,
                    fontFamily: "Poppins"),
              ),
            )),
      ),
      Container(
        padding: EdgeInsets.only(top: 10),
        child: Column(
            children: monthItemList
                .map(
                  (item) => Container(
                padding: EdgeInsets.only(top: 10),
                child: GestureDetector(
                  child: Card(
                      elevation: 5,
                      color: Colors.white,
                      child: Container(
                        height: 80,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              height: 80,
                              width: 10,
                              color: Colors.amber,
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 10),
                              width: 70.0,
                              child: Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 2,
                                      color:
                                      Colors.purple.withOpacity(0.8)),
                                  shape: BoxShape.circle,
                                  color: Colors.purple.withOpacity(0.9),
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: <Widget>[
                                    Center(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            margin: EdgeInsets.only(left:3,right: 3),
                                            height: 12,
                                            width: 12,
                                            decoration: BoxDecoration(
                                              color: Colors.purple,
                                              image: DecorationImage(
                                                  image: AssetImage("images/rupee_purple.png"),
                                                  fit: BoxFit.fill),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              item["amount"].toString(),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontFamily: "Poppins",
                                                  color: Colors.white),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              child: Center(
                                child: Container(
                                  padding: EdgeInsets.only(left: 10),
                                  width: MediaQuery.of(context)
                                      .size
                                      .width /
                                      2.4,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    item["title"],
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                            Spacer(),
                            Container(
                              padding: EdgeInsets.all(15),
                              child: IconButton(icon: Icon(Icons.delete,color: Colors.red,), onPressed: ()
                              {
                                deletedialog("", "Are you sure want to delete this Income?", true,
                                    Colors.transparent, item);
                              }),
                            )
                          ],
                        ),
                      )),
                  onTap: () {
                   // showListDetails(item);
                  },
                ),
              ),
            )
                .toList()),
      ),
    ],
  );
}

  Future deleteItem(item)async{
    setState(() {
      isGetItem=true;
    });
    DBHelper().deleteMonthItemIncome(item["id"], item["month"],item["year"]);
    getCurrentMonthList();
    /*
    for (int i = 0; i < monthItemList.length; i++) {
      if (monthItemList[i]["id"] == id) {
        monthItemList.removeAt(i);
        break;
      }
    }*/


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
       isGetItem=false;
      if (!list.isEmpty) {
        isListEmpty=false;
        for (int i = list.length - 1; i >= 0; i--) {
           monthItemList.add(list[i]);
        }
        calculateTotalAmount();
      }
      else
        {
          isListEmpty=true;
        }
      print( monthItemList.length.toString());
    });
  }


  @override
  void initState() {
    isGetItem=true;
    selectedMonth = new DateTime(
        int.parse(DateFormat('yyyy').format(DateTime.now())),
        int.parse(DateFormat('MM').format(DateTime.now())));
    getCurrentMonthList();
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: bcontext,
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
              "Are you want to leave this page ?",
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
                        Navigator.of(context).pop();
                        Navigator.of(bcontext).pushReplacement(
                          MaterialPageRoute(builder: (_) {
                            return SpenderHome();
                          }),
                        );// To close the dialog
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
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "Yes",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                color: ColorsFile().positiveColor,
                                fontSize: DimensFile.text_medium,
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
          ],
        ),
      ),
    );
  }

  calculateTotalAmount() {
    totalAmount=0;
    for(int i=0;i<monthItemList.length;i++)
    {
      if(monthItemList[i]["amount"].toString().isNotEmpty)
      {
        totalAmount=totalAmount+monthItemList[i]["amount"];
      }
    }
  }

  deletedialog(String title, String desc, bool isAllbutton, Color symbolColor,dynamic item) {
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
                              "No",
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
                              deleteItem(item);
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "Yes",
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
