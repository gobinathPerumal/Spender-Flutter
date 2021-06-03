import 'dart:convert';
import 'dart:io' as io;


import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:spender/model/borrowModel.dart';
import 'package:spender/model/expenseModel.dart';
import 'package:spender/model/incomeModel.dart';
import 'package:spender/model/lenderModel.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database _db;

  var expenseData = ExpenseModel() ;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDatabase();
    return _db;
  }

  //Create Database
  initDatabase() async {
      io.Directory documentDirectory = await getApplicationDocumentsDirectory();
      String path = join(documentDirectory.path, 'expenseData.db');
      var db = await openDatabase(path, version: 1, onCreate: _onCreate);
      return db;
  }
 /* initJiraDatabase() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var dbStatus=await prefs.getString('dbStatus');
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'chartData.db');
    await prefs.setString('dbStatus', "created");
    var db = await openDatabase(path, version: 1, onCreate: _onJiraCreate);
    return db;
  }*/
  //Create table


  _onCreate(Database db, int version) async {
    //await db.execute('CREATE TABLE chartValues (date TEXT, url TEXT ,list Text,dateTimeMilliSec int)');
    await db.execute(
        'CREATE TABLE incomeValues (id INTEGER, month STRING, year STRING, amount STRING, title STRING)');
    await db.execute(
        'CREATE TABLE expenseValues (id INTEGER, month STRING, year STRING, date INTEGER, day STRING, amount STRING, title STRING, description STRING, week INTEGER)');
    await db.execute(
        'CREATE TABLE borrowValues (id INTEGER, month STRING, year STRING, date INTEGER, day STRING, amount STRING,lenderName STRING, description STRING, lastMonth STRING,lastYear STRING, lastDate INTEGER, sendAmount INTEGER, status INTEGER)');
    await db.execute(
        'CREATE TABLE lenderValues (id INTEGER, month STRING, year STRING, date INTEGER, day STRING, amount STRING,borrowerName STRING, description STRING, lastMonth STRING,lastYear STRING, lastDate INTEGER, sendAmount INTEGER, status INTEGER)');

  }

  Future<ExpenseModel> add(ExpenseModel data) async {
    var dbClient = await db;
    var response= await dbClient.insert('expenseValues', data.toMap());
    print("Success");
    return data;
  }
  Future<IncomeModel> addIncome(IncomeModel data) async {
    var dbClient = await db;
    var response= await dbClient.insert('incomeValues', data.toMap());
    print("Success");
    return data;
  }
  Future<BorrowModel> addBorrow(BorrowModel data) async {
    var dbClient = await db;
    var response= await dbClient.insert('borrowValues', data.toMap());
    print("Success");
    return data;
  }

  Future<LenderModel> addLender(LenderModel data) async {
    var dbClient = await db;
    var response= await dbClient.insert('lenderValues', data.toMap());
    print("Success");
    return data;
  }
  getBorrowerList(int id) async {
    var dbClient = await db;
    var response= await dbClient.query("borrowValues", where: "id = ?", whereArgs: [id]);
    if(response.isNotEmpty) {
      return response;
    } else {
      return [];
    }
  }
  getAllBorrowerList() async {

    var dbClient = await db;
    var response= await dbClient.query("borrowValues");
    if(response.isNotEmpty) {
      return response;
    } else {
      return [];
    }
  }
  Future<int> deleteBorrowItemIncome(int id) async {
    var dbClient = await db;
    return await dbClient.delete('borrowValues', where: 'id = ? ', whereArgs: [id],);
  }


  Future<int> deleteLendItemIncome(int id) async {
    var dbClient = await db;
    return await dbClient.delete('lenderValues', where: 'id = ? ', whereArgs: [id],);
  }

   updateBorrow(BorrowModel data,int id) async {
    var dbClient = await db;
    return await dbClient.update('borrowValues', data.toMap(), where: 'id = ?', whereArgs: [id],);
  }

  updateLender(LenderModel data,int id) async {
    var dbClient = await db;
    return await dbClient.update('lenderValues', data.toMap(), where: 'id = ?', whereArgs: [id],);
  }

  getAllLenderList() async {
    var dbClient = await db;
    var response= await dbClient.query("lenderValues");
    if(response.isNotEmpty) {
      return response;
    } else {
      return [];
    }
  }
  getLenderList(int id) async {
    var dbClient = await db;
    var response= await dbClient.query("lenderValues", where: "id = ?", whereArgs: [id]);
    if(response.isNotEmpty) {
      return response;
    } else {
      return [];
    }
  }
  getBorrowerStatusList(int status) async {
    var dbClient = await db;
    var response= await dbClient.query("borrowValues", where: "status = ?", whereArgs: [status]);
    if(response.isNotEmpty) {
      return response;
    } else {
      return [];
    }
  }

  getLenderStatusList(int status) async {
    var dbClient = await db;
    var response= await dbClient.query("lenderValues", where: "status = ?", whereArgs: [status]);
    if(response.isNotEmpty) {
      return response;
    } else {
      return [];
    }
  }
  getIncomeMonthList(int year, String month) async {
    var dbClient = await db;
    var response= await dbClient.query("incomeValues", where: "year = ? AND month = ?", whereArgs: [year,month]);
    if(response.isNotEmpty) {
      return response;
    } else {
      return [];
    }
  }

  Future<int> deleteMonthItemIncome(int id,String month,int year) async {
    var dbClient = await db;
    return await dbClient.delete('incomeValues', where: 'id = ? AND month = ? AND year = ?', whereArgs: [id,month,year],);
  }

  getTodaysList(int date, int year, String month) async {
    var dbClient = await db;
    var response= await dbClient.query("expenseValues", where: "date = ? AND year = ? AND month = ?", whereArgs: [date,year,month]);
    if(response.isNotEmpty) {
      return response;
    } else {
      return [];
    }
  }

  getMonthList(String month, int year) async {
    var dbClient = await db;
    var response= await dbClient.query("expenseValues", where: "month = ? AND year = ?", whereArgs: [month,year]);
    if(response.isNotEmpty) {
      return response;
    } else {
      return [];
    }
  }


  getWeekList(String month, int year,int week) async {
    var dbClient = await db;
    var response= await dbClient.query("expenseValues", where: "month = ? AND year = ? AND week = ?", whereArgs: [month,year,week]);
    if(response.isNotEmpty) {
      return response;
    } else {
      return [];
    }
  }
    Future<int> delete(int id,int date) async {
    var dbClient = await db;
    return await dbClient.delete('expenseValues', where: 'id = ? AND date = ?', whereArgs: [id,date],);
  }

  /*Future<int> update(ChartDatas data) async {
    var dbClient = await db;
    return await dbClient.update('chartValues', data.toMap(), where: 'date = ?', whereArgs: [data.date],);
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }

   getChartValuesbyDate(String date) async {
    var dbClient = await db;
    var response= await dbClient.query("chartValues", where: "date = ?", whereArgs: [date]);
    if(response.isNotEmpty)
   {
     return response[0]["list"];
   }
    else
      {
        return "empty";
      }
  }

  getChartValuesByRange(String startDate, String endDate) async {
    var dbClient = await db;
    //var response = await dbClient.query("chartValues", where: "date BETWEEN (=? AND =?)", whereArgs: [startDate,endDate]);
    var response = await dbClient.rawQuery('SELECT * FROM chartValues WHERE date BETWEEN $startDate AND $endDate');
    if (response.isNotEmpty) {
      return response[0]["list"];
    } else {
      return "empty";
    }
  }

  getValuesByDateRange(int startDate,int endDate) async {

    var dbClient = await db;
    // var response= await dbClient.query("chartValues", where: "dateTimeMilliSec = ?", whereArgs: [startDate,endDate]);
    var response=  await dbClient.rawQuery('SELECT * FROM chartValues WHERE dateTimeMilliSec BETWEEN $startDate AND $endDate');
    if (response.isNotEmpty) {
      var returnList=[];
      for(int i=0;i<response.length;i++)
        {
          //returnList.add(response[i]["list"]);
          var list=jsonDecode(response[i]["list"]);
          for(int k=0;k<list.length;k++)
            {
              returnList.add(list[k]);
            }
        }
      return returnList;
      print(returnList.length.toString());
    } else {
      return "empty";
    }
   *//* print("Date Range values"+response.toString());
    return "Date Range success";*//*
  }

  getRecordCount(String date)async{
    var dbClient = await db;
    var response = await dbClient
        .rawQuery('SELECT COUNT(*) FROM chartValues WHERE date = "$date"');
    // var response= await dbClient.rawQuery('SELECT COUNT(*) FROM chartValues WHERE list = "Test3"');
    var responses = Sqflite.firstIntValue(response);
    print("count values " + response.toString());
    print("countt values " + responses.toString());
    print(date);
    return response;
  }

  getRecordCountIds(String date,int count) async
  {
    var dbClient = await db;
    var response = await dbClient
        .rawQuery('SELECT id FROM chartValues WHERE date = "$date"');
    print("count2 values " + response.toString());
    print("ddd " + response[0]["id"].toString());
    if (count > 0) {
      // var returnList=getIndividualRecordsByDate(responses, response2);
     return response;
    }
    else
    {
      return "empty";
    }
  }

  Future<String> getIndividualRecordsByDate(int count, response2) async {
    var dbClient = await db;
    var response = List();
    var returnList=[];
    for (int i = 0; i < count; i++) {
      int id=response2[i]["id"];
      response.add(await dbClient.rawQuery(
          'SELECT * FROM chartValues WHERE id = "$id"'));
    }
    for(int i=0;i<response.length;i++)
      {
        print("valuessss "+response[i][0]["list"].toString());
        returnList.add(response[i][0]["list"]);
      }
    return "empty";
  }


  _onJiraCreate(Database db, int version) async {
    //await db.execute('CREATE TABLE chartValues (date TEXT, url TEXT ,list Text,dateTimeMilliSec int)');
    await db.execute(
        'CREATE TABLE chartJiraValues (id INTEGER PRIMARY KEY AUTOINCREMENT ,date STRING, url TEXT ,list Text,dateTimeMilliSec int)');
  }
  Future<ChartDatas> addJira(ChartDatas data) async {
    var dbClient = await db;
    var response= await dbClient.insert('chartJiraValues', data.toMap());
    print("Success");
    return data;
  }

  Future<int> deleteJira(ChartDatas data) async {
    var dbClient = await db;
    return await dbClient.delete('chartJiraValues', where: 'date = ?', whereArgs: [data.date],);
  }

  getJiraChartValuesbyDate(String date) async {
    var dbClient = await db;
    var response= await dbClient.query("chartJiraValues", where: "date = ?", whereArgs: [date]);
    if(response.isNotEmpty)
    {
      return response[0]["list"];
    }
    else
    {
      return "empty";
    }
  }

  getChartJiraValuesByRange(String startDate, String endDate) async {
    var dbClient = await db;
    //var response = await dbClient.query("chartValues", where: "date BETWEEN (=? AND =?)", whereArgs: [startDate,endDate]);
    var response = await dbClient.rawQuery('SELECT * FROM chartJiraValues WHERE date BETWEEN $startDate AND $endDate');
    if (response.isNotEmpty) {
      return response[0]["list"];
    } else {
      return "empty";
    }
  }

  getJiraValuesByDateRange(int startDate,int endDate) async {

    var dbClient = await db;
    // var response= await dbClient.query("chartValues", where: "dateTimeMilliSec = ?", whereArgs: [startDate,endDate]);
    var response=  await dbClient.rawQuery('SELECT * FROM chartJiraValues WHERE dateTimeMilliSec BETWEEN $startDate AND $endDate');
    if (response.isNotEmpty) {
      var returnList=[];
      for(int i=0;i<response.length;i++)
      {
        //returnList.add(response[i]["list"]);
        var list=jsonDecode(response[i]["list"]);
        for(int k=0;k<list.length;k++)
        {
          returnList.add(list[k]);
        }
      }
      return returnList;
      print(returnList.length.toString());
    } else {
      return "empty";
    }
    *//* print("Date Range values"+response.toString());
    return "Date Range success";*//*
  }*/

}
