import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uahage/src/View/Auth/login.dart';
import 'package:uahage/src/View/Nav/navigator.dart';

class wrapper extends StatefulWidget {
  //email check page
  @override
  _wrapperState createState() => _wrapperState();
}

class _wrapperState extends State<wrapper> {
  String userId = "";

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('uahageUserId') ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    /*  if (userId == "") {
      return login();
    } else {
      return navigation();
    } */

    return navigation();
  }
}
