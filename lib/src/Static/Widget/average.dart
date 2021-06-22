import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget average(width, text, rating) {
  return Container(
    width: width,
    decoration: BoxDecoration(
        border: Border.all(
          color: Color.fromRGBO(77, 77, 77, 0.2),
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
        color: Colors.white),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          '$text',
          style: TextStyle(
            color: Color.fromRGBO(77, 77, 77, 1.0),
            fontSize: 50.sp,
            fontFamily: "NotoSansCJKkr_Medium",
          ),
        ),
        Image.asset(
          "./assets/listPage/star_color.png",
          width: 53.w,
        ),
        Text(
          "$rating",
          style: TextStyle(
            color: Color.fromRGBO(248, 195, 61, 1.0),
            fontSize: 50.sp,
            fontFamily: "NotoSansCJKkr_Medium",
          ),
        )
      ],
    ),
  );
}
