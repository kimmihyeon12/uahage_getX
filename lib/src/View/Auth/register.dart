import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uahage/src/Controller/user.controller.dart';

import 'package:uahage/src/Static/Font/font.dart';
import 'package:uahage/src/Static/Image/mypageImage.dart';
import 'package:uahage/src/Static/Widget/appbar.dart';
import 'package:uahage/src/Static/Widget/dialog.dart';
import 'package:uahage/src/Static/url.dart';
import 'package:uahage/src/Static/Widget/yearpicker.dart';
import 'package:uahage/src/Static/Widget/progress.dart';

import 'package:uahage/src/Service/users.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

// class BabyInfo {
//   String gender;
//   String birthday;
// }

class _RegisterState extends State<Register> {
  String url = URL;

  Users users = new Users();
  //user
  bool isIdValid = false;
  bool isbirthday = false;
  bool isgender = false;
  bool babyAllValid;
  //List<BabyInfo> babyInfo;

  String nickName = "";
  List<String> birthday = [null, null, null, null];
  List<String> gender = [null, null, null, null];
  List<String> babyNumberName = ["첫째", "둘째", "셋째", "넷째"];
  int babyNumber = 1;
  bool addbaby = false;
  List<bool> boy = [true, true, true, true];
  List<bool> girl = [true, true, true, true];
  List<bool> none = [true, true, true, true];
  int age = 0;

