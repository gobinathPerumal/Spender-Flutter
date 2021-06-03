import 'dart:async';
import 'dart:io';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
import 'package:spender/widgets/addOthers.dart';
import 'package:spender/widgets/editOthers.dart';
import 'package:string_validator/string_validator.dart';

import 'addIncome.dart';
import 'homeScreen.dart';

class ListBorrow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: ColorsFile().primaryColor,
        fontFamily: 'Poppins',
      ),
      home: ListBorrowPage(),
    );
  }
}

class ListBorrowPage extends StatefulWidget {
  ListBorrowPage();

  @override
  _ListBorrowPageState createState() => _ListBorrowPageState();
}

class _ListBorrowPageState extends State<ListBorrowPage> {
  BuildContext bcontext;
  bool isGetItem = false;
  bool isSearchGetItem = false;
  bool isListEmpty = false;
  bool isSearchListEmpty = false;
  List<dynamic> borrowItemList = [];
  List<String> searchList = [];
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String currentText = "";
  String statusSelction;
  List<String> statusItems = ["All","Initial","In-Progress","Completed"];
  @override
  Widget build(BuildContext context) {
    bcontext = context;
    return WillPopScope(
        child: Scaffold(
            key: _scaffoldKey,
            appBar: new AppBar(
              centerTitle: true,
              title: new Text(
                "Borrowing List",
                style: new TextStyle(color: Colors.white),
              ),
                ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: ColorsFile().fabColor,
              onPressed: () {
                Navigator.pushAndRemoveUntil(bcontext,
                    MaterialPageRoute(builder: (_) {
                  return AddOthers(true);
                }), (e) => false);
              },
              child: Icon(Icons.add),
            ),
            body: isGetItem
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    children: <Widget>[
                      isListEmpty
                          ? Expanded(
                              child: Center(
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
                                  padding: EdgeInsets.only(top: 25),
                                  child: Text(
                                    "No Records found !",
                                    maxLines: 2,
                                    style: TextStyle(
                                        fontFamily: 'Raleway',
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            )))
                          : Expanded(
                              child: listView(),
                            )
                    ],
                  )),
        onWillPop: _onWillPop);
  }

