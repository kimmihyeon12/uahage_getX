import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

import 'package:uahage/src/Controller/user.controller.dart';
import 'package:uahage/src/Service/user.dart';
import 'package:uahage/src/Static/Font/font.dart';
import 'package:uahage/src/Static/Widget/dialog.dart';
import 'package:uahage/src/Static/Widget/toast.dart';
import 'package:uahage/src/Static/Widget/yearpicker.dart';
import 'package:uahage/src/Static/url.dart';

class UserModify extends StatefulWidget {
  @override
  _UserModifyState createState() => _UserModifyState();
}

class _UserModifyState extends State<UserModify> {
  TextEditingController yController = TextEditingController();
  user User = new user();
  var ageImage = [false, false, false, false, false, false];

  bool isIdValid = false;
  var boy_image = [
    './assets/register/boy_grey.png',
    './assets/register/boy_pink.png'
  ];
  var girl_image = [
    './assets/register/girl_grey.png',
    './assets/register/girl_pink.png'
  ];
  String _uploadedFileURL = "";
  File _image;
  String imageLink = "";
  String nickName = "";
  dynamic recievedImage;
  String gender = "";
  bool boy = true;
  bool girl = true;
  String birthday = "";
  int age = 0;

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
                      setState(() {
                        _image = null;
                        imageLink = "";
                      });
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
          "Authorization": UserController.to.token.value
        },
        body: jsonEncode({"fileName": imageLink}),
      );
      setState(() {
        recievedImage = null;
      });
    } catch (err) {}
  }

  Future _imgFromCamera() async {
    var image = await ImagePicker()
        .getImage(source: ImageSource.camera, imageQuality: 20);

    setState(() {
      recievedImage = null;
      _image = File(image.path);
    });
  }

  Future _imgFromGallery() async {
    var image = await ImagePicker()
        .getImage(source: ImageSource.gallery, imageQuality: 20);

    setState(() {
      recievedImage = null;
      _image = File(image.path);
    });
  }

  uploadFile(File file) async {
    if (imageLink != "") {
      try {
        await http.post(
          url + "/api/s3/images-delete",
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            "Authorization": UserController.to.token.value
          },
          body: jsonEncode({"fileName": imageLink}),
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
            url + '/api/s3/images/${UserController.to.userId.value}',
            data: formData);
        setState(() {
          _uploadedFileURL = response.data["location"];
          imageLink = _uploadedFileURL;
        });
        print("Printing after upload imagelink " + _uploadedFileURL);
        await _saveURL(_uploadedFileURL);
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
        url + "/api/users/${UserController.to.userId.value}",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Authorization": UserController.to.token.value
        },
        body: jsonEncode({"profile_url": _uploadedFileURL}),
      );
    } catch (error) {}
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 1500, height: 2667);
    FocusScopeNode currentFocus = FocusScope.of(context);

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
                            child: normalfont(
                                "내 정보", 62, Color.fromRGBO(255, 114, 148, 1.0)),
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
                        child: CircleAvatar(
                          backgroundImage:
                              AssetImage("./assets/myPage/avatar.png"),
                          child: (() {
                            print("here " + imageLink);
                            // your code here
                            if (recievedImage != null) {
                              if (recievedImage is String) {
                                setState(() {
                                  imageLink = recievedImage;
                                });

                                return Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            recievedImage), //imageURL
                                        fit: BoxFit.cover),
                                  ),
                                );
                              } else
                                return Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image:
                                            FileImage(recievedImage), //imageURL
                                        fit: BoxFit.cover),
                                  ),
                                );
                            } else if (_image != null) {
                              print("1");
                              return Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: FileImage(_image), //imageURL
                                      fit: BoxFit.cover),
                                ),
                              );
                            } else if (imageLink != "" && imageLink != null) {
                              print("2");
                              return Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: NetworkImage(imageLink),
                                      fit: BoxFit.cover),
                                ),
                              );
                            } else {
                              print("3");
                              return Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: AssetImage(
                                        "./assets/myPage/avatar.png"),
                                  ),
                                ),
                              );
                            }
                          }()),
                        ),
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
                          child: normalfont(
                              "닉네임", 58, Color.fromRGBO(255, 114, 148, 1.0)),
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
                                    txt.length <= 10
                                        ? setState(() {
                                            nickName = txt;
                                          })
                                        : null;
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
                                    onPressed: nickName != ""
                                        ? () async {
                                            var data = await User.checkNickName(
                                                nickName);
                                            setState(() {
                                              isIdValid = data['idValid'];
                                            });
                                            currentFocus.unfocus();
                                            dialog(
                                              context,
                                              data['value'],
                                            );
                                          }
                                        : () {},
                                    child: // 중복확인
                                        normalfont("중복확인", 58, Colors.white),
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
                            boy = false;
                            girl = true;
                          });
                        },
                        child: Column(children: <Widget>[
                          Container(
                            height: 362.h,
                            width: 262.w,
                            child:
                                Image.asset(boy ? boy_image[0] : boy_image[1]),
                          ),
                          Padding(padding: EdgeInsets.only(bottom: 11)),
                        ]),
                      ),
                      Padding(padding: EdgeInsets.only(left: 98.w)),
                      InkWell(
                        onTap: () {
                          setState(() {
                            gender = "F";
                            boy = true;
                            girl = false;
                          });
                        },
                        child: Column(children: <Widget>[
                          Container(
                            height: 362.h,
                            width: 262.w,
                            child: Image.asset(
                                girl ? girl_image[0] : girl_image[1]),
                          ),
                          Padding(padding: EdgeInsets.only(bottom: 11)),
                        ]),
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
                                onTap: () async {
                                  var result = await yearPicker(context);
                                  setState(() {
                                    birthday = result;
                                  });
                                },
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
                                          color: birthday == ''
                                              ? Color(0xffd4d4d4)
                                              : Color(0xffff7292),
                                          fontWeight: FontWeight.w500,
                                          fontFamily: "NotoSansCJKkr_Medium",
                                          fontSize: 58.0.sp),
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: IconButton(
                                  onPressed: () async {
                                    var result = await yearPicker(context);
                                    setState(() {
                                      birthday = result;
                                    });
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

                Padding(
                  padding: EdgeInsets.fromLTRB(0, 98.h, 0, 0.h),
                ),
                //Ages
                Column(children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(padding: EdgeInsets.only(left: 147.w)),
                      normalfont(
                          "보호자\n연령대", 58, Color.fromARGB(255, 255, 114, 148)),
                      Padding(padding: EdgeInsets.only(left: 62.w)),
                      InkWell(
                        child: Image.asset(
                          ageImage[0]
                              ? './assets/register/10_pink.png'
                              : './assets/register/10_grey.png',
                          height: 196.h,
                          width: 251.w,
                        ),
                        onTap: () {
                          setAgeColor(10);
                        },
                      ),
                      Padding(padding: EdgeInsets.only(left: 55.w)),
                      InkWell(
                        child: Image.asset(
                          ageImage[1]
                              ? './assets/register/20_pink.png'
                              : './assets/register/20_grey.png',
                          height: 196.h,
                          width: 251.w,
                        ),
                        onTap: () {
                          setAgeColor(20);
                        },
                      ),
                      Padding(padding: EdgeInsets.only(left: 55.w)),
                      InkWell(
                        child: Image.asset(
                          ageImage[2]
                              ? './assets/register/30_pink.png'
                              : './assets/register/30_grey.png',
                          height: 196.h,
                          width: 251.w,
                        ),
                        onTap: () {
                          setAgeColor(30);
                        },
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.only(top: 25.w)),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(padding: EdgeInsets.only(left: 147.w)),
                      normalfont("보호자\n연령대", 58, Colors.transparent),
                      Padding(padding: EdgeInsets.only(left: 62.w)),
                      InkWell(
                        child: Image.asset(
                          ageImage[3]
                              ? './assets/register/40_pink.png'
                              : './assets/register/40_grey.png',
                          height: 196.h,
                          width: 251.w,
                        ),
                        onTap: () {
                          setAgeColor(40);
                        },
                      ),
                      Padding(padding: EdgeInsets.only(left: 55.w)),
                      InkWell(
                        child: Image.asset(
                          ageImage[4]
                              ? './assets/register/50_pink.png'
                              : './assets/register/50_grey.png',
                          height: 196.h,
                          width: 251.w,
                        ),
                        onTap: () {
                          setAgeColor(50);
                        },
                      ),
                      Padding(padding: EdgeInsets.only(left: 55.w)),
                      InkWell(
                        child: Image.asset(
                          ageImage[5]
                              ? './assets/register/others_pink.png'
                              : './assets/register/others_grey.png',
                          height: 196.h,
                          width: 251.w,
                        ),
                        onTap: () {
                          setAgeColor(60);
                        },
                      ),
                    ],
                  ),
                ]),
                Padding(padding: EdgeInsets.only(top: 125.h)),

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
                                age != 0 &&
                                gender != "" &&
                                birthday != "" &&
                                nickName != ""
                            ? Color(0xffff7292)
                            : Color(0xffcacaca),
                        onPressed: isIdValid &&
                                age != 0 &&
                                gender != "" &&
                                birthday != "" &&
                                nickName != ""
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
                                    future: User.updataUser(
                                        nickName, gender, birthday, age),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        WidgetsBinding.instance
                                            .addPostFrameCallback((_) {
                                          print("확인");
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
                                                  normalfont("확인", 58,
                                                      Color(0xffff7292)),
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
                                toast(context, "모든 필드를 입력하십시오");
                              },
                        child: // 중복확인
                            normalfont("확인", 62, Color(0xffffffff)),
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

  setAgeColor(int value) {
    age = value;
    for (int i = 0; i < ageImage.length; i++) {
      setState(() {
        if ((value / 10 - 1) == i) {
          ageImage[i] = true;
        } else
          ageImage[i] = false;
      });
    }
  }
}
