import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uahage_getx/src/Static/Font/font.dart';

// back => back button 여부
// text => appbar에 들어갈 text
// backgroudcolor => appbar 전체 컬러
// fontcolor => appbar font 컬러
appBar(context, back, text, backgroundcolor, fontcolor, result) {
  if (back = true)
    return PreferredSize(
      preferredSize: Size.fromHeight(180.h),
      child: AppBar(
        backgroundColor: backgroundcolor,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: fontcolor),
          onPressed: () {
            Navigator.pop(context, result);
          },
        ),
        title: normalfont(text, 67.0, fontcolor),
      ),
    );
  else
    return PreferredSize(
      preferredSize: Size.fromHeight(180.h),
      child: AppBar(
        backgroundColor: backgroundcolor,
        centerTitle: true,
        title: normalfont(text, 67.0, fontcolor),
      ),
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
