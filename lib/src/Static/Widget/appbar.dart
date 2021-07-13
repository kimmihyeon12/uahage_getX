import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:uahage/src/Controller/place.restaurant.bookmark.controller.dart';
import 'package:uahage/src/Static/Font/font.dart';

appBar(context, text, bookmarkColor) {
  return AppBar(
    title: new Text(
      text,
      style: TextStyle(
          fontSize: 55.sp,
          fontFamily: 'NotoSansCJKkr_Medium',
          color: Color.fromRGBO(255, 114, 148, 1.0)),
    ),
    centerTitle: true,
    backgroundColor: Colors.white,
    leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: Color(0xffff7292)),
        onPressed: () {
          Get.back(result: bookmarkColor);
        }),
  );
}

imageAppbar(context, text) {
  return PreferredSize(
      preferredSize: Size.fromHeight(140.h),
      child: Container(
        child: Stack(
          children: [
            Image.asset(
              './assets/homePage/bar.png',
              fit: BoxFit.fill,
              height: 400.h,

            ),
            Container(
              margin: EdgeInsets.only(top:135.h,left:20.w),
              child: IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: () {
                    Get.back();
                  }),
            ),
text != "우아하게"?
            Container(
              width: 1125.w,
              child: Center(
                child: Container(
                  margin: EdgeInsets.only(top:120.h),
                  child: normalfont(text, 55,Colors.white)
                  ,),
              ),
            ):

            Container(
              width:1125.w,
              margin: EdgeInsets.only(top:120.h),
              child: Center(
                child: Image.asset(
                  './assets/homePage/uahage.png',
                  fit: BoxFit.fill,
                  height: 75.h,
                ),
              ),
            )
          ],
        ),
      ));
}
