import 'dart:io';

import 'package:date_util/date_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_strip/month_picker_strip.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spender/color/appcolors.dart';
import 'package:spender/database/DBHelper.dart';
import 'package:spender/datePicker/monthPicker.dart';
import 'package:spender/dimens/appDimens.dart';
import 'package:spender/dimens/stringFile.dart';
import 'package:spender/model/chartModel.dart';
import 'package:spender/model/expenseModel.dart';
import 'package:spender/model/homeChartModel.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:spender/utils/DateUtils.dart';
import 'package:spender/widgets/addExpenses.dart';
import 'package:spender/widgets/addIncome.dart';
import 'package:spender/widgets/listBorrow.dart';
import 'package:spender/widgets/listLend.dart';
import 'package:spender/widgets/monthChartView.dart';
import 'package:spender/widgets/viewAllList.dart';
import 'package:spender/widgets/weekChartView.dart';
import 'package:string_validator/string_validator.dart';

import 'addOthers.dart';
import 'drawerView.dart';
import 'homeChartView.dart';
import 'homeIncomeChartView.dart';
import 'homeListView.dart';
import 'listIncome.dart';

class SpenderHome extends StatefulWidget {
  @override
  _SpenderHomeState createState() => _SpenderHomeState();
}

class _SpenderHomeState extends State<SpenderHome> {
  bool isAddexpense = false;
  int selectedMenuItemId;
  bool isViewAll = false;
  bool isIncomeProgress = false;
  DateTime selectedWeekMonth;
  String selectedDate = "Today";
  DateTime selectedMonth;
  String userName, fullName, email;
  int index = 1;
  DateTime selectedChartMonth;
  List<dynamic> monthItemList = [];
  int totelChartMonthIncome = 0;
  int totelChartMonthExpense = 0;
  int filterindex = 1;
  int monthTotalAmount = 0;
  int weekTotalAmount = 0;
  List<dynamic> todayslist = [];
  List<dynamic> daywiseList = [];
  List<dynamic> monthlist = [];
  List<dynamic> monthExpenselist = [];
  List<dynamic> weekContentList = [];
  bool isMonthListAvailable = false;
  bool isWeekListAvailable = false;
  List<int> weekList = [0, 0, 0, 0];
  List<int> daysList = [0, 0, 0, 0, 0, 0, 0];
  List<dynamic> colorLists = [
    Color(0xFF16D8D8),
    Color(0xFFD84774),
    Color(0xFFFECA7A),
    Color(0xFFA77AB4)
  ];
  List<dynamic> weekColorLists = [
    Color(0xFFF7A500),
    Color(0xFFD95B52),
    Color(0xFF6CB1EC),
    Color(0xFFA77AB4),
    Color(0xFF3AC4BF),
    Color(0xFF675A74),
    Color(0xFF4A577D),
  ];
  String weekSelction = "1st Week";
  List<String> weekItems = ["1st Week", "2nd Week", "3rd Week", "4th Week"];
  bool isGetList = false;
  bool isGetMonthList = false;
  bool isGetWeekList = false;
  bool isGetDaysList = false;
  bool isGetDaysListAvailable = false;
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descController = TextEditingController();
  final amountController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String appBarTitle = "Expense DashBoard";
  String currentDay;
  int currentMonthDates, previousMonthDates, nextMonthDates, currentDate;
  List<HomeChartModel> chartModel = [];
  List<DateTime> weekdays = [];
  List<int> amountList = [0, 0, 0, 0, 0, 0, 0];
  List<String> dayList = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
  List<List<charts.Series>> monthChartList = List<List<charts.Series>>();
  List<List<charts.Series>> weekChartList = List<List<charts.Series>>();
  BuildContext bcontext;

  @override
  void initState() {
    descController.text = "";
    weekdays = DateUtils().weekDaysList();
    isAddexpense = true;
    homeChartValue();
    selectedWeekMonth = DateTime.now();
    selectedChartMonth = new DateTime(
        int.parse(DateFormat('yyyy').format(DateTime.now())),
        int.parse(DateFormat('MM').format(DateTime.now())));
    selectedMonth = new DateTime(
        int.parse(DateFormat('yyyy').format(DateTime.now())),
        int.parse(DateFormat('MM').format(DateTime.now())));
    getUserDetails();
    getTodaysList();
    super.initState();
  }

