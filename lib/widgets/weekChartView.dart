import 'package:flutter/cupertino.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:share/share.dart';

class WeekChartView extends StatelessWidget {
  String totalAmount;
  List<int> amountList=[];
  List<List<charts.Series>> chartData = List<List<charts.Series>>();
  List<dynamic> colorLists = [
    Color(0xFFF7A500),
    Color(0xFFD95B52),
    Color(0xFF6CB1EC),
    Color(0xFFA77AB4),
    Color(0xFF3AC4BF),
    Color(0xFF675A74),
    Color(0xFF4A577D),
  ];
  String weekSelction;
  DateTime selectedWeekMonth;
  List<String> contentList = ["Monday", "Tuesday", "Wednesday","Thursday","Friday","Saturday","Sunday"];

  WeekChartView(this.chartData, this.totalAmount,this.amountList, this.weekSelction, this.selectedWeekMonth);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 15, bottom: 10),
            child: Card(
                color: Colors.white,
                elevation: 10,
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    "This Week total Expenses : Rs. " + totalAmount,
                    style: TextStyle(
                        color: Colors.green,
                        fontSize: 14,
                        fontFamily: "Poppins"),
                  ),
                )),
          ),
          Expanded(
            child: SingleChildScrollView(
              child:Container(
                padding: EdgeInsets.only(top: 15, bottom: 10),
                child: Card(
                  color: Colors.white,
                  elevation: 10,
                  child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              icon: Icon(
                                Icons.share,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                shareContent(context);
                              },
                            ),
                          ),
                          pieChart(),
                          Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Container(
                                    height: 20.0,
                                    width: 20.0,
                                    color: Colors.transparent,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: colorLists[0],
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(2.0))),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 8),
                                    child: Text(
                                      contentList[0] + "  :",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: "Poppins"),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(2),
                                    child: Text(
                                      "Rs. "+amountList[0].toString(),
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: Colors.purple,
                                          fontSize: 14,
                                          fontFamily: "Poppins"),
                                    ),
                                  )
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
                                          color: colorLists[1],
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(2.0))),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 8),
                                    child: Text(
                                      contentList[1] + "  :",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: "Poppins"),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(2),
                                    child: Text(
                                      "Rs. "+ amountList[1].toString(),
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: Colors.purple,
                                          fontSize: 14,
                                          fontFamily: "Poppins"),
                                    ),
                                  )
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
                                          color: colorLists[2],
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(2.0))),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 8),
                                    child: Text(
                                      contentList[2] + "  :",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: "Poppins"),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(2),
                                    child: Text(
                                      "Rs. "+ amountList[2].toString(),
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: Colors.purple,
                                          fontSize: 14,
                                          fontFamily: "Poppins"),
                                    ),
                                  )
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
                                          color: colorLists[3],
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(2.0))),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 8),
                                    child: Text(
                                      contentList[3] + "  :",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: "Poppins"),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(2),
                                    child: Text(
                                      "Rs. "+amountList[3].toString(),
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: Colors.purple,
                                          fontSize: 14,
                                          fontFamily: "Poppins"),
                                    ),
                                  )
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
                                          color: colorLists[4],
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(2.0))),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 8),
                                    child: Text(
                                      contentList[4] + "  :",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: "Poppins"),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(2),
                                    child: Text(
                                      "Rs. "+ amountList[4].toString(),
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: Colors.purple,
                                          fontSize: 14,
                                          fontFamily: "Poppins"),
                                    ),
                                  )
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
                                          color: colorLists[5],
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(2.0))),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 8),
                                    child: Text(
                                      contentList[5] + "  :",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: "Poppins"),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(2),
                                    child: Text(
                                      "Rs. "+amountList[5].toString(),
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: Colors.purple,
                                          fontSize: 14,
                                          fontFamily: "Poppins"),
                                    ),
                                  )
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
                                          color: colorLists[6],
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(2.0))),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 8),
                                    child: Text(
                                      contentList[6] + "  :",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: "Poppins"),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(2),
                                    child: Text(
                                      "Rs. "+amountList[6].toString(),
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: Colors.purple,
                                          fontSize: 14,
                                          fontFamily: "Poppins"),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ],
                      )),),
              ) ,
            ),
          ),
        ],
      ),
    );
  }

  Widget pieChart() {
    return Container(
        child: Column(
      children: <Widget>[
        Container(
          height: 250,
          width: double.infinity,
          child: new charts.PieChart(chartData[0],
              animate: true,
              defaultRenderer: new charts.ArcRendererConfig(
                  arcWidth: 60,
                  arcRendererDecorators: [new charts.ArcLabelDecorator()])),
        ),
      ],
    ));
  }
  shareContent(context) {
    var text="Expense Details"+"\n\n";
    text=text+"Month : "+selectedWeekMonth.month.toString()+" / "+selectedWeekMonth.year.toString()+"\n";
    text=text+"("+ weekSelction +")"+"\n\n";
    for(int i=0;i<amountList.length;i++)
    {
      text=text+contentList[i]+" : "+amountList[i].toString()+"\n";
    }
    text=text+"Total Amount : "+totalAmount+"\n\n"+"This information has shared from Spender Note App";
    final RenderBox box = context.findRenderObject();
    Share.share(
        text,
        subject: "Expense Detail",
        sharePositionOrigin:
        box.localToGlobal(Offset.zero) & box.size);

  }

  Widget horizontalBarChart() {
    return Visibility(
        child: Column(
          children: <Widget>[
            Container(
              height: 250,
              width: double.infinity,
              child: charts.BarChart(
                chartData[0],
                animate: true,
                vertical: false,
              ),
            ),
          ],
        ));
  }

}
