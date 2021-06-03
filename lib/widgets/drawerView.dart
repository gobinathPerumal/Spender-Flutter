import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spender/color/appcolors.dart';

class DrawerView extends StatelessWidget {
  String userName,fullName,email;

  DrawerView(this.userName, this.fullName, this.email);
  @override
  Widget build(BuildContext context) {
    return /*Drawer(
        child: Container(
          height: MediaQuery.of(context).size.height,
      child: ListView(
        children: <Widget>[
          Container(
            padding:
            EdgeInsets.only(top: 30),
            child: Column(
              children: <Widget>[
                Container(
                  width: 140,
                  height: 140,
                  child: CircleAvatar(
                      child:Icon(Icons.sentiment_very_satisfied,color: Colors.white,size: 110,)
                  ),
                )
              ],
            ),
          ),
          Container(
            padding:
                EdgeInsets.only(top:50,left: 15),
            child: ListTile(
                leading: Icon(
                  Icons.person_add,
                  color: Colors.purple,
                ),
                title:Text(
                  "Full Name",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    color: Colors.purple,
                  ),
                ) ,
                subtitle: Text(
                  fullName,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: Colors.purple,
                  ),
                ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 15),
            child: ListTile(
                leading: Icon(
                  Icons.person,
                  color: Colors.purple,
                ),
                title: Text(
                  "UserName",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    color: Colors.purple,
                  ),
                ),
            subtitle: Text(
              userName,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                color: Colors.purple,
              ),
            ),),
          ),
          Container(
            padding: EdgeInsets.only(left: 15),
            child: ListTile(
                leading: Icon(
                  Icons.mail,
                  color: Colors.purple,
                ),
                title: Text(
                  "Email Address",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    color: Colors.purple,
                  ),
                ),
            subtitle: Text(
              email,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                color: Colors.purple,
              ),
            ),),
          ),
        ],
      ),
    ))*/Drawer(
      // column holds all the widgets in the drawer
      child: Column(
        children: <Widget>[
          Expanded(
            // ListView contains a group of widgets that scroll inside the drawer
            child:  ListView(
              children: <Widget>[
                Container(
                  padding:
                  EdgeInsets.only(top: 30),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: 140,
                        height: 140,
                        child: CircleAvatar(
                            child:Icon(Icons.sentiment_very_satisfied,color: Colors.white,size: 110,)
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  padding:
                  EdgeInsets.only(top:50,left: 15),
                  child: ListTile(
                    leading: Icon(
                      Icons.person_add,
                      color: Colors.purple,
                    ),
                    title:Text(
                      "Full Name",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        color: Colors.purple,
                      ),
                    ) ,
                    subtitle: Text(
                      fullName,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        color: Colors.purple,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 15),
                  child: ListTile(
                    leading: Icon(
                      Icons.person,
                      color: Colors.purple,
                    ),
                    title: Text(
                      "UserName",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        color: Colors.purple,
                      ),
                    ),
                    subtitle: Text(
                      userName,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        color: Colors.purple,
                      ),
                    ),),
                ),
                Container(
                  padding: EdgeInsets.only(left: 15),
                  child: ListTile(
                    leading: Icon(
                      Icons.mail,
                      color: Colors.purple,
                    ),
                    title: Text(
                      "Email Address",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        color: Colors.purple,
                      ),
                    ),
                    subtitle: Text(
                      email,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        color: Colors.purple,
                      ),
                    ),),
                ),
              ],
            ),
          ),
          // This container holds the align
          Container(// This align moves the children to the bottom
              padding: EdgeInsets.only(bottom: 25),
              child: Align(
                alignment: Alignment.center,
                  child: Center(
                    child: Container(
                      height: 25,
                      width: MediaQuery.of(context).size.width*0.5,
                        decoration: BoxDecoration(
                        image: DecorationImage(
                          image:   AssetImage("images/ribbon.png"),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
              )
          )
        ],
      ),
    );
  }
}
