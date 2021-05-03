import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter_config/flutter_config.dart';
import 'package:uahage/src/Controller/login.controller.dart';
import 'package:uahage/src/Static/url.dart';

class UserModify extends GetView<loginCotroller> {
  String url = URL;

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(
                        Icons.photo_library,
                        color: Color.fromRGBO(255, 114, 148, 1.0),
                      ),
                      title: new Text('겔러리'),
                      onTap: () async {
                        await _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(
                      Icons.photo_camera,
                      color: Color.fromRGBO(255, 114, 148, 1.0),
                    ),
                    title: new Text('카메라'),
                    onTap: () async {
                      await _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                  new ListTile(
                    leading: new Icon(
                      Icons.delete_rounded,
                      color: Color.fromRGBO(255, 114, 148, 1.0),
                    ),
                    title: new Text('삭제'),
                    onTap: () async {
                      await deleteFile();
                      controller.setimage('');
                      controller.setfileimage('');

                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future deleteFile() async {
    try {
      await http.post(
        url + "/api/s3/images-delete",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Authorization": controller.tokens.value
        },
        body: jsonEncode({"fileName": controller.imageLink.value}),
      );
    } catch (err) {}
  }

  Future _imgFromCamera() async {
    var image = await ImagePicker()
        .getImage(source: ImageSource.camera, imageQuality: 20);

    controller.setfileimage(File(image.path).toString());
  }

  Future _imgFromGallery() async {
    var image = await ImagePicker()
        .getImage(source: ImageSource.gallery, imageQuality: 20);
    controller.setfileimage(File(image.path).toString());
  }

  uploadFile(File file) async {
    if (controller.imageLink.value != "") {
      try {
        await http.post(
          url + "/api/s3/images-delete",
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            "Authorization": controller.tokens.value
          },
          body: jsonEncode({"fileName": controller.imageLink.value}),
        );
      } catch (err) {
        print(err);
      }
    }

    try {
      String fileName = file.path.split('/').last;
      FormData formData = FormData.fromMap({
        "profileImage":
            await MultipartFile.fromFile(file.path, filename: fileName),
      });
      Dio dio = new Dio();
      var response;
      try {
        response = await dio.post(
            url + '/api/s3/images/${controller.userId.value}',
            data: formData);
        controller.setimage(response.data["location"]);

        print("Printing after upload imagelink " + controller.imageLink.value);
        await _saveURL(controller.imageLink.value);
      } catch (err) {
        print(err);
      }
    } catch (err) {
      print(err);
    }
  }

  _saveURL(_uploadedFileURL) async {
    try {
      await http.patch(
        url + "/api/users/${controller.userId.value}",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Authorization": controller.tokens.value
        },
        body: jsonEncode({"profile_url": _uploadedFileURL}),
      );
    } catch (error) {}
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, false);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    margin: EdgeInsets.fromLTRB(60.w, 50.h, 0, 0),
                    child: InkWell(
                      onTap: () async {
                        Navigator.pop(context, false);
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            "./assets/myPage/back.png",
                            width: 43.w,
                            height: 76.h,
                          ),
                          // 내 정보
                          Container(
                            margin: EdgeInsets.only(left: 33.w),
                            child: Text("내 정보",
                                style: TextStyle(
                                  color: Color.fromRGBO(255, 114, 148, 1.0),
                                  fontFamily: 'NotoSansCJKkr_Medium',
                                  fontSize: 62.sp,
                                ),
                                textAlign: TextAlign.left),
                          ),

                          //
                        ],
                      ),
                    )),
                Center(
                  child: Stack(
                    children: [
                      SizedBox(
                        height: 439.h,
                        width: 439.w,
                        child: (() {
                          print("here " + controller.imageLink.value);
                          // your code here
                          if (controller.imageLink.value != '') {
                            return Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: NetworkImage(
                                        controller.imageLink.value),
                                    fit: BoxFit.cover),
                              ),
                            );
                          } else if (controller.fileimage.value == '') {
                            return Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: FileImage(
                                        controller.fileimage.value), //imageURL
                                    fit: BoxFit.cover),
                              ),
                            );
                          } else {
                            return Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image:
                                      AssetImage("./assets/myPage/avatar.png"),
                                ),
                              ),
                            );
                          }
                        }()),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          // margin: EdgeInsets.fromLTRB(
                          //     330 .w, 341 .h, 0, 0),
                          child: InkWell(
                            onTap: () {
                              _showPicker(context);
                            },
                            child: Image.asset(
                              "./assets/myPage/camera.png",
                              height: 109.h,
                              width: 110.w,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(
                    top: 85.h,
                  ),
                  child: Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 닉네임
                        Container(
                          margin: EdgeInsets.fromLTRB(157.w, 40.h, 88.w, 0),
                          child: Text("닉네임",
                              style: TextStyle(
                                  color: const Color(0xffff7292),
                                  fontFamily: "NotoSansCJKkr_Medium",
                                  fontSize: 57.sp),
                              textAlign: TextAlign.left),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            margin: EdgeInsets.only(
                              right: 121.w,
                            ),
                            child: Stack(
                              children: [
                                TextFormField(
                                  cursorColor: Color(0xffff7292),
                                  maxLength: 10,
                                  onChanged: (txt) {
                                    controller.setnickname(txt);
                                  },
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Color(0xff3a3939),
                                      fontFamily: "NotoSansCJKkr_Bold",
                                      fontSize: 58.sp),
                                  decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.only(right: 410.w),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: const Color(0xffff7292),
                                      ),

                                      //Color.fromRGBO(255, 114, 148, 1.0)
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xffff7292)),
                                    ),
                                    hintText: '닉네임을 입력하세요',
                                    hintStyle: TextStyle(
                                        color: const Color(0xffcacaca),
                                        fontFamily: "NotoSansCJKkr_Medium",
                                        fontSize: 57.sp),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: FlatButton(
                                    height: 125.h,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0)),
                                    color: nickName == ""
                                        ? Color(0xffcacaca)
                                        : Color(0xffff7292),
                                    onPressed:
                                        loginOption != "login" && nickName != ""
                                            ? () {
                                                print(nickName);
                                                currentFocus.unfocus();
                                                buildShowDialogOnOk(
                                                    checkNickName(),
                                                    context,
                                                    300.h,
                                                    200.h,
                                                    80.h,
                                                    1500.h,
                                                    52.h);
                                              }
                                            : () {},
                                    child: // 중복확인
                                        Text("중복확인",
                                            style: TextStyle(
                                                color: const Color(0xffffffff),
                                                fontFamily:
                                                    "NotoSansCJKkr_Medium",
                                                fontSize: 58.sp),
                                            textAlign: TextAlign.left),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                //Gender
                Container(
                  margin: EdgeInsets.fromLTRB(99.w, 35.h, 0, 0),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 아이성별
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 24.h, 56.w, 0),
                        child: Text("아이성별",
                            style: TextStyle(
                                color: const Color(0xffff7292),
                                fontFamily: "NotoSansCJKkr_Medium",
                                fontSize: 57.sp),
                            textAlign: TextAlign.left),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            gender = "M";
                            genderImage[0] = !genderImage[0];
                            genderImage[1] = false;
                          });
                        },
                        child: Image.asset(
                          genderImage[0]
                              ? "./assets/myPage/boy_pink.png"
                              : "./assets/myPage/boy_grey.png",
                          height: 363.h,
                          width: 262.w,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 98.w),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              gender = "F";
                              genderImage[1] = !genderImage[1];
                              genderImage[0] = false;
                            });
                          },
                          child: Image.asset(
                            genderImage[1]
                                ? "./assets/myPage/girl_pink.png"
                                : "./assets/myPage/girl_grey.png",
                            height: 363.h,
                            width: 262.w,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Birthday

                Container(
                  margin: EdgeInsets.fromLTRB(99.w, 5.h, 0, 0),
                  child: Row(
                    children: [
                      // 아이생일
                      Text("아이생일",
                          style: TextStyle(
                            fontSize: 57.sp,
                            color: const Color(0xffff7292),
                            fontFamily: "NotoSansCJKkr_Medium",
                          ),
                          textAlign: TextAlign.left),
                      Expanded(
                        flex: 1,
                        child: Container(
                          margin: EdgeInsets.fromLTRB(82.w, 0, 121.w, 0),
                          child: Stack(
                            children: [
                              GestureDetector(
                                onTap: yearPicker,
                                child: AbsorbPointer(
                                  child: TextFormField(
                                    readOnly: true,
                                    controller: yController,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Color(0xffff7292),
                                        fontSize: 57.sp,
                                        fontFamily: 'NotoSansCJKkr_Medium',
                                        fontStyle: FontStyle.normal,
                                        letterSpacing: -1.0),
                                    decoration: InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: const Color(0xffff7292),
                                        ),
                                        //Color.fromRGBO(255, 114, 148, 1.0)
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xffff7292)),
                                      ),
                                      hintText: birthday == ""
                                          ? '생년월일을 선택해주세요'
                                          : birthday,
                                      hintStyle: TextStyle(
                                          color: Color(0xffd4d4d4),
                                          fontFamily: "NotoSansCJKkr_Medium",
                                          fontSize: 57.0.sp),
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: IconButton(
                                  onPressed: () {
                                    yearPicker();
                                  },
                                  icon: Image.asset(
                                      "./assets/myPage/calendar.png"),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                //Ages
                Container(
                  margin: EdgeInsets.fromLTRB(155.w, 91.h, 0, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 보호자 연령대
                      Text("보호자\n연령대",
                          style: TextStyle(
                            color: const Color(0xffff7292),
                            fontWeight: FontWeight.w500,
                            fontFamily: "NotoSansCJKkr_Medium",
                            fontSize: 57.sp,
                          ),
                          textAlign: TextAlign.right),
                      Container(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 59.w),
                                  child: InkWell(
                                    child: Image.asset(
                                      changeimage[0]
                                          ? './assets/registrationPage/10_pink.png'
                                          : './assets/registrationPage/10_grey.png',
                                      height: 194.h,
                                      width: 249.w,
                                    ),
                                    onTap: () {
                                      _change('10');
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 55.w),
                                  child: InkWell(
                                    child: Image.asset(
                                      changeimage[1]
                                          ? './assets/registrationPage/20_pink.png'
                                          : './assets/registrationPage/20_grey.png',
                                      height: 194.h,
                                      width: 249.w,
                                    ),
                                    onTap: () {
                                      _change('20');
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 55.w),
                                  child: InkWell(
                                    child: Image.asset(
                                      changeimage[2]
                                          ? './assets/registrationPage/30_pink.png'
                                          : './assets/registrationPage/30_grey.png',
                                      height: 194.h,
                                      width: 249.w,
                                    ),
                                    onTap: () {
                                      _change('30');
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: 59.w, top: 45.h),
                                  child: InkWell(
                                    child: Image.asset(
                                      changeimage[3]
                                          ? './assets/registrationPage/40_pink.png'
                                          : './assets/registrationPage/40_grey.png',
                                      height: 194.h,
                                      width: 249.w,
                                    ),
                                    onTap: () {
                                      _change('40');
                                    },
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: 55.w, top: 45.h),
                                  child: InkWell(
                                    child: Image.asset(
                                      changeimage[4]
                                          ? './assets/registrationPage/50_pink.png'
                                          : './assets/registrationPage/50_grey.png',
                                      height: 194.h,
                                      width: 249.w,
                                    ),
                                    onTap: () {
                                      _change('50');
                                    },
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: 55.w, top: 45.h),
                                  child: InkWell(
                                    child: Image.asset(
                                      changeimage[5]
                                          ? './assets/registrationPage/others_pink.png'
                                          : './assets/registrationPage/others_grey.png',
                                      height: 194.h,
                                      width: 249.w,
                                    ),
                                    onTap: () {
                                      _change('60');
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                //OK
                Center(
                  child: Container(
                    margin: EdgeInsets.only(
                      top: 87.h,
                    ),
                    child: SizedBox(
                      height: 194.w,
                      width: 1193.h,
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                        color: isIdValid &&
                                nickName != "" &&
                                yController.text != "" &&
                                gender != "" &&
                                userAge != ""
                            ? Color(0xffff7292)
                            : Color(0xffcacaca),
                        onPressed: isIdValid &&
                                nickName != "" &&
                                yController.text != "" &&
                                gender != "" &&
                                userAge != ""
                            ? () async {
                                await uploadFile(_image);
                                if (imageLink == "") {
                                  print("imageLink");
                                  await deleteFile();
                                  await _saveURL("");
                                }
                                showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) => FutureBuilder(
                                    future: updataUser(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        WidgetsBinding.instance
                                            .addPostFrameCallback((_) {
                                          // Add Your Code here.
                                          Navigator.pop(context);
                                          Navigator.pop(context, true);
                                        });
                                      } else if (snapshot.hasError) {
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20.0)),
                                          ),
                                          title: Text("${snapshot.error}"),
                                          actions: [
                                            FlatButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: // 확인
                                                  Text("확인",
                                                      style: TextStyle(
                                                          color: const Color(
                                                              0xffff7292),
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily:
                                                              "NotoSansCJKkr_Medium",
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontSize: _fontsize),
                                                      textAlign:
                                                          TextAlign.center),
                                            ),
                                          ],
                                        );
                                      }
                                      return Center(
                                        child: SizedBox(
                                            height: 200.w,
                                            width: 200.w,
                                            child: buildSpinKitThreeBounce(
                                                80.w, 1500.h)),
                                      );
                                    },
                                  ),
                                );
                              }
                            : () {
                                show_toast.showToast(context, "모든 필드를 입력하십시오");
                              },
                        child: // 중복확인
                            Text("OK",
                                style: TextStyle(
                                    color: const Color(0xffffffff),
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "NotoSansCJKkr_Medium",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 62.sp),
                                textAlign: TextAlign.left),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _change(String age) {
    if (age == '10') {
      setState(() {
        userAge = "10";
        changeimage[0] = true;
        changeimage[1] = false;
        changeimage[2] = false;
        changeimage[3] = false;
        changeimage[4] = false;
        changeimage[5] = false;
      });
    } else if (age == '20') {
      setState(() {
        userAge = "20";
        changeimage[0] = false;
        changeimage[1] = true;
        changeimage[2] = false;
        changeimage[3] = false;
        changeimage[4] = false;
        changeimage[5] = false;
      });
    } else if (age == '30') {
      setState(() {
        userAge = "30";
        changeimage[0] = false;
        changeimage[1] = false;
        changeimage[2] = true;
        changeimage[3] = false;
        changeimage[4] = false;
        changeimage[5] = false;
      });
    } else if (age == '40') {
      setState(() {
        userAge = "40";
        changeimage[0] = false;
        changeimage[1] = false;
        changeimage[2] = false;
        changeimage[3] = true;
        changeimage[4] = false;
        changeimage[5] = false;
      });
    } else if (age == '50') {
      setState(() {
        userAge = "50";
        changeimage[0] = false;
        changeimage[1] = false;
        changeimage[2] = false;
        changeimage[3] = false;
        changeimage[4] = true;
        changeimage[5] = false;
      });
    } else {
      setState(() {
        userAge = "60";
        changeimage[0] = false;
        changeimage[1] = false;
        changeimage[2] = false;
        changeimage[3] = false;
        changeimage[4] = false;
        changeimage[5] = true;
      });
    }
  }

  yearPicker() {
    final year = DateTime.now().year;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          title: Text(
            '생년월일을 입력하세요',
            style: TextStyle(
              color: Color.fromRGBO(255, 114, 148, 1.0),
              fontWeight: FontWeight.w500,
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
                  yController.text =
                      datee[0] + "년 " + datee[1] + "월 " + datee[2] + "일";
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
                setState(() {
                  birthday = yController.text;
                  Navigator.of(context).pop();
                });
              },
            ),
          ],
        );
      },
    );
  }
}
