import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

boldfont(String text, double size, colors) {
  return Text(text,
      style: TextStyle(
          color: colors,
          fontWeight: FontWeight.w700,
          fontFamily: "NotoSansCJKkr_Bold",
          fontStyle: FontStyle.normal,
          fontSize: size.sp),
      textAlign: TextAlign.left);
}

normalfont(String text, double size, colors) {
  return Text(text,
      style: TextStyle(
          color: colors,
          fontWeight: FontWeight.w500,
          fontFamily: "NotoSansCJKkr_Medium",
          fontStyle: FontStyle.normal,
          fontSize: size.sp),
      textAlign: TextAlign.left);
}
