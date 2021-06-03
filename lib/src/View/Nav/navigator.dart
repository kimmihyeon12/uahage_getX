import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uahage/src/Controller/connection.controller.dart';
import 'package:uahage/src/Service/connection.dart';
import 'package:uahage/src/Static/Widget/progress.dart';
import 'package:uahage/src/View/Nav/search.dart';
import 'package:uahage/src/View/Nav/star.dart';
import 'package:uahage/src/View/Nav/Home.dart';
import 'myPage.dart';

class Navigation extends StatefulWidget {
  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    connection();
    ScreenUtil.init(context, width: 1500, height: 2667);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return WillPopScope(
      onWillPop: () {
        if (_selectedTabIndex >= 1) {
          setState(() {
            _selectedTabIndex = 0;
          });
        } else
          SystemNavigator.pop();
        // Navigator.pop(context, true);
      },
      child: SafeArea(
          child: Scaffold(
              body: Stack(
                children: [
                  ConnectionController.to.connectionstauts !=
                          "ConnectivityResult.none"
                      ? IndexedStack(
                          index: _selectedTabIndex,
                          children: <Widget>[
                            Home(),
                            Search(),
                            Star(),
                            MyPage(),
                          ],
                        )
                      : progress()
                ],
              ),
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: _selectedTabIndex,
                showSelectedLabels: false, // <-- HERE
                showUnselectedLabels: false,
                elevation: 15,
                backgroundColor: Colors.white,
                onTap: (value) {
                  setState(() {
                    _selectedTabIndex = value;
                  });
                },
                type: BottomNavigationBarType.fixed,
                items: [
                  BottomNavigationBarItem(
                    icon: Image.asset(
                      "assets/NavigationbarPage/home_grey.png",
                      width: 79.w,
                      height: 144.h,
                    ),
                    label: "home",
                    activeIcon: Image.asset(
                      "assets/NavigationbarPage/home_pink.png",
                      width: 79.w,
                      height: 144.h,
                    ),
                    // title: Text("home"),
                  ),
                  BottomNavigationBarItem(
                    label: "",
                    icon: Image.asset(
                      "assets/NavigationbarPage/search_grey.png",
                      width: 79.w,
                      height: 139.h,
                    ),
                    activeIcon: Image.asset(
                      "assets/NavigationbarPage/search_pink.png",
                      width: 79.w,
                      height: 139.h,
                    ),
                    // title: Text("search"),
                  ),
                  BottomNavigationBarItem(
                    label: "",
                    icon: Image.asset(
                      "assets/NavigationbarPage/star_grey.png",
                      width: 162.w,
                      height: 147.h,
                    ),
                    activeIcon: Image.asset(
                      "assets/NavigationbarPage/star_pink.png",
                      width: 162.w,
                      height: 147.h,
                    ),
                    // title: Text("star"),
                  ),
                  BottomNavigationBarItem(
                    label: "",

                    icon: Image.asset(
                      "assets/NavigationbarPage/mypage_grey.png",
                      width: 132.w,
                    ),
                    activeIcon: Image.asset(
                      "assets/NavigationbarPage/mypage_pink.png",
                      width: 132.w,
                      height: 141.h,
                    ),
                    // title: Text("mypage"),
                  ),
                ],
              ))),
    );
  }
}
