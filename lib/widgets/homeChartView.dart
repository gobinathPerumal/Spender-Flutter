import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spender/color/appcolors.dart';
import 'package:spender/dimens/appDimens.dart';
import 'package:spender/model/homeChartModel.dart';

class HomeChartView extends StatelessWidget{
  List<HomeChartModel>chartModel=[];
  HomeChartView(this.chartModel);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child:Container(
        child: Column(
          children: <Widget>[
            Container(
              height: 200,
              width: MediaQuery.of(context).size.width,
              child: Card(
                color: ColorsFile().appBackgroundColor,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(DimensFile().borderRadius),
                ),
                child:Container(
                  child:chartView(),
                ),
              ),
            )
          ],
        ),
      )
    );
  }

  Widget chartView()
  {
    return  new Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: chartModel.map((item) => Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            item.isToday? Container(
              alignment: Alignment.topLeft,
              child: Icon(Icons.star,color: ColorsFile().fabColor),
            ):Container(),
            Row(

              children: <Widget>[
                Container(
                  width: 30,
                  alignment: Alignment.topCenter,
                  child: Text(item.amount, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 10,fontFamily: "Poppins"),),
                ),
              ],
            ),
            Align(
              alignment: Alignment.topLeft,
              child:
              Container(
                child: Card(
                  color: item.isActive?ColorsFile().primaryColor.withOpacity(0.5):!item.isToday?ColorsFile().appBackgroundColor:Colors.purple.withOpacity(0.8),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(DimensFile().borderRadius),
                  )
                ),
                width: 20,height: item.isToday?90:110,
              ) ,
            ),
            Container(
              padding: EdgeInsets.only(top: 10),
              alignment: Alignment.topCenter,
              child: Text(item.day, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 14,fontFamily: "Poppins",color: item.isToday?ColorsFile().positiveColor:Colors.black),),
            ),
          ],
        ),).toList());
  }
}