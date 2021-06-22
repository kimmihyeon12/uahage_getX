import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

yearPicker(context) async {
  TextEditingController yController = TextEditingController();
  final year = DateTime.now().year;
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        title: Text(
          '생년월일을 입력하세요',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Color.fromRGBO(255, 114, 148, 1.0),
            fontSize: 56.sp,
          ),
          textAlign: TextAlign.center,
        ),
        content: Container(
            height: MediaQuery.of(context).size.height / 5.0,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: CupertinoDatePicker(
              initialDateTime: DateTime.now(),
              onDateTimeChanged: (DateTime newDate) async {
                var datee = newDate.toString().substring(0, 10).split('-');

                if (int.parse(datee[1]) < 10) {
                  datee[1] = int.parse(datee[1]).toString();
                }
                if (int.parse(datee[2]) < 10) {
                  datee[2] = int.parse(datee[1]).toString();
                }
                yController.text =
                    datee[0] + "년   " + datee[1] + "월   " + datee[2] + "일";
              },
              minimumYear: 2000,
              maximumYear: year,
              mode: CupertinoDatePickerMode.date,
            )),
        actions: <Widget>[
          FlatButton(
            child: Text(
              '확인',
              style: TextStyle(
                color: Color.fromRGBO(255, 114, 148, 1.0),
                fontFamily: 'NotoSansCJKkr_Medium',
                fontSize: 57.sp,
              ),
            ),
            onPressed: () {
              Navigator.pop(context, yController.text);
            },
          ),
        ],
      );
    },
  );
}