  Widget listView() {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            height: 50,
            padding: EdgeInsets.only(top: 15,bottom: 10),
            child:  Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      height: 20.0,
                      width: 20.0,
                      color: Colors.transparent,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.lightBlueAccent,
                            borderRadius: BorderRadius.all(
                                Radius.circular(2.0))),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Text(
                        "Initial",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: "Poppins"),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Container(
                      height: 20.0,
                      width: 20.0,
                      color: Colors.transparent,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.all(
                                Radius.circular(2.0))),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Text(
                        "In-Progress",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: "Poppins"),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Container(
                      height: 20.0,
                      width: 20.0,
                      color: Colors.transparent,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.all(
                                Radius.circular(2.0))),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Text(
                        "Completed",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: "Poppins"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 10,right: 10),
            height: 50,
            child: Container(
              padding: EdgeInsets.all(10),
              decoration:  BoxDecoration(
                border: Border.all(
                    width: 0.7,
                  color: Colors.purple
                ),
                borderRadius: BorderRadius.all(
                    Radius.circular(20.0) //                 <--- border radius here
                ),
              ),
              child: Container(
                margin: EdgeInsets.only(
                   left: DimensFile().medium_padding),
                child: DropdownButton<String>(
                  value: statusSelction,
                  isExpanded: true,
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: ColorsFile().primaryColor,
                  ),
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(
                      fontFamily: "Poppins",
                      color: ColorsFile().listHeadingColor,
                      fontSize: DimensFile().listDescriptionText),
                  onChanged: (String data) {
                    FocusScope.of(context).requestFocus(FocusNode());
                    setState(() {
                      if(data!=statusItems[0])
                      {
                        isSearchGetItem=true;
                      }
                      if(data=="All")
                      {
                        isGetItem=true;
                        getAllBorrowList();
                      }
                      else
                      {
                        data==statusItems[1]?getSearchItems(0):data==statusItems[2]?getSearchItems(1):getSearchItems(2);
                      }
                      statusSelction = data;
                      print(statusSelction);
                    });
                  },
                  items: statusItems
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
            ),
          ),
          isSearchGetItem?Expanded(
            child: Center(
              child:CircularProgressIndicator(),
            ),
          ):
          isSearchListEmpty
              ? Expanded(
              child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Icon(
                          Icons.sentiment_dissatisfied,
                          size: 50,
                          color: Colors.purple.withOpacity(0.8),
                        ),
                      ),
                      Text(
                        "No Records found !",
                        maxLines: 2,
                        style: TextStyle(
                            fontFamily: 'Raleway',
                            fontSize: 16,
                            color: Colors.red,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  )))
              : Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(top: 10),
                child: Column(
                    children: borrowItemList
                        .map(
                          (item) => Container(
                        padding: EdgeInsets.only(top: 10),
                        child: GestureDetector(
                          child: Card(
                              elevation: 5,
                              color: Colors.white,
                              child: Container(
                                height: item["status"]!=0?150:110,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      height: item["status"]!=0?150:110,
                                      width: 10,
                                      color: item["status"]==0?Colors.lightBlueAccent:item["status"]==1?Colors.amber:Colors.green,
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                          Container(
                                            width: MediaQuery.of(context).size.width/1.5,
                                          padding: EdgeInsets.all(5),
                                          child:
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Container(
                                                padding: EdgeInsets.only(left: 10),
                                                child: Container(
                                                  child:Text(
                                                  item["date"].toString()+" "+item["month"].toString()+","+item["year"].toString()+"("+item["day"].toString().substring(0,3)+")",
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: 10,
                                                        fontFamily: "Poppins",
                                                        color: Colors.purple),
                                                  ),
                                                ),
                                              ),

                                              Container(
                                                padding: EdgeInsets.only(left: 10),
                                                child: Container(
                                                  child:Text(
                                                    "Amount      : Rs."+item["amount"].toString(),
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontFamily: "Poppins",
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                child: Center(
                                                  child: Container(
                                                    padding: EdgeInsets.only(left: 10,top: 3),
                                                    alignment: Alignment.centerLeft,
                                                    child: Text(
                                                      "LenderName : "+item["lenderName"],
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontFamily: "Poppins",),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: MediaQuery.of(context).size.width/1.5,
                                                child: Center(
                                                  child: Container(
                                                    padding: EdgeInsets.only(left: 10,top: 3),
                                                    alignment: Alignment.topLeft,
                                                    child: Text(
                                                      "Description    : "+item["description"],
                                                      overflow: TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontFamily: "Poppins",
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              item["status"]!=0?Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.only(left: 10),
                                                    child: Container(
                                                      child:Text(
                                                        "Updated: "+item["lastDate"].toString()+" "+item["lastMonth"].toString()+","+item["lastYear"].toString()+"("+item["day"].toString().substring(0,3)+")",
                                                        overflow: TextOverflow.ellipsis,
                                                        style: TextStyle(
                                                            fontSize: 10,
                                                            fontFamily: "Poppins",
                                                            color: Colors.blueGrey),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: MediaQuery.of(context).size.width/1.5,
                                                    child: Center(
                                                      child: Container(
                                                        padding: EdgeInsets.only(left: 10,top: 3),
                                                        alignment: Alignment.topLeft,
                                                        child: Text(
                                                          "Settled Amount  : Rs."+item["sendAmount"].toString(),
                                                          overflow: TextOverflow.ellipsis,
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                            fontSize: 13,
                                                            color: Colors.blueGrey,
                                                            fontFamily: "Poppins",
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ):Container(),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    Spacer(),

                                    item["status"]==2?Container(
                                      padding: EdgeInsets.all(15),
                                      child: IconButton(
                                          icon: Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                          onPressed: () {

                                            deletedialog("", "Are you sure want to delete this Borrow Details?", true,
                                                Colors.transparent, item);}),
                                    ):
                                    Container(
                                      padding: EdgeInsets.all(15),
                                      child: IconButton(
                                          icon: Icon(
                                            Icons.menu,
                                            color: Colors.red,
                                          ),
                                          onPressed: () {
                                            _modalBottomOptions(item);
                                          }),
                                    ),
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
            ),
          ),
        ],
      ),
    );
  }

  Future deleteItem(item) async {
    setState(() {
      isGetItem = true;
    });
    DBHelper().deleteBorrowItemIncome(item["id"]);
    getAllBorrowList();
  }

  Future getAllBorrowList() async {
    var list = await DBHelper().getAllBorrowerList();
    print(list.toString());
    await new Future.delayed(const Duration(seconds: 1));
    setState(() {
      borrowItemList.clear();
      searchList.clear();
      isGetItem = false;
      if (!list.isEmpty) {
        isListEmpty = false;
        for (int i = list.length - 1; i >= 0; i--) {
          borrowItemList.add(list[i]);
          print("hi");
        }
        isListEmpty=false;
        isSearchListEmpty=false;
        isSearchGetItem=false;
      } else {
        isListEmpty = true;
      }
      print(borrowItemList.length.toString());
    });
  }

  @override
  void initState() {
    statusSelction="All";
    isGetItem = true;
    getAllBorrowList();
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
                            ); // To close the dialog
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

  void _modalBottomOptions(item) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd/MMM/yyyy').format(now);
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return new Container(
            height: 200.0,
            color: Colors.transparent,
            //could change this to Color(0xFF737373),
            //so you don't have to change MaterialApp canvasColor//addTransaction(formattedDate)
            child: new Container(
                child: Container(
                  color: ColorsFile().appBackgroundColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                              height: 100,
                              width: 100,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pushAndRemoveUntil(bcontext,
                                      MaterialPageRoute(builder: (_) {
                                        return EditOthers(true,item);
                                      }), (e) => false);
                                },
                                child: Card(
                                    elevation: 5,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          width:40,
                                          height: 40,
                                          padding: EdgeInsets.only(top: 10),
                                         child: Icon(Icons.edit,color: Colors.purple,),
                                        ),
                                        Container(
                                          width: 100,
                                          padding: EdgeInsets.only(left: 12, right: 6),
                                          child: Container(
                                            alignment: Alignment.center,
                                            child: Text(
                                              "Edit",
                                              maxLines: 2,
                                              style: TextStyle(
                                                  fontSize: 14, fontFamily: "Poppins"),
                                            ),
                                          ),
                                        )
                                      ],
                                    )),
                              ),
                            ),
                            Container(
                              height: 100,
                              width: 100,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                  deletedialog("", "Are you sure want to delete this Borrow Details?", true,
                                      Colors.transparent, item);
                                  },
                                child: Card(
                                    elevation: 5,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          width:40,
                                          height: 40,
                                          padding: EdgeInsets.only(top: 10),
                                          child:Icon(Icons.delete,color: Colors.red,),
                                        ),
                                        Container(
                                          width: 100,
                                          padding: EdgeInsets.only(left: 12, right: 6),
                                          child: Container(
                                            alignment: Alignment.center,
                                            child: Text(
                                              "Delete",
                                              maxLines: 2,
                                              style: TextStyle(
                                                  fontSize: 14, fontFamily: "Poppins"),
                                            ),
                                          ),
                                        )
                                      ],
                                    )),
                              ),
                            )
                          ],
                        ),
                      ],
                    ))),
          );
        });
  }

  getSearchItems(status) async{
    var list = await DBHelper().getBorrowerStatusList(status);
    print(list.toString());
    await new Future.delayed(const Duration(seconds: 1));
    setState(() {
      borrowItemList.clear();
      isSearchGetItem = false;
      if (!list.isEmpty) {
        isSearchListEmpty = false;
        for (int i = list.length - 1; i >= 0; i--) {
          borrowItemList.add(list[i]);
        }
      } else {
        isSearchListEmpty = true;
      }
      print(borrowItemList.length.toString());
    });
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
