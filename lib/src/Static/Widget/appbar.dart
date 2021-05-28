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
          fontSize: 62.sp,
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
      preferredSize: Size.fromHeight(165.h),
      child: Container(
        child: Stack(
          children: [
            Image.asset('./assets/homePage/bar.png', fit: BoxFit.fill),
            Center(
              child: boldfont(text, 73.0, Colors.white),
            )
          ],
        ),
      ));
}
