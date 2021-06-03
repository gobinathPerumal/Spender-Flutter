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
import 'package:spender/model/borrowModel.dart';
import 'package:spender/model/expenseModel.dart';
import 'package:spender/model/lenderModel.dart';
import 'package:spender/widgets/listLend.dart';
import 'package:string_validator/string_validator.dart';

import 'homeScreen.dart';
import 'listBorrow.dart';

class EditOthers extends StatelessWidget {
  bool isBorrow = false;
  dynamic item;
  EditOthers(this.isBorrow, this.item);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: ColorsFile().primaryColor,
        fontFamily: 'Poppins',
      ),
      home: EditOthersPage(this.isBorrow,this.item),
    );
  }
}

class EditOthersPage extends StatefulWidget {
  bool isBorrow = false;
  dynamic item;

  EditOthersPage(this.isBorrow,this.item);

  @override
  _EditOthersPageState createState() => _EditOthersPageState();
}

class _EditOthersPageState extends State<EditOthersPage> {
  BuildContext bcontext;
  String statusSelction;
  List<String> statusItems = ["Initial","In-Progress","Completed"];
  bool isAdded = false;
  bool isStatusChange = false;
  List<dynamic> othersList = [];
  String formattedDate, currentDay;
  final _formKey = GlobalKey<FormState>();
  final othersController = TextEditingController();
  final othersamountController = TextEditingController();
  final descController = TextEditingController();
  final amountController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2030,12));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
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
            widget.isBorrow ? "Edit Borrow Details" : "Edit Lend Details",
            style: new TextStyle(color: Colors.white),
          ),
        ),
        body: isAdded
            ? Center(
          child: CircularProgressIndicator(),
        )
            : SingleChildScrollView(
          child: EditOthers(),
        )), onWillPop: _onWillPop);
  }


  expenseValidation() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

     if(isStatusChange)
       {
         if (othersamountController.text != null || othersamountController.text.isNotEmpty) {
           if(isNumeric(othersamountController.text))
           {
             print(othersamountController.text);
             dialog("", widget.isBorrow?"Are you sure want to update this Borrowing details?":"Are you sure want to update this Lending details?", true,
                 Colors.transparent);
           }
           else
           {
             _scaffoldKey.currentState.showSnackBar(new SnackBar(
               content: Row(
                 children: <Widget>[
                   Container(
                     width: MediaQuery.of(context).size.width / 1.5,
                     child: new Text("Please Enter Valid Setteled Amount",
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
           }
         }else{
           _scaffoldKey.currentState.showSnackBar(new SnackBar(
             content: Row(
               children: <Widget>[
                 Container(
                   width: MediaQuery.of(context).size.width / 1.5,
                   child: new Text("Please Enter Valid Setteled Amount",
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
         }
       }
     else{
       dialog("", widget.isBorrow?"Are you sure want to update this Borrowing details?":"Are you sure want to update this Lending details?", true,
           Colors.transparent);
     }

    }
  }

  addDetails() {
    setState(() {
      isAdded = true;
    });
    var data;
    if(widget.isBorrow)
      {
          data = BorrowModel(
            id: widget.item['id'],
            month: widget.item['month'],
            year: widget.item['year'].toString(),
            date:widget.item['date'],
            day: widget.item['day'],
            lenderName: othersController.text,
            amount: amountController.text,
            description: descController.text,
            status: statusSelction==statusItems[0]?0:statusSelction==statusItems[1]?1:2,
            lastDate: int.parse(DateFormat('dd')
                .format(selectedDate)),
            lastMonth: DateFormat('MMM')
                .format(selectedDate),
            lastYear:  DateFormat('yyyy')
                .format(selectedDate),
            sendAmount: statusSelction==statusItems[0]?0:int.parse(othersamountController.text),
          );
        DBHelper().updateBorrow(data,widget.item['id']);
      }
    else
      {
        data = LenderModel(
          id: widget.item['id'],
          month: widget.item['month'],
          year: widget.item['year'].toString(),
          date:widget.item['date'],
          day: widget.item['day'],
          borrowerName: othersController.text,
          amount: amountController.text,
          description: descController.text,
          status: statusSelction==statusItems[0]?0:statusSelction==statusItems[1]?1:2,
          lastDate: int.parse(DateFormat('dd')
              .format(selectedDate)),
          lastMonth: DateFormat('MMM')
              .format(selectedDate),
          lastYear:  DateFormat('yyyy')
              .format(selectedDate),
          sendAmount: statusSelction==statusItems[0]?0:int.parse(othersamountController.text),
        );
        DBHelper().updateLender(data,widget.item['id']);
      }
    setState(() {
      othersList.clear();
      selectedDate = DateTime.now();
      isAdded = false;

      amountController.text = "";
      othersController.text = "";
      descController.text = "";
    });
    widget.isBorrow?Navigator.pushAndRemoveUntil(bcontext,
        MaterialPageRoute(builder: (_) {
          return ListBorrow();
        }), (e) => false):Navigator.pushAndRemoveUntil(bcontext,
        MaterialPageRoute(builder: (_) {
          return ListLend();
        }), (e) => false);

  }

  Widget EditOthers() {
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
                    controller: othersController,
                    style: TextStyle(fontFamily: "Poppins", fontSize: 14),
                    decoration: InputDecoration(
                      hintText: widget.isBorrow?"Lender Name":"Borrower Name",
                      labelText: "Name",
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
                        return 'Please Enter Name';
                      }
                      if(!isAlpha(text))
                        {
                          return "Enter Valid Name";
                        }
                      if(text.length<3)
                        {
                          return "Name is Too Short";
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
                      hintText: widget.isBorrow?"Borrow Amount":"Lend Amount",
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
                    obscureText: false,
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'Please Enter Your Amount';
                      }
                      if (!isNumeric(text)) {
                        return 'Enter Valid Amount';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),

            Container(
              width: double.infinity,
              margin: EdgeInsets.fromLTRB(10, DimensFile().baseMargin, 0, 0),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.stars,
                    color: ColorsFile().primaryColor,
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(
                          DimensFile().medium_padding, 0, 0, 0),
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
                        underline: Container(
                          height: 1,
                          color: ColorsFile().primaryColor,
                        ),
                        onChanged: (String data) {
                          FocusScope.of(context).requestFocus(FocusNode());
                          setState(() {

                            if(data!=statusItems[0])
                              {
                                isStatusChange=true;
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
                  )
                ],
              ),
            ),

            isStatusChange?Container(
              margin: EdgeInsets.only(top: 10),
              // margin: EdgeInsets.fromLTRB(0, dimens.baseTextMargin, 0, 0),
              child: TextFormField(
                maxLines: 1,
                controller: othersamountController,
                style: TextStyle(fontFamily: "Poppins", fontSize: 14),
                decoration: InputDecoration(
                  hintText: "Settled Amount",
                  labelText: StringFiles.amount,
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: ColorsFile().primaryColor),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: ColorsFile().positiveColor),
                  ),
                  prefixIcon: Icon(
                    Icons.attach_money,
                    color: ColorsFile().primaryColor,
                  ),
                ),
                keyboardType: TextInputType.text,
                obscureText: false,
              ),
            ):Container(),
            Container(
              margin: EdgeInsets.only(top: 10),
              // margin: EdgeInsets.fromLTRB(0, dimens.baseTextMargin, 0, 0),
              child: TextFormField(
                maxLines: 1,
                controller: descController,
                style: TextStyle(fontFamily: "Poppins", fontSize: 14),
                decoration: InputDecoration(
                  hintText: widget.isBorrow?"Borrowing Purpose":"Lending Reason",
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

                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return 'Please Enter Description';
                  }
                  if(text.length<8)
                  {
                    return "Description is too small";
                  }
                  return null;
                },
              ),
            ),
            Container(
              alignment: Alignment.center,
              width: double.infinity,
              margin: EdgeInsets.only(top: 20, left: 40, right: 40, bottom: 10),
              child: RaisedButton(
                color: ColorsFile().fabColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2.0),
                    side: BorderSide(color: ColorsFile().fabColor)),
                child: Text(
                  "Submit Details",
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
    othersamountController.text=widget.item["sendAmount"]!=0?widget.item["sendAmount"].toString():"";
    isStatusChange=widget.item["status"]!=0?true:false;
    statusSelction=widget.item["status"]==0?"Initial":widget.item["status"]==1?"In-Progress":"Completed";
    amountController.text=widget.item["amount"].toString();
    othersController.text=widget.isBorrow?widget.item["lenderName"]:widget.item["borrowerName"];
    descController.text=widget.item["description"];
    print(widget.isBorrow);
    currentDay = DateFormat('EEEE').format(DateTime.now());
    currentDay = currentDay.substring(0, 3);
    formattedDate = DateFormat('dd/MMM/yyyy').format(DateTime.now());
  }

  Future<bool> _onWillPop() async {
  if(widget.isBorrow)
    {
      Navigator.pushAndRemoveUntil(bcontext,
          MaterialPageRoute(builder: (_) {
            return ListBorrow();
          }), (e) => false);
    }
  else
    {
      Navigator.pushAndRemoveUntil(bcontext,
          MaterialPageRoute(builder: (_) {
            return ListLend();
          }), (e) => false);
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
                              addDetails();
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
