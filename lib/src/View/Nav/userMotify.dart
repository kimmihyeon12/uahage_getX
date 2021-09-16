import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:uahage/src/Controller/user.controller.dart';
import 'package:uahage/src/Service/users.dart';
import 'package:uahage/src/Static/Font/font.dart';
import 'package:uahage/src/Static/Image/mypageImage.dart';
import 'package:uahage/src/Static/Widget/bottomsheet.dart';
import 'package:uahage/src/Static/Widget/dialog.dart';
import 'package:uahage/src/Static/Widget/toast.dart';
import 'package:uahage/src/Static/Widget/yearpicker.dart';
import 'package:uahage/src/Static/url.dart';

class UserModify extends StatefulWidget {
  final userdata;
  const UserModify({
    Key key,
    this.userdata,
  }) : super(key: key);
  @override
  _UserModifyState createState() => _UserModifyState();
}

class _UserModifyState extends State<UserModify> {
  String url = URL;
  Users users = new Users();
  Map userdata;
  List<String> gender = [null, null, null, null];
  List<String> birthday = [null, null, null, null];
  List<String> babyNumberName = ["첫째", "둘째", "셋째", "넷째"];
  int babyNumber;
  bool addbaby = false;

  TextEditingController yController = TextEditingController();
  var ageImage = [false, false, false, false, false, false];
  bool isIdValid = false;
  String _uploadedFileURL = "";
  File _image;
  bool isImage = false;
  String imageLink = "";
  dynamic recievedImage;

  @override
  void initState() {
    super.initState();
    userdata = widget.userdata;
    userdata["nickname"] != "" ? isIdValid = true : isIdValid = false;
    babyNumber = userdata["babies"].length;
    for (int i = 0; i < babyNumber; i++) {
      gender[i] = userdata["babies"][i]["babyGender"];
      birthday[i] = userdata["babies"][i]["babyBirthday"];
    }
  }

  void _imageBottomSheet(context) async {
    Sheet sheet = new Sheet();
    await sheet.bottomSheet(context, "delete");
    if (sheet.image != null) {
      setState(() {
        _image = sheet.image;
        print(_image);
      });
    } else {
      setState(() {
        userdata["image"] = null;
      });
    }
  }

