import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uahage/src/Controller/navigator.controller.dart';
import 'package:get/get.dart';
import 'package:uahage/src/View/Nav/home.dart';
import 'package:uahage/src/View/Nav/search.dart';
import 'package:uahage/src/View/Nav/star.dart';
import 'package:uahage/src/View/Nav/mypage.dart';

class navigation extends GetView<navigatorController> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 1500, height: 2667);
    return Scaffold(
      body: Obx(() {
        if (controller.currentIndex.value == 0) {
          return home();
        } else if (controller.currentIndex.value == 1) {
          return search();
        } else if (controller.currentIndex.value == 2) {
          return star();
        } else if (controller.currentIndex.value == 3) {
          return mypage();
        }
      }),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: controller.currentIndex.value,
          onTap: controller.changePageIndex,
          items: [
            BottomNavigationBarItem(
              icon: Image.asset(
                "assets/NavigationbarPage/home_grey.png",
                width: 79.w,
                height: 144.h,
              ),
              label: "",
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
        ),
      ),
    );
  }
}
