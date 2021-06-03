import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spender/color/appcolors.dart';
import 'package:spender/dimens/appDimens.dart';

import '../main.dart';


class CustomDialog extends StatelessWidget {
  final String title, description,cancelbuttonText,okbuttonText;
  final BuildContext fromContext;
  final Image image;
  final bool isAllbutton;

  CustomDialog({
    @required this.title,
    @required this.description,
    @required this.cancelbuttonText,
    @required this.okbuttonText,
    @required this.fromContext,
    this.isAllbutton,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DimensFile.padding),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }
  dialogContent(BuildContext context) {
    return Stack(
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
          child: Column(
            mainAxisSize: MainAxisSize.min, // To make the card compact
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  color: ColorsFile.orangeShade1,
                  fontSize: DimensFile.text_medium,
                  fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: ColorsFile.greyColor,
                  fontSize: DimensFile.text_xx_small,
                ),
              ),
              SizedBox(height: 24.0),
             Visibility(
               visible: isAllbutton,
               child:  Row(
                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                 children: <Widget>[
                   Align(
                     alignment: Alignment.bottomRight,
                     child: FlatButton(
                       onPressed: () {
                         Navigator.of(context).pop(); // To close the dialog
                       },
                       child: Text(cancelbuttonText,
                         style: TextStyle(
                           color: ColorsFile.headerColor,
                           fontSize:DimensFile.text_medium,
                         ),),
                     ),
                   ),
                   Align(
                     alignment: Alignment.bottomRight,
                     child: FlatButton(
                       onPressed: () {
                        // mainPage(context);
                         Navigator.of(context).pop(); // To close the dialog
                       },
                       child: Text(okbuttonText,
                         style: TextStyle(
                           fontFamily: "Poppins",
                           color: ColorsFile.headerColor,
                           fontSize:DimensFile.text_medium,
                         ),),
                     ),
                   ),
                 ],
               ),
             ),
              Visibility(
                visible: !isAllbutton,
                child:Align(
                  alignment: Alignment.center,
                  child: FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // To close the dialog
                    },
                    child: Text("Ok",
                      style: TextStyle(
                        color: ColorsFile.headerColor,
                        fontSize:DimensFile.text_medium,
                      ),),
                  ),
                ),
              )

            ],
          ),
        ),
        Positioned(
          left: DimensFile.padding,
          right: DimensFile.padding,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: DimensFile.avatarRadius,
            child: Container(
              color:Colors.transparent,
              margin: EdgeInsets.only(top: DimensFile.margin_x_small),
              width: DimensFile.alert_icon_size,
              height: DimensFile.alert_icon_size,
            ),
          ),
        ),
      ],
    );
  }


}