  homeChartValue() async {
    chartModel.clear();
    for (int i = 0; i < weekdays.length; i++) {
      var list = await gethomeDaysList(
          int.parse(DateFormat('dd').format(weekdays[i])),
          int.parse(DateFormat('yyyy').format(weekdays[i])),
          DateFormat('MMM').format(weekdays[i]).toString());
      if (!list.isEmpty) {
        amountList[i] = calculateTotalAmount(list);
        print(amountList[i]);
      } else {
        amountList[i] = 0;
      }
    }
    currentDay = DateFormat('EEEE').format(DateTime.now());
    currentDay = currentDay.substring(0, 3);
    print(currentDay);
    bool isDate = false;
    for (int item = 0; item < dayList.length; item++) {
      if (currentDay == dayList[item]) {
        isDate = true;
        chartModel.add(new HomeChartModel(
            dayList[item], amountList[item].toString(), true, false));
        continue;
      }
      if (isDate) {
        chartModel.add(new HomeChartModel(
            dayList[item], amountList[item].toString(), false, false));
      } else {
        chartModel.add(new HomeChartModel(
            dayList[item], amountList[item].toString(), false, true));
      }
    }
    setState(() {
      isAddexpense = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    bcontext = context;
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              appBarTitle,
              style: TextStyle(fontFamily: 'Poppins', fontSize: 14),
            ),
          ),
          drawer: DrawerView(userName, fullName, email),
          bottomNavigationBar: new BottomNavigationBar(
            currentIndex: index,
            onTap: (int index) {
              setState(() {
                isViewAll = false;
                this.index = index;
                if (index == 0) {
                  filterindex = 1;
                  appBarTitle = "DayWise Expenses";
                  isGetDaysListAvailable = false;
                  isGetDaysList = false;
                  selectedDate = "Today";
                  isViewAll = true;
                  getDaysList(
                      int.parse(DateFormat('dd').format(DateTime.now())),
                      int.parse(DateFormat('yyyy').format(DateTime.now())),
                      DateFormat('MMM').format(DateTime.now()).toString());
                  _modalBottomFilterExpense();
                }
                if (index == 1) {
                  appBarTitle = "Expense DashBoard";
                }
                if (index == 2) {
                  isIncomeProgress = true;
                  appBarTitle = "Income DashBoard";
                  getCurrentMonthList();
                  getMonthExpenseList();
                }
              });
            },
            items: <BottomNavigationBarItem>[
              new BottomNavigationBarItem(
                icon: new Icon(Icons.date_range),
                title: new Text(
                  "Expense Filter's",
                  style: TextStyle(fontFamily: "Poppins", fontSize: 12),
                ),
              ),
              new BottomNavigationBarItem(
                icon: new Icon(
                  Icons.home,
                ),
                title: new Text(isViewAll ? "Home" : index == 1 ? "" : "Home",
                    style: TextStyle(fontFamily: "Poppins", fontSize: 12)),
              ),
              new BottomNavigationBarItem(
                icon: new Icon(Icons.dashboard),
                title: new Text(
                  "Income",
                  style: TextStyle(fontFamily: "Poppins", fontSize: 12),
                ),
              ),
            ],
          ),
          floatingActionButton: isViewAll
              ? Container()
              : index == 1
                  ? FloatingActionButton(
                      backgroundColor: ColorsFile().fabColor,
                      onPressed: () {
                        _modalBottomAddExpense();
                      },
                      child: Icon(Icons.add),
                    )
                  : Container(),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          body: isViewAll && filterindex == 1
              ? daysContentList()
              : index == 1
                  ? homeScreenContent()
                  : index == 2
                      ? incomeDashboard()
                      : filterindex == 3
                          ? monthScreenContent()
                          : filterindex == 2
                              ? weekScreenContent()
                              : Container(),
        ),
        onWillPop: _onWillPop);
  }

  Widget incomeDashboard() {
    return isIncomeProgress
        ? Container(
            height: double.infinity,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : SingleChildScrollView(
            child: Column(
              children: <Widget>[
                new Divider(
                  height: 1.0,
                ),
                new MonthStrip(
                  format: 'MMM yyyy',
                  from: new DateTime(2020, 1),
                  to: new DateTime(2030, 1),
                  initialMonth: selectedChartMonth,
                  height: 48.0,
                  viewportFraction: 0.25,
                  onMonthChanged: (v) {
                    setState(() {
                      selectedChartMonth = v;
                      isIncomeProgress = true;
                      getCurrentMonthList();
                      getMonthExpenseList();
                    });
                  },
                ),
                new Divider(
                  height: 1.0,
                ),
                HomeIncomeChartView(totelChartMonthExpense,totelChartMonthIncome,totelChartMonthIncome>totelChartMonthExpense?totelChartMonthIncome-totelChartMonthExpense:0),
                Container(
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(10),
                          height: 120,
                          child: Card(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  DimensFile().borderRadius),
                            ),
                            elevation: 2,
                            child: Container(
                              padding: EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Container(
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.pushAndRemoveUntil(bcontext,
                                            MaterialPageRoute(builder: (_) {
                                          return AddIncome(
                                              false,
                                              new DateTime(
                                                  int.parse(DateFormat('yyyy')
                                                      .format(DateTime.now())),
                                                  int.parse(DateFormat('MM')
                                                      .format(
                                                          DateTime.now()))));
                                        }), (e) => false);
                                      },
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          CircleAvatar(
                                              backgroundColor: Colors.purple
                                                  .withOpacity(0.7),
                                              child: Icon(
                                                Icons.add,
                                                color: Colors.white,
                                              )),
                                          Container(
                                            padding: EdgeInsets.only(
                                                left: 12, right: 6),
                                            child: Container(
                                              alignment: Alignment.center,
                                              child: Text(
                                                "Add",
                                                maxLines: 2,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: "Poppins"),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.pushAndRemoveUntil(bcontext,
                                            MaterialPageRoute(builder: (_) {
                                          return ListIncome();
                                        }), (e) => false);
                                      },
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          CircleAvatar(
                                              backgroundColor: Colors.purple
                                                  .withOpacity(0.7),
                                              child: Icon(
                                                Icons.list,
                                                color: Colors.white,
                                              )),
                                          Container(
                                            padding: EdgeInsets.only(
                                                left: 12, right: 6),
                                            child: Container(
                                              alignment: Alignment.center,
                                              child: Text(
                                                "List",
                                                maxLines: 2,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: "Poppins"),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: GestureDetector(
                                      onTap: () {
                                        _modalBottomOthers();
                                      },
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          CircleAvatar(
                                              backgroundColor: Colors.purple
                                                  .withOpacity(0.7),
                                              child: Icon(
                                                Icons.note_add,
                                                color: Colors.white,
                                              )),
                                          Container(
                                            padding: EdgeInsets.only(
                                                left: 12, right: 6),
                                            child: Container(
                                              alignment: Alignment.center,
                                              child: Text(
                                                "Others",
                                                maxLines: 2,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: "Poppins"),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
  }

  void _modalBottomAddExpense() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd/MMM/yyyy').format(now);
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return new Container(
            height: 350.0,
            color: Colors.transparent,
            //could change this to Color(0xFF737373),
            //so you don't have to change MaterialApp canvasColor//addTransaction(formattedDate)
            child: new Container(
                child: Container(
                    child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 5, bottom: 30),
                  alignment: Alignment.center,
                  child: Text(
                    "Choose Expense Type",
                    style: TextStyle(
                        fontSize: 18,
                        fontFamily: "Poppins",
                        color: ColorsFile().primaryColor),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      height: 130,
                      width: 120,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushAndRemoveUntil(bcontext,
                              MaterialPageRoute(builder: (_) {
                            return AddExpenses(true);
                          }), (e) => false);
                        },
                        child: Card(
                            elevation: 5,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Icon(
                                    Icons.today,
                                    size: 50,
                                    color: ColorsFile().primaryColor,
                                  ),
                                ),
                                Container(
                                  width: 100,
                                  padding: EdgeInsets.only(left: 12, right: 6),
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Add Today Expenses",
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
                      height: 130,
                      width: 120,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushAndRemoveUntil(bcontext,
                              MaterialPageRoute(builder: (_) {
                            return AddExpenses(false);
                          }), (e) => false);
                        },
                        child: Card(
                            elevation: 5,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Icon(
                                    Icons.date_range,
                                    size: 50,
                                    color: ColorsFile().primaryColor,
                                  ),
                                ),
                                Container(
                                  width: 100,
                                  padding: EdgeInsets.only(left: 12, right: 6),
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Add Past Expenses",
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

  void _modalBottomFilterExpense() {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return new Container(
            height: 350.0,
            color: Colors.transparent,
            //could change this to Color(0xFF737373),
            //so you don't have to change MaterialApp canvasColor//addTransaction(formattedDate)
            child: new Container(
                child: Container(
                    child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 5, bottom: 30),
                  alignment: Alignment.center,
                  child: Text(
                    "Choose Expense Filter Type",
                    style: TextStyle(
                        fontSize: 18,
                        fontFamily: "Poppins",
                        color: ColorsFile().primaryColor),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      height: 130,
                      width: MediaQuery.of(context).size.width / 3.4,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop(); // To close the dialog
                          setState(() {
                            filterindex = 1;
                            appBarTitle = "DayWise Expenses List";
                            isGetDaysListAvailable = false;
                            isGetDaysList = false;
                            selectedDate = "Today";
                            isViewAll = true;
                            getDaysList(
                                int.parse(
                                    DateFormat('dd').format(DateTime.now())),
                                int.parse(
                                    DateFormat('yyyy').format(DateTime.now())),
                                DateFormat('MMM')
                                    .format(DateTime.now())
                                    .toString());
                          });
                        },
                        child: Card(
                            elevation: 5,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Icon(
                                    Icons.today,
                                    size: 50,
                                    color: ColorsFile().primaryColor,
                                  ),
                                ),
                                Container(
                                  width: 100,
                                  padding: EdgeInsets.only(left: 12, right: 6),
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Days",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
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
                      height: 130,
                      width: MediaQuery.of(context).size.width / 3.4,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop(); // To close the dialog
                          setState(() {
                            filterindex = 2;
                            appBarTitle = "WeekWise Expenses";
                            weekSelction = weekItems[0];
                            selectedWeekMonth = DateTime.now();
                            isWeekListAvailable = false;
                            isGetWeekList = false;
                            getWeekList();
                          });
                        },
                        child: Card(
                            elevation: 5,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Icon(
                                    Icons.date_range,
                                    size: 50,
                                    color: ColorsFile().primaryColor,
                                  ),
                                ),
                                Container(
                                  width: 100,
                                  padding: EdgeInsets.only(left: 12, right: 6),
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Week",
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
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
                      height: 130,
                      width: MediaQuery.of(context).size.width / 3.4,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop(); // To close the dialog
                          setState(() {
                            filterindex = 3;
                            appBarTitle = "MonthWise Expenses";
                            isMonthListAvailable = false;
                            isGetMonthList = false;
                            selectedMonth = new DateTime(
                                int.parse(
                                    DateFormat('yyyy').format(DateTime.now())),
                                int.parse(
                                    DateFormat('MM').format(DateTime.now())));
                            getMonthList();
                          });
                        },
                        child: Card(
                            elevation: 5,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Icon(
                                    Icons.calendar_today,
                                    size: 50,
                                    color: ColorsFile().primaryColor,
                                  ),
                                ),
                                Container(
                                  width: 100,
                                  padding: EdgeInsets.only(left: 12, right: 6),
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Month",
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
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

  Widget addTransaction(String formattedDate) {
    return SingleChildScrollView(
      child: Form(
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
                        return null;
                      },
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 2.5,
                    margin: EdgeInsets.only(left: 20),
                    child: TextFormField(
                      maxLines: 1,
                      keyboardType: TextInputType.numberWithOptions(
                          decimal: true, signed: false),
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
                      obscureText: false,
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Please Enter Your Amount';
                        } else if (text.contains(" ") ||
                            text.contains(",") ||
                            text.contains("-")) {
                          return 'Enter Valid Amount';
                        } else if (text.contains(".")) {
                          return "Enter Rounded Value";
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
                  "This Expense added to Today's expenses list",
                  maxLines: 2,
                  style: TextStyle(fontSize: 14, fontFamily: "Poppins"),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 5),
                alignment: Alignment.topLeft,
                child: Text(
                  formattedDate,
                  style: TextStyle(
                      fontSize: 16,
                      fontFamily: "Poppins",
                      color: ColorsFile().positiveColor),
                ),
              ),
              Container(
                alignment: Alignment.center,
                width: double.infinity,
                margin:
                    EdgeInsets.only(top: 10, left: 40, right: 40, bottom: 10),
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
                    expenseValidation();
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  showListDetails(dynamic item) {
    print(item.toString());
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DimensFile.padding),
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        child: Container(
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
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Expense Detail",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 20,
                              fontFamily: "Raleway",
                              fontWeight: FontWeight.bold,
                              color: Colors.red),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.share,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            String text = "";
                            if (item[""] != "") {
                              text = " Expense Details" +
                                  "\n" +
                                  "\n" +
                                  item["date"].toString() +
                                  " " +
                                  item["month"] +
                                  "," +
                                  item["year"].toString() +
                                  "(" +
                                  item["day"] +
                                  ")" +
                                  "\n" +
                                  "Expense Title : " +
                                  item["title"] +
                                  "\n" +
                                  "Description   : " +
                                  item["description"] +
                                  "\n" +
                                  "Amount      : " +
                                  item["amount"].toString() +
                                  "\n" +
                                  "\n" +
                                  "This information has shared from Spender Note App";
                            } else {
                              text = " Expense Details" +
                                  "\n" +
                                  "\n" +
                                  item["date"].toString() +
                                  " " +
                                  item["month"] +
                                  "," +
                                  item["year"].toString() +
                                  "(" +
                                  item["day"] +
                                  ")" +
                                  "\n" +
                                  "Expense Title : " +
                                  item["title"] +
                                  "\n" +
                                  "Amount      : " +
                                  item["amount"].toString() +
                                  "\n" +
                                  "\n" +
                                  "This information has shared from Spender Note App";
                            }
                            final RenderBox box = context.findRenderObject();
                            Share.share(text,
                                subject: "Expense Detail",
                                sharePositionOrigin:
                                    box.localToGlobal(Offset.zero) & box.size);
                          },
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 15, bottom: 10),
                      child: Text(
                        "Date: " +
                            item["date"].toString() +
                            " " +
                            item["month"] +
                            "," +
                            item["year"].toString() +
                            "(" +
                            item["day"] +
                            ")",
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: 14,
                            fontFamily: "Poppins"),
                      ),
                    ),
                    Text(
                      "Expense Title : " + item["title"],
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(fontSize: 16, fontFamily: "Poppins"),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    item["description"] == ""
                        ? Container()
                        : Text(
                            "Description   : " + item["description"],
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            style:
                                TextStyle(fontSize: 16, fontFamily: "Poppins"),
                          ),
                    item["description"] == ""
                        ? Container()
                        : SizedBox(
                            height: 20,
                          ),
                    Text(
                      "Amount      : " + item["amount"].toString(),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                          color: Colors.purple,
                          fontSize: 18,
                          fontFamily: "Poppins"),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: FlatButton(
                        onPressed: () {
                          // mainPage(context);
                          Navigator.of(context).pop(); // To close the dialog
                        },
                        child: Text(
                          "Ok",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            color: Colors.red,
                            fontSize: DimensFile.text_medium,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }

  Widget homeScreenContent() {
    return isAddexpense
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Container(
            child: Container(
              height: MediaQuery.of(context).size.height,
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  HomeChartView(chartModel),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 40,
                    padding: EdgeInsets.only(left: 10, right: 5),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.today,
                          color: Colors.black,
                        ),
                        Text(
                          " Today: ",
                          style: TextStyle(
                              fontFamily: "Poppins",
                              color: Colors.black,
                              fontSize: 16),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 5),
                          child: Text(
                            DateFormat('dd/MMM/yyyy')
                                    .format(DateTime.now())
                                    .toString() +
                                " ( " +
                                DateFormat('EEEE').format(DateTime.now()) +
                                " ).",
                            style: TextStyle(
                                fontFamily: "Poppins", color: Colors.green),
                          ),
                        ),
                      ],
                    ),
                  ),
                  todayslist.isNotEmpty
                      ? Expanded(
                          child: SingleChildScrollView(
                            child: HomeListView(
                                deletedialog, todayslist, showListDetails),
                          ),
                        )
                      : Expanded(
                          child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Card(
                            elevation: 10,
                            color: ColorsFile().appBackgroundColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  DimensFile().borderRadius),
                            ),
                            child: Center(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Icon(
                                    Icons.sentiment_dissatisfied,
                                    color: Colors.purple.withOpacity(0.8),
                                  ),
                                ),
                                Text(
                                  "Still, No Expenses are Added Today !",
                                  maxLines: 2,
                                  style: TextStyle(
                                      fontFamily: 'Raleway',
                                      fontSize: 16,
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            )),
                          ),
                        ))
                ],
              ),
            ),
          );
  }

  Widget monthScreenContent() {
    return isGetMonthList
        ? Container(
            color: ColorsFile().appBackgroundColor,
            child: new Column(
              children: <Widget>[
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
                      isGetMonthList = false;
                      selectedMonth = v;
                      getMonthList();
                    });
                  },
                ),
                new Divider(
                  height: 1.0,
                ),
                new Expanded(
                  child: new Center(
                    child: !isMonthListAvailable
                        ? Center(
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
                                  "No Expenses found for This Month",
                                  maxLines: 2,
                                  style: TextStyle(
                                      fontFamily: 'Raleway',
                                      fontSize: 18,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ))
                        : MonthChartView(
                            monthChartList,
                            monthTotalAmount.toString(),
                            weekList,
                            selectedMonth),
                  ),
                ),
              ],
            ),
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime d = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (d != null)
      setState(() {
        isGetDaysList = false;
        isGetDaysListAvailable = false;
        daywiseList.clear();
        getDaysList(
            int.parse(DateFormat('dd').format(d)),
            int.parse(DateFormat('yyyy').format(DateTime.now())),
            DateFormat('MMM').format(d));
        selectedDate = new DateFormat.yMMMMd("en_US").format(d);
      });
  }

  Widget daysContentList() {
    return isViewAll
        ? Container(
            width: double.infinity,
            padding: EdgeInsets.all(7),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          selectedDate,
                          style: TextStyle(
                            fontFamily: "Poppins",
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.date_range,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            _selectDate(context);
                          },
                        )
                      ],
                    ),
                  ],
                ),
                !isGetDaysList
                    ? Expanded(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : !isGetDaysListAvailable
                        ? Expanded(
                            child: SingleChildScrollView(
                              child: ViewAllList(
                                  deleteItem, daywiseList, showListDetails),
                            ),
                          )
                        : Expanded(
                            child: Container(
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
                                alignment: Alignment.center,
                                padding: EdgeInsets.only(top: 25),
                                child: Text(
                                  "No Expenses found for this Date !",
                                  maxLines: 2,
                                  style: TextStyle(
                                      fontFamily: 'Raleway',
                                      fontSize: 18,
                                      color: Colors.black,),
                                ),
                              ),
                            ],
                          )))),
              ],
            ),
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }

  Widget weekScreenContent() {
    return isGetWeekList
        ? Container(
            width: double.infinity,
            padding: EdgeInsets.all(12),
            color: ColorsFile().appBackgroundColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          DateFormat('MMM')
                                  .format(selectedWeekMonth)
                                  .toString() +
                              "/" +
                              DateFormat('yyyy')
                                  .format(selectedWeekMonth)
                                  .toString(),
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
                            showMonthPicker(
                                    context: context,
                                    firstDate: DateTime(DateTime.now().year),
                                    lastDate:
                                        DateTime(DateTime.now().year + 10, 9),
                                    initialDate:
                                        selectedWeekMonth ?? DateTime.now())
                                .then((date) => setState(() {
                                      if (date != null) {
                                        weekSelction = weekItems[1];
                                        selectedWeekMonth = date;
                                        isWeekListAvailable = false;
                                        isGetWeekList = false;
                                        getWeekList();
                                      }
                                    }));
                          },
                        )
                      ],
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerRight,
                        margin: EdgeInsets.all(10),
                        child: DropdownButton<String>(
                          value: weekSelction,
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: ColorsFile().primaryColor,
                          ),
                          iconSize: 24,
                          elevation: 16,
                          style: TextStyle(
                              fontFamily: "Poppins",
                              color: ColorsFile().listHeadingColor,
                              fontSize: 16),
                          underline: Container(
                            height: 2,
                            color: ColorsFile().primaryColor,
                          ),
                          onChanged: (String data) {
                            FocusScope.of(context).requestFocus(FocusNode());
                            setState(() {
                              weekSelction = data;
                              isWeekListAvailable = false;
                              isGetWeekList = false;
                              getWeekList();
                            });
                          },
                          items: weekItems
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value,
                                  style: TextStyle(
                                      fontFamily: "Poppins", fontSize: 14)),
                            );
                          }).toList(),
                        ),
                      ),
                    )
                  ],
                ),
                new Expanded(
                  child: new Center(
                    child: !isWeekListAvailable
                        ? Center(
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
                                  "No Expenses found for This Week",
                                  maxLines: 2,
                                  style: TextStyle(
                                      fontFamily: 'Raleway',
                                      fontSize: 18,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ))
                        : WeekChartView(
                            weekChartList,
                            weekTotalAmount.toString(),
                            daysList,
                            weekSelction,
                            selectedWeekMonth),
                  ),
                ),
              ],
            ),
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }

  expenseValidation() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      var week;
      if (int.parse(DateFormat('dd').format(DateTime.now())) <= 7)
        week = 1;
      else if (int.parse(DateFormat('dd').format(DateTime.now())) > 7 &&
          int.parse(DateFormat('dd').format(DateTime.now())) <= 14)
        week = 2;
      else if (int.parse(DateFormat('dd').format(DateTime.now())) > 14 &&
          int.parse(DateFormat('dd').format(DateTime.now())) <= 21)
        week = 3;
      else if (int.parse(DateFormat('dd').format(DateTime.now())) > 21 &&
          int.parse(DateFormat('dd').format(DateTime.now())) <= 28)
        week = 4;
      else
        week = 5;
      var data = ExpenseModel(
        id: todayslist.isNotEmpty ? todayslist.length + 1 : 1,
        month: DateFormat('MMM').format(DateTime.now()),
        year: DateFormat('yyyy').format(DateTime.now()),
        date: int.parse(DateFormat('dd').format(DateTime.now())),
        day: currentDay,
        title: titleController.text,
        amount: amountController.text,
        description: descController.text,
        week: week,
      );
      setState(() {
        isAddexpense = true;
      });
      DBHelper().add(data);
      homeChartValue();
      getTodaysList();
      amountController.text = "";
      titleController.text = "";
      descController.text = "";
      Navigator.pop(context);
    }
  }

  deleteItem(int id, int date, String month, int year) async {
    setState(() {
      isAddexpense = true;
    });
    for (int i = 0; i < todayslist.length; i++) {
      if (todayslist[i]["id"] == id) {
        todayslist.removeAt(i);
        break;
      }
    }
    DBHelper().delete(id, date);
    homeChartValue();
  }

  getUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userName = prefs.getString(StringFiles().userName);
    fullName = prefs.getString(StringFiles().fullName);
    email = prefs.getString(StringFiles().email);
    print(userName);
  }

  Future getTodaysList() async {
    var list = await DBHelper().getTodaysList(
        int.parse(DateFormat('dd').format(DateTime.now())),
        int.parse(DateFormat('yyyy').format(DateTime.now())),
        DateFormat('MMM').format(DateTime.now()).toString());
    print(list.toString());
    await new Future.delayed(const Duration(seconds: 1));
    setState(() {
      isAddexpense = false;
      isGetList = true;
      todayslist.clear();
      if (!list.isEmpty) {
        for (int i = list.length - 1; i >= 0; i--) {
          todayslist.add(list[i]);
        }
      }
      ;
    });
  }

  Future gethomeDaysList(int date, int year, String month) async {
    var list = await DBHelper().getTodaysList(date, year, month);
    if (list.isEmpty) {
      return [];
    } else {
      return list;
    }
  }

  Future getDaysList(int date, int year, String month) async {
    var list = await DBHelper().getTodaysList(date, year, month);
    print("hi" + list.toString());
    await new Future.delayed(const Duration(seconds: 1));
    setState(() {
      isGetDaysList = true;
      daywiseList.clear();
      if (!list.isEmpty) {
        for (int i = list.length - 1; i >= 0; i--) {
          daywiseList.add(list[i]);
        }
      } else {
        isGetDaysListAvailable = true;
      }
      ;
    });
  }

  Future getMonthList() async {
    var list = await DBHelper().getMonthList(
        DateFormat('MMM').format(selectedMonth).toString(),
        int.parse(DateFormat('yyyy').format(selectedMonth)));
    print(list.toString());
    await new Future.delayed(const Duration(seconds: 1));
    setState(() {
      isGetMonthList = true;
      monthlist.clear();
      if (!list.isEmpty) {
        isMonthListAvailable = true;
        monthlist.addAll(list);
        createMonthChartValues(monthlist);
      } else
        isMonthListAvailable = false;
    });
  }

  Future getWeekList() async {
    var week = weekSelction == weekItems[0]
        ? 1
        : weekSelction == weekItems[1]
            ? 2
            : weekSelction == weekItems[2] ? 3 : 4;
    var list = await DBHelper().getWeekList(
        DateFormat('MMM').format(selectedWeekMonth).toString(),
        int.parse(DateFormat('yyyy').format(selectedWeekMonth)),
        week);
    print(list.toString());
    await new Future.delayed(const Duration(seconds: 1));
    setState(() {
      isGetWeekList = true;
      weekContentList.clear();
      if (!list.isEmpty) {
        isWeekListAvailable = true;
        weekContentList.addAll(list);
        createWeekChartValues(weekContentList);
      } else
        isWeekListAvailable = false;
    });
  }

  createWeekChartValues(List weekContentList) {
    print(weekContentList);
    weekChartList.clear();
    weekTotalAmount = 0;
    daysList.clear();
    for (int i = 0; i < 7; i++) {
      daysList.add(0);
    }
    for (int i = 0; i < weekContentList.length; i++) {
      if (weekContentList[i]["amount"].toString().isNotEmpty)
        weekTotalAmount = weekTotalAmount + weekContentList[i]["amount"];
      if (weekContentList[i]["day"] == dayList[0] &&
          weekContentList[i]["amount"].toString().isNotEmpty)
        daysList[0] = daysList[0] + weekContentList[i]["amount"];
      else if (weekContentList[i]["day"] == dayList[1] &&
          weekContentList[i]["amount"].toString().isNotEmpty)
        daysList[1] = daysList[1] + weekContentList[i]["amount"];
      else if (weekContentList[i]["day"] == dayList[2] &&
          weekContentList[i]["amount"].toString().isNotEmpty)
        daysList[2] = daysList[2] + weekContentList[i]["amount"];
      else if (weekContentList[i]["day"] == dayList[3] &&
          weekContentList[i]["amount"].toString().isNotEmpty)
        daysList[3] = daysList[3] + weekContentList[i]["amount"];
      else if (weekContentList[i]["day"] == dayList[4] &&
          weekContentList[i]["amount"].toString().isNotEmpty)
        daysList[4] = daysList[4] + weekContentList[i]["amount"];
      else if (weekContentList[i]["day"] == dayList[5] &&
          weekContentList[i]["amount"].toString().isNotEmpty)
        daysList[5] = daysList[5] + weekContentList[i]["amount"];
      else if (weekContentList[i]["day"] == dayList[6] &&
          weekContentList[i]["amount"].toString().isNotEmpty)
        daysList[6] = daysList[6] + weekContentList[i]["amount"];
    }
    weekChartData(daysList);
  }

  createMonthChartValues(List monthlist) {
    monthChartList.clear();
    monthTotalAmount = 0;
    weekList.clear();
    for (int i = 0; i < 4; i++) {
      weekList.add(0);
    }
    for (int i = 0; i < monthlist.length; i++) {
      if (monthlist[i]["amount"].toString().isNotEmpty)
        monthTotalAmount = monthTotalAmount + monthlist[i]["amount"];
      if (monthlist[i]["week"] == 1 &&
          monthlist[i]["amount"].toString().isNotEmpty)
        weekList[0] = weekList[0] + monthlist[i]["amount"];
      else if (monthlist[i]["week"] == 2 &&
          monthlist[i]["amount"].toString().isNotEmpty)
        weekList[1] = weekList[1] + monthlist[i]["amount"];
      else if (monthlist[i]["week"] == 3 &&
          monthlist[i]["amount"].toString().isNotEmpty)
        weekList[2] = weekList[2] + monthlist[i]["amount"];
      else if (monthlist[i]["week"] == 4 &&
          monthlist[i]["amount"].toString().isNotEmpty)
        weekList[3] = weekList[3] + monthlist[i]["amount"];
    }
    monthChartData(weekList);
  }

  weekChartData(List<int> daysList) {
    print(daysList.toString());
    List<ChartModels> datas = [];
    for (int i = 0; i < daysList.length; i++) {
      datas.add(new ChartModels(i, dayList[i], daysList[i]));
    }
    List<charts.Series> tempChartList2 = List<charts.Series>();
    var tmpeChart2 = charts.Series<ChartModels, String>(
      id: 'BarChart',
      colorFn: (ChartModels chart, __) =>
          getChartColor(weekColorLists[chart.index]),
      domainFn: (ChartModels chart, _) => chart.xKey,
      measureFn: (ChartModels chart, _) => chart.values,
      data: datas,
      labelAccessorFn: (ChartModels chart, _) => '${chart.values}',
    );
    tempChartList2.add(tmpeChart2);
    weekChartList.add(tempChartList2);
  }

  monthChartData(List<int> weekList) {
    List<ChartModels> datas = [];
    for (int i = 0; i < weekList.length; i++) {
      datas.add(new ChartModels(i, "Week 0" + (i + 1).toString(), weekList[i]));
    }
    List<charts.Series> tempChartList2 = List<charts.Series>();
    var tmpeChart2 = charts.Series<ChartModels, String>(
      id: 'BarChart',
      colorFn: (ChartModels chart, __) =>
          getChartColor(colorLists[chart.index]),
      domainFn: (ChartModels chart, _) => chart.xKey,
      measureFn: (ChartModels chart, _) => chart.values,
      data: datas,
      labelAccessorFn: (ChartModels chart, _) => '${chart.values}',
    );
    tempChartList2.add(tmpeChart2);
    monthChartList.add(tempChartList2);
  }

  charts.Color getChartColor(Color color) {
    return charts.Color(
        r: color.red, g: color.green, b: color.blue, a: color.alpha);
  }

  calculateTotalAmount(List todayslist) {
    var totalAmount = 0;
    for (int i = 0; i < todayslist.length; i++) {
      if (todayslist[i]["amount"].toString().isNotEmpty) {
        totalAmount = totalAmount + todayslist[i]["amount"];
      }
    }
    return totalAmount;
  }

  Future<bool> _onWillPop() async {
    if (isViewAll) {
      return (await showDialog(
            context: bcontext,
            builder: (context) => new AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(DimensFile.padding),
              ),
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
                              Navigator.of(context)
                                  .pop(); // To close the dialog
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
                              setState(() {
                                index = 1;
                                isViewAll = false;
                              });
                              Navigator.of(context)
                                  .pop(); // To close the dialog
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
    } else {
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
                              Navigator.of(context)
                                  .pop(); // To close the dialog
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
                              Navigator.of(context)
                                  .pop(); // To close the dialog
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

  Future getCurrentMonthList() async {
    var list = await DBHelper().getIncomeMonthList(
        int.parse(DateFormat('yyyy').format(selectedChartMonth)),
        DateFormat('MMM').format(selectedChartMonth));
    print(list.toString());
    await new Future.delayed(const Duration(seconds: 1));
    setState(() {
      isIncomeProgress = false;
      monthItemList.clear();
      if (!list.isEmpty) {
        for (int i = list.length - 1; i >= 0; i--) {
          monthItemList.add(list[i]);
        }
        calculateMonthIncomeTotalAmount();
      } else {
        totelChartMonthIncome = 0;
      }
      print(monthItemList.length.toString());
    });
  }

  calculateMonthIncomeTotalAmount() {
    totelChartMonthIncome = 0;
    for (int i = 0; i < monthItemList.length; i++) {
      if (monthItemList[i]["amount"].toString().isNotEmpty) {
        totelChartMonthIncome =
            totelChartMonthIncome + monthItemList[i]["amount"];
      }
    }
  }

  calculateMonthExpenseTotalAmount() {
    print("hi");
    totelChartMonthExpense = 0;
    for (int i = 0; i < monthExpenselist.length; i++) {
      if (monthExpenselist[i]["amount"].toString().isNotEmpty) {
        totelChartMonthExpense =
            totelChartMonthExpense + monthExpenselist[i]["amount"];
      }
    }
    print(totelChartMonthExpense);
  }

  Future getMonthExpenseList() async {
    var list = await DBHelper().getMonthList(
        DateFormat('MMM').format(selectedChartMonth).toString(),
        int.parse(DateFormat('yyyy').format(selectedChartMonth)));
    print(list.toString());
    await new Future.delayed(const Duration(seconds: 1));
    setState(() {
      monthExpenselist.clear();
      if (!list.isEmpty) {
        monthExpenselist.addAll(list);
        isMonthListAvailable = true;
        calculateMonthExpenseTotalAmount();
      } else {
        totelChartMonthExpense = 0;
      }
    });
  }

  void _modalBottomOthers() {
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 5, bottom: 30),
                          alignment: Alignment.center,
                          child: Text(
                            "Choose Others Type",
                            style: TextStyle(
                                fontSize: 18,
                                fontFamily: "Poppins",
                                color: Colors.black),
                          ),
                        ),
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
                                        return ListBorrow();
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
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image:   AssetImage("images/borrow.png"),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 100,
                                          padding: EdgeInsets.only(left: 12, right: 6),
                                          child: Container(
                                            alignment: Alignment.center,
                                            child: Text(
                                              "Borrow",
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
                                  Navigator.pushAndRemoveUntil(bcontext,
                                      MaterialPageRoute(builder: (_) {
                                        return ListLend();
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
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image:   AssetImage("images/lend.png"),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 100,
                                          padding: EdgeInsets.only(left: 12, right: 6),
                                          child: Container(
                                            alignment: Alignment.center,
                                            child: Text(
                                              "Lend",
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
                              deleteItem(item["id"],item["date"],item["month"],item["year"]);
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
