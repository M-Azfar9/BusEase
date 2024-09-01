import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Utils{
  void toastMsg(String msgs, Color myColor){
    Fluttertoast.showToast(
        msg: msgs,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: myColor,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
}