  TextEditingController yController = TextEditingController();
  var ageImage = [false, false, false, false, false, false];

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 1500, height: 2667);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    FocusScopeNode currentFocus = FocusScope.of(context);
    return SafeArea(
      child: Scaffold(
        appBar: imageAppbar(context, "회원가입"),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(padding: EdgeInsets.only(top: 250.h)),

              //membership_Nickname
              Container(
                child: Container(
                  child: Row(
                    children: [
                      Padding(padding: EdgeInsets.only(left: 150.w)),
                      normalfont("닉네임", 58, Color.fromRGBO(255, 114, 148, 1.0)),
                      Padding(padding: EdgeInsets.only(left: 88.w)),
                      Expanded(
                        flex: 1,
                        child: Container(
                          margin: EdgeInsets.only(right: 121.sp),
                          child: Stack(
                            children: [
                              TextFormField(
                                onChanged: (value) {
                                  if (value.length <= 10)
                                    setState(() {
                                      nickName = value;
                                    });
                                },
                                maxLength: 10,
                                style: TextStyle(
                                  color: const Color(0xff3a3939),
                                  fontFamily: "NotoSansCJKkr_Medium",
                                  fontStyle: FontStyle.normal,
                                  fontSize: 62.5.sp,
                                ),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(right: 20.w),
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
                                      color: Color(0xffcccccc),
                                      fontSize: 58.sp,
                                      letterSpacing: -1.0),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  width: 350.w,
                                  height: 135.h,
                                  child: FlatButton(
                                    shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(8.0),
                                    ),
                                    onPressed: nickName != ""
                                        ? () async {
                                            var data = await users
                                                .checkNickName(nickName);
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
                                    color: nickName == ""
                                        ? Color(0xffcacaca)
                                        : Color(0xffff7292),
                                    child: Text(
                                      "중복확인",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'NotoSansCJKkr_Medium',
                                        fontSize: 58.sp,
                                      ),
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
                ),
              ),

              //baby_Gender
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
                      if (gender[0] == "N") {
                        gender[0] = null;
                        birthday[0] = null;
                      }
                      if (babyNumber < 4) {
                        babyNumber++;
                        addbaby = true;
                      }
                    });
                  },
                ),
              ]),

              //Parental age group

              (() {
                int number = 0;
                List<Widget> clist = new List<Widget>();
                for (int i = 0; i < 2; i++) {
                  if (i == 1) {
                    number = 3;
                  }
                  clist.add(
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(padding: EdgeInsets.only(left: 147.w)),
                          normalfont(
                              "보호자\n연령대",
                              58,
                              i == 0
                                  ? Color.fromARGB(255, 255, 114, 148)
                                  : Colors.transparent),
                          Padding(padding: EdgeInsets.only(left: 62.w)),
                          (() {
                            List<Widget> list = new List<Widget>();
                            for (int j = 0; j < 3; j++) {
                              list.add(Container(
                                margin:
                                    EdgeInsets.only(right: 55.w, bottom: 20.h),
                                child: InkWell(
                                  child: Image.asset(
                                    ageImage[number + j]
                                        ? './assets/register/${number + j + 1}0_pink.png'
                                        : './assets/register/${number + j + 1}0_grey.png',
                                    height: 196.h,
                                    width: 251.w,
                                  ),
                                  onTap: () {
                                    i == 0
                                        ? setAgeColor(j + 1)
                                        : setAgeColor(number + j + 1);
                                  },
                                ),
                              ));
                            }
                            return new Row(children: list);
                          }()),
                        ]),
                  );
                }
                return new Column(children: clist);
              }()),

              Padding(padding: EdgeInsets.only(top: 125.h)),

              //ok button
              Container(
                width: 1193.w,
                height: 194.h,
                // margin: EdgeInsets.only(bottom: 70/(2667/ScreenHeight)),
                child: FlatButton(
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(8.0),
                  ),
                  onPressed: () async {
                    if (isIdValid && babyAllValid)
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) => FutureBuilder(
                          future: users.insert(
                              "withNickname", nickName, gender, birthday, age),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              WidgetsBinding.instance
                                  .addPostFrameCallback((_) async {
                                Navigator.pop(context);
                                //if (controller.error.value == false) {
                                Get.offNamed("/navigator");
                                //  }
                              });
                            } else if (snapshot.hasError) {
                              dialog(context, snapshot);
                            }
                            return progress();
                          },
                        ),
                      );
                    if (!isIdValid) dialog(context, "아이디 중복확인을 해주세요");
                    if (!babyAllValid) dialog(context, "모든 값을 입력해주세요");
                  },
                  color: isIdValid == true && babyAllValid == true
                      ? Color(0xffff7292)
                      : Color(0xffcccccc),
                  child: Text(
                    "OK",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'NotoSansCJKkr_Medium',
                      fontSize: 57.sp,
                    ),
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 270.h)),
            ],
          ),
        ),
      ),
    );
  }

  setAgeColor(int value) {
    age = value;
    for (int i = 0; i < ageImage.length; i++) {
      setState(() {
        if ((value - 1) == i) {
          ageImage[i] = true;
        } else
          ageImage[i] = false;
      });
    }
  }

  Widget changeBabyGender(int i) {
    print("gender ${gender[i]}");
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

                    birthday[i] = null;
                  }
                  babyAllValid = true;
                  for (int i = 0; i < babyNumber; i++) {
                    if (birthday[i] == null || gender[i] == null) {
                      babyAllValid = false;
                    }
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
                    birthday[i] = null;
                  }
                  babyAllValid = true;
                  for (int i = 0; i < babyNumber; i++) {
                    if (birthday[i] == null || gender[i] == null) {
                      babyAllValid = false;
                    }
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
                          birthday[i] = "아기가 아직 없어요!";
                        }
                        babyAllValid = true;
                        for (int i = 0; i < babyNumber; i++) {
                          if (birthday[i] == null || gender[i] == null) {
                            babyAllValid = false;
                          }
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
                      if (!(gender[i] == "N")) {
                        var result = await yearPicker(context);
                        setState(() {
                          if (result == "")
                            birthday[i] = null;
                          else
                            birthday[i] = result;
                          babyAllValid = true;
                          for (int i = 0; i < babyNumber; i++) {
                            if (birthday[i] == null || gender[i] == null) {
                              babyAllValid = false;
                            }
                          }
                        });
                      }
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
}
