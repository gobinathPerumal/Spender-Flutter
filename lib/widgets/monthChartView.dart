import 'package:flutter/cupertino.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:share/share.dart';

class MonthChartView extends StatelessWidget {
  String totalAmount;
  List<int> amountList=[];
  DateTime selectedMonth;
  List<List<charts.Series>> chartData = List<List<charts.Series>>();
  List<dynamic> colorLists = [
    Color(0xFF16D8D8),
    Color(0xFFD84774),
    Color(0xFFFECA7A),
    Color(0xFFA77AB4)
  ];
  List<String> contentList = ["Week 01", "Week 02", "Week 03", "Week 04"];

  MonthChartView(this.chartData, this.totalAmount,this.amountList, this.selectedMonth);

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
                    "This Month total Expenses : Rs. " + totalAmount,
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
                                      "Rs. "+amountList[2].toString(),
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
    text=text+"Month : "+selectedMonth.month.toString()+" / "+selectedMonth.year.toString()+"\n\n";
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
}
