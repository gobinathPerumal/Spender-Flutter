import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spender/color/appcolors.dart';
import 'package:spender/dimens/appDimens.dart';

class HomeListView extends StatelessWidget {
  List<dynamic> todayslist = [];
  final Function deletedialog;
  final Function showListDetails;
  HomeListView(this.deletedialog,this.todayslist,this.showListDetails);

  @override
  Widget build(BuildContext context) {
    return Column(
        children: todayslist
            .map(
              (item) => Container(
                padding: EdgeInsets.all(10),
                child: GestureDetector(
                  child: Card(
                      elevation: 5,
                      color: ColorsFile().appBackgroundColor,
                      child: Container(
                        height: 80,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                              width: 70.0,
                              child: Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  border:
                                  Border.all(width: 2, color: Colors.purple.withOpacity(0.8)),
                                  shape: BoxShape.circle,
                                  color: Colors.purple.withOpacity(0.9),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                            item["description"]==""?
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
                            ):Container(
                              padding: EdgeInsets.only(top: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width:
                                    MediaQuery.of(context).size.width / 2.4,
                                    padding: EdgeInsets.only(left: 5),
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      item["title"],
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),

                                  Container(
                                    padding: EdgeInsets.only(top: 5, left: 5),
                                    width:
                                    MediaQuery.of(context).size.width / 2.2,
                                    child: Text(
                                      item["description"],
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 12, fontFamily: "Poppins"),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(right: 15),
                              child: IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    deletedialog("", "Are you sure want to delete this Expense?", true,
                                        Colors.transparent, item);
                                  }),
                            )
                          ],
                        ),
                      )),
                  onTap: (){
                      showListDetails(item);
                  },
                ),
              ),
            )
            .toList());
  }

}
