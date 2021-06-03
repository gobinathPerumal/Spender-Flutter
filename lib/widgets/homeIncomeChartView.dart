import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spender/color/appcolors.dart';
import 'package:spender/dimens/appDimens.dart';
import 'package:spender/model/homeChartModel.dart';

class HomeIncomeChartView extends StatelessWidget{
  int incomeWidth=130,expenseWidth=0,savingWidth=0;
  int expense=0,income=0,savings=0;
  bool isGreater=false;
  HomeIncomeChartView(this.expense,this.income,this.savings);
  @override
  Widget build(BuildContext context) {
    calculateWidth();
    return Container(
      padding: EdgeInsets.only(left: 10,right: 10,top: 10),
      child:Container(
        child: Column(
          children: <Widget>[
            Container(
              height: 300,
              width: MediaQuery.of(context).size.width,
              child: Card(
                color: ColorsFile().appBackgroundColor,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(DimensFile().borderRadius),
                ),
                child:income==0 && expense==0 && savings==0?Center(
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
                  ),
                ):Container(
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
                                        color: Colors.redAccent.withOpacity(0.7),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(2.0))),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 8),
                                  child: Text(
                                    "Expense",
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
                                        color: Colors.amber.withOpacity(0.7),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(2.0))),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 8),
                                  child: Text(
                                    "Income",
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
                                        color: Colors.green.withOpacity(0.7),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(2.0))),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 8),
                                  child: Text(
                                    "Savings",
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
                                        color: Colors.redAccent.withOpacity(0.7),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(2.0))),
                                  ),
                                ),

                                Padding(
                                  padding: EdgeInsets.only(left: 8),
                                  child: Text(
                                    "Rs."+expense.toString(),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 10,
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
                                        color: Colors.amber.withOpacity(0.7),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(2.0))),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 8),
                                  child: Text(
                                    "Rs."+income.toString(),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 10,
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
                                        color: Colors.green.withOpacity(0.7),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(2.0))),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 8),
                                  child: Text(
                                    income>expense?"Rs."+(income-expense).toString():"Rs.0",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontFamily: "Poppins"),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(height: 170,
                        padding: EdgeInsets.only(top:20,left: 40,right: 40),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                              height:isGreater?170:expenseWidth.toDouble(),
                              child: Container(
                                width:50,
                                padding: EdgeInsets.only(top: 15),
                                color: Colors.redAccent.withOpacity(0.7),
                              ),
                            ),
                            Container(
                              height: income==0?0:incomeWidth.toDouble(),
                              child: Container(
                                width:50,
                                padding: EdgeInsets.only(top: 15),
                                color: Colors.amber.withOpacity(0.7),
                              ),
                            ),
                            Container(
                              height: savingWidth.toDouble(),
                              child: Container(
                                width:50,
                                padding: EdgeInsets.only(top: 15),
                                color: Colors.green.withOpacity(0.7),
                              ),
                            )
                          ],
                        ),

                      ),
                      Container(
                        margin: EdgeInsets.only(left: 35,right: 35),
                        color: Colors.black,
                        height: 1,
                        child: Divider(height: 1,),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      )
    );
  }
  calculateWidth()
  {
    isGreater=false;
    expenseWidth=0;
    savingWidth=0;
    if(income>expense)
      {
        if(expense>0 && income>0)
        {
          var value=((expense*130)/income);
          if(value<1 && value!=0)
            {
              expenseWidth=1;
            }
          else
            expenseWidth=value.toInt();
        }
      }
    else{
      print("kk");
      if(expense!=0)
        {
          isGreater=true;
        }
    }
    if(savings>0 && income>0)
    {
      savingWidth=((savings*130)/income).toInt();
    }
  }

}