  Future _formData() async {
    File file = _image;
    String fileName;
    FormData formData;
    if (userdata["image"] == null) {
      setState(() {
        isImage = true;
      });
    }
    if (_image == null) {
      print("이미지 삭제~~~~~");
      formData = FormData.fromMap({
        "imageInit": "Y",
        "nickname": "${userdata["nickname"]}",
        "ageGroupType": userdata["ageGroupType"],
        "babyGenders": gender,
        "babyBirthdays": birthday,
      });
    } else {
      formData = FormData.fromMap({
        "images": await MultipartFile.fromFile(file.path,
            filename: file.path.split('/').last),
        "nickname": "${userdata["nickname"]}",
        "ageGroupType": userdata["ageGroupType"],
        "babyGenders": gender,
        "babyBirthdays": birthday,
      });
    }

    return formData;
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
                            if (userdata["image"] != null && _image == null) {
                              return Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: NetworkImage(userdata["image"]
                                          ["previewImagePath"]), //imageURL
                                      fit: BoxFit.cover),
                                ),
                              );
                            } else if (_image != null) {
                              return Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: FileImage(_image), //imageURL
                                      fit: BoxFit.cover),
                                ),
                              );
                            } else {
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
                        right: -5,
                        bottom: -5,
                        child: Container(
                          child: InkWell(
                            onTap: () {
                              _imageBottomSheet(context);
                            },
                            child: Image.asset(
                              "./assets/myPage/camera.png",
                              height: 150.h,
                              width: 150.w,
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
                                    setState(() {
                                      isIdValid = false;
                                      userdata["nickname"] = txt;
                                    });
                                  },
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Color(0xff3a3939),
                                      fontFamily: "NotoSansCJKkr_Bold",
                                      fontSize: 58.sp),
                                  decoration: InputDecoration(
                                    counterText: '',
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
                                    hintText: userdata["nickname"] == ''
                                        ? "닉네임을 입력하세요"
                                        : userdata["nickname"],
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
                                    color: userdata["nickname"] == ""
                                        ? Color(0xffcacaca)
                                        : Color(0xffff7292),
                                    onPressed: userdata["nickname"] != ""
                                        ? () async {
                                            var data =
                                                await users.checkNickName(
                                                    userdata["nickname"]);
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

                (() {
                  List<Widget> list = new List<Widget>();
                  for (int i = 0; i < babyNumber; i++) {
                    //  Gender
                    list.add(changeBabyGender(i));
                    // // Birthday
                    list.add(changeBabyBirthday(i));
                  }
                  return new Column(children: list);
                }()),
                //되돌리기 아이추가
                Row(children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(420.w, 230.h, 0, 0.h),
                  ),
                  babyNumber - 1 == 0
                      ? Padding(
                          padding: EdgeInsets.fromLTRB(120.w, 0, 0, 0.h),
                        )
                      : Container(),
                  babyNumber - 1 == 0
                      ? Container()
                      : InkWell(
                          child: Image.asset(
                            './assets/register/back.png',
                            width: 350.w,
                          ),
                          onTap: () {
                            setState(() {
                              gender[babyNumber - 1] = null;
                              birthday[babyNumber - 1] = null;
                              babyNumber--;
                              addbaby = false;
                            });
                          },
                        ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(100.w, 0, 0, 0.h),
                  ),
                  InkWell(
                    child: Image.asset(
                      './assets/register/addbaby.png',
                      width: 350.w,
                    ),
                    onTap: () {
                      setState(() {
                        if (babyNumber < 4) {
                          babyNumber++;
                          addbaby = true;
                        }
                      });
                    },
                  ),
                ]),

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
                          userdata["ageGroupType"] == 1
                              ? './assets/register/10_pink.png'
                              : './assets/register/10_grey.png',
                          height: 196.h,
                          width: 251.w,
                        ),
                        onTap: () {
                          setAgeColor(1);
                        },
                      ),
                      Padding(padding: EdgeInsets.only(left: 55.w)),
                      InkWell(
                        child: Image.asset(
                          userdata["ageGroupType"] == 2
                              ? './assets/register/20_pink.png'
                              : './assets/register/20_grey.png',
                          height: 196.h,
                          width: 251.w,
                        ),
                        onTap: () {
                          setAgeColor(2);
                        },
                      ),
                      Padding(padding: EdgeInsets.only(left: 55.w)),
                      InkWell(
                        child: Image.asset(
                          userdata["ageGroupType"] == 3
                              ? './assets/register/30_pink.png'
                              : './assets/register/30_grey.png',
                          height: 196.h,
                          width: 251.w,
                        ),
                        onTap: () {
                          setAgeColor(3);
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
                          userdata["ageGroupType"] == 4
                              ? './assets/register/40_pink.png'
                              : './assets/register/40_grey.png',
                          height: 196.h,
                          width: 251.w,
                        ),
                        onTap: () {
                          setAgeColor(4);
                        },
                      ),
                      Padding(padding: EdgeInsets.only(left: 55.w)),
                      InkWell(
                        child: Image.asset(
                          userdata["ageGroupType"] == 5
                              ? './assets/register/50_pink.png'
                              : './assets/register/50_grey.png',
                          height: 196.h,
                          width: 251.w,
                        ),
                        onTap: () {
                          setAgeColor(5);
                        },
                      ),
                      Padding(padding: EdgeInsets.only(left: 55.w)),
                      InkWell(
                        child: Image.asset(
                          userdata["ageGroupType"] == 6
                              ? './assets/register/60_pink.png'
                              : './assets/register/60_grey.png',
                          height: 196.h,
                          width: 251.w,
                        ),
                        onTap: () {
                          setAgeColor(6);
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
                        color: isIdValid
                            // &&
                            //         userdata["ageGroupType"] != "" &&
                            //         userdata['baby_gender'] != "" &&
                            //         userdata["baby_birthday"] != ""
                            ? Color(0xffff7292)
                            : Color(0xffcacaca),
                        onPressed: isIdValid
                            // &&
                            //         userdata["ageGroupType"] != "" &&
                            //         userdata['baby_gender'] != "" &&
                            //         userdata["baby_birthday"] != ""
                            ? () async {
                                var formdata = await _formData();
                                showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) => FutureBuilder(
                                    future: users.update(formdata),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        WidgetsBinding.instance
                                            .addPostFrameCallback((_) {
                                          Navigator.pop(context, true);
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
                                toast(context, "모든 필드를 입력하십시오", "bottom");
                                if (isIdValid == false) {
                                  dialog(context, "닉네임 중복을 확인해주세요");
                                }
                              },
                        child: // 중복확인
                            normalfont("확인", 62, Color(0xffffffff)),
                      ),
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 300.h)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget changeBabyGender(int i) {
    return Container(
      margin: EdgeInsets.fromLTRB(99.w, 35.h, 0, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              child: normalfont("${babyNumberName[i]}아이", 58,
                  Color.fromARGB(255, 255, 114, 148))),
          Container(
            margin: EdgeInsets.fromLTRB(99.w, 0.h, 0, 0),
            height: 362.h,
            width: 262.w,
            child: InkWell(
              child:
                  Image.asset(gender[i] != "F" ? girl_image[0] : girl_image[1]),
              onTap: () {
                setState(() {
                  if (gender[i] == "F")
                    gender[i] == null;
                  else {
                    gender[i] = "F";
                  }
                });
              },
            ),
          ),
          Container(
            height: 362.h,
            width: 262.w,
            margin: EdgeInsets.only(left: 80.w),
            child: InkWell(
              child:
                  Image.asset(gender[i] != "M" ? boy_image[0] : boy_image[1]),
              onTap: () {
                setState(() {
                  if (gender[i] == "M")
                    gender[i] == null;
                  else {
                    gender[i] = "M";
                  }
                });
              },
            ),
          ),
          i == 0 && addbaby == false
              ? Container(
                  height: 362.h,
                  width: 293.w,
                  margin: EdgeInsets.only(top: 22.h, left: 80.w),
                  child: InkWell(
                    child: Image.asset(
                        gender[i] != "N" ? none_image[0] : none_image[1]),
                    onTap: () {
                      setState(() {
                        if (gender[i] == "N")
                          gender[i] == null;
                        else {
                          gender[i] = "N";
                        }
                      });
                    },
                  ))
              : Container(),
        ],
      ),
    );
  }

  Widget changeBabyBirthday(int i) {
    return Container(
      margin: EdgeInsets.fromLTRB(99.w, 5.h, 0, 0),
      child: Row(
        children: [
          // 아이생일
          normalfont("아이생일", 58, Color.fromARGB(255, 255, 114, 148)),
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
                        birthday[i] = result;
                        //isbirthday = true;
                      });
                    },
                    child: AbsorbPointer(
                      child: TextFormField(
                        readOnly: true,
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
                            borderSide: BorderSide(color: Color(0xffff7292)),
                          ),
                          hintText: birthday[i] == null
                              ? "생년월일을 선택해주세요 🍰"
                              : birthday[i] + "  🍰",
                          hintStyle: TextStyle(
                              color: birthday[i] == null
                                  ? Color(0xffd4d4d4)
                                  : Color(0xffff7292),
                              fontFamily: "NotoSansCJKkr_Medium",
                              fontSize: 57.0.sp),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  setAgeColor(int value) {
    setState(() {
      userdata["ageGroupType"] = value;
    });
  }
}
