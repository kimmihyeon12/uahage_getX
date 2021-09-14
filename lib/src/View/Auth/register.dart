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
  //List<BabyInfo> babyInfo;
  List<String> birthday = [null, null, null, null];
  String nickName = "";
  List<String> gender = [null, null, null, null];
  List<bool> boy = [true, true, true, true];
  List<bool> girl = [true, true, true, true];
  List<bool> none = [true, true, true, true];
  int age = 0;
  List<bool> addbaby = [true, false, false, false];
  int addbaby_count = 0;
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
                                              print("isIdValid");
                                              print(data['idValid']);
                                              print(isIdValid);
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
              Padding(padding: EdgeInsets.only(top: 110.h)),

              //baby_Gender
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: <
                  Widget>[
                Padding(padding: EdgeInsets.only(left: 91.w)),
                Container(
                    child: normalfont(
                        "첫째아이", 58, Color.fromARGB(255, 255, 114, 148))),
                Padding(padding: EdgeInsets.only(left: 80.w)),
                InkWell(
                  onTap: () {
                    setState(() {
                      boy[0] = !boy[0];
                      girl[0] = true;
                      none[0] = true;
                      isgender = true;
                      gender[0] = "M";
                    });
                  },
                  child: Column(children: <Widget>[
                    Container(
                      height: 362.h,
                      width: 262.w,
                      child: Image.asset(boy[0] ? boy_image[0] : boy_image[1]),
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 11)),
                  ]),
                ),
                Padding(padding: EdgeInsets.only(left: 98.w)),
                InkWell(
                  onTap: () {
                    setState(() {
                      girl[0] = !girl[0];
                      boy[0] = true;
                      none[0] = true;
                      gender[0] = "F";
                      isgender = true;
                    });
                  },
                  child: Column(children: <Widget>[
                    Container(
                      height: 362.h,
                      width: 262.w,
                      child:
                          Image.asset(girl[0] ? girl_image[0] : girl_image[1]),
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 11)),
                  ]),
                ),
                Padding(padding: EdgeInsets.only(left: 98.w)),
                InkWell(
                  onTap: () {
                    setState(() {
                      none[0] = !none[0];
                      girl[0] = true;
                      boy[0] = true;
                      gender[0] = "N";
                      isgender = true;
                    });
                  },
                  child: Column(children: <Widget>[
                    Container(
                      height: 362.h,
                      width: 262.w,
                      child:
                          Image.asset(none[0] ? none_image[0] : none_image[1]),
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 11)),
                  ]),
                ),
              ]),

              //baby_birtyday
              babyBirthday(0),

              addbaby[1]
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                          Padding(padding: EdgeInsets.only(left: 91.w)),
                          Container(
                              child: normalfont("둘째아이", 58,
                                  Color.fromARGB(255, 255, 114, 148))),
                          Padding(padding: EdgeInsets.only(left: 80.w)),
                          InkWell(
                            onTap: () {
                              setState(() {
                                boy[1] = !boy[1];
                                girl[1] = true;
                                none[1] = true;

                                gender[1] = "M";
                              });
                            },
                            child: Column(children: <Widget>[
                              Container(
                                height: 362.h,
                                width: 262.w,
                                child: Image.asset(
                                    boy[1] ? boy_image[0] : boy_image[1]),
                              ),
                              Padding(padding: EdgeInsets.only(bottom: 11)),
                            ]),
                          ),
                          Padding(padding: EdgeInsets.only(left: 98.w)),
                          InkWell(
                            onTap: () {
                              setState(() {
                                girl[1] = !girl[1];
                                boy[1] = true;
                                none[1] = true;
                                gender[1] = "F";
                              });
                            },
                            child: Column(children: <Widget>[
                              Container(
                                height: 362.h,
                                width: 262.w,
                                child: Image.asset(
                                    girl[1] ? girl_image[0] : girl_image[1]),
                              ),
                              Padding(padding: EdgeInsets.only(bottom: 11)),
                            ]),
                          ),
                        ])
                  : Container(),
              addbaby[1] ? babyBirthday(1) : Container(),
              addbaby[2]
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                          Padding(padding: EdgeInsets.only(left: 91.w)),
                          Container(
                              child: normalfont("셋째아이", 58,
                                  Color.fromARGB(255, 255, 114, 148))),
                          Padding(padding: EdgeInsets.only(left: 80.w)),
                          InkWell(
                            onTap: () {
                              setState(() {
                                boy[2] = !boy[2];
                                girl[2] = true;
                                none[2] = true;

                                gender[2] = "M";
                              });
                            },
                            child: Column(children: <Widget>[
                              Container(
                                height: 362.h,
                                width: 262.w,
                                child: Image.asset(
                                    boy[2] ? boy_image[0] : boy_image[1]),
                              ),
                              Padding(padding: EdgeInsets.only(bottom: 11)),
                            ]),
                          ),
                          Padding(padding: EdgeInsets.only(left: 98.w)),
                          InkWell(
                            onTap: () {
                              setState(() {
                                girl[2] = !girl[2];
                                boy[2] = true;
                                none[2] = true;
                                gender[2] = "F";
                              });
                            },
                            child: Column(children: <Widget>[
                              Container(
                                height: 362.h,
                                width: 262.w,
                                child: Image.asset(
                                    girl[2] ? girl_image[0] : girl_image[1]),
                              ),
                              Padding(padding: EdgeInsets.only(bottom: 11)),
                            ]),
                          ),
                        ])
                  : Container(),
              addbaby[2] ? babyBirthday(2) : Container(),
              addbaby[3]
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                          Padding(padding: EdgeInsets.only(left: 91.w)),
                          Container(
                              child: normalfont("넷째아이", 58,
                                  Color.fromARGB(255, 255, 114, 148))),
                          Padding(padding: EdgeInsets.only(left: 80.w)),
                          InkWell(
                            onTap: () {
                              setState(() {
                                boy[3] = !boy[3];
                                girl[3] = true;
                                none[3] = true;

                                gender[3] = "M";
                              });
                            },
                            child: Column(children: <Widget>[
                              Container(
                                height: 362.h,
                                width: 262.w,
                                child: Image.asset(
                                    boy[3] ? boy_image[0] : boy_image[1]),
                              ),
                              Padding(padding: EdgeInsets.only(bottom: 11)),
                            ]),
                          ),
                          Padding(padding: EdgeInsets.only(left: 98.w)),
                          InkWell(
                            onTap: () {
                              setState(() {
                                girl[3] = !girl[3];
                                boy[3] = true;
                                none[3] = true;
                                gender[3] = "F";
                              });
                            },
                            child: Column(children: <Widget>[
                              Container(
                                height: 362.h,
                                width: 262.w,
                                child: Image.asset(
                                    girl[3] ? girl_image[0] : girl_image[1]),
                              ),
                              Padding(padding: EdgeInsets.only(bottom: 11)),
                            ]),
                          ),
                        ])
                  : Container(),
              addbaby[3] ? babyBirthday(3) : Container(),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(420.w, 0, 0, 0.h),
                  ),
                  addbaby_count == 0
                      ? Padding(
                          padding: EdgeInsets.fromLTRB(120.w, 0, 0, 0.h),
                        )
                      : Container(),
                  addbaby_count == 0
                      ? Container()
                      : InkWell(
                          child: Image.asset(
                            './assets/register/back.png',
                            width: 350.w,
                          ),
                          onTap: () {
                            setState(() {
                              addbaby[addbaby_count] = false;
                              boy[addbaby_count] = true;
                              girl[addbaby_count] = true;
                              birthday[addbaby_count] = '';
                              addbaby_count--;
                            });
                            print(addbaby_count);
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
                        if (addbaby_count < 4) {
                          addbaby_count++;
                          addbaby[addbaby_count] = true;
                        }
                      });
                    },
                  ),
                ],
              ),

              Padding(
                padding: EdgeInsets.fromLTRB(0, 98.h, 0, 0.h),
              ),
              //Parental age group

              Column(children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(left: 147.w)),
                    normalfont(
                        "보호자\n 연령대", 58, Color.fromARGB(255, 255, 114, 148)),
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
                        setAgeColor(1);
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
                        setAgeColor(2);
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
                    normalfont("보호자\n 연령대", 58, Colors.transparent),
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
                        setAgeColor(4);
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
                        setAgeColor(5);
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
                        setAgeColor(6);
                      },
                    ),
                  ],
                ),
              ]),
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
                  onPressed: isIdValid == true
                      // &&
                      //       age != 0 &&
                      //       gender != "" &&
                      //       birthday != ""
                      ? () async {
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) => FutureBuilder(
                              future: users.insert("withNickname", nickName,
                                  gender, birthday, age),
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
                        }
                      : () {
                          if (isIdValid == false) {
                            dialog(context, "닉네임 중복을 확인해주세요");
                          }
                        },
                  color:
                      isIdValid == true ? Color(0xffff7292) : Color(0xffcccccc),
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

              //next
              Center(
                child: FlatButton(
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (context) => FutureBuilder(
                        future:
                            users.insert("", nickName, gender, birthday, age),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            WidgetsBinding.instance
                                .addPostFrameCallback((_) async {
                              Navigator.pop(context);
                              //  if (controller.error.value == false) {
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
                  },
                  child: Text(
                    "건너뛰기",
                    style: TextStyle(
                      color: Color.fromRGBO(255, 114, 148, 1.0),
                      fontFamily: 'NotoSansCJKkr_Medium',
                      fontSize: 58.sp,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget babyBirthday(int index) {
    return Container(
      margin: EdgeInsets.fromLTRB(99.w, 20.h, 0, 70.h),
      child: Row(
        children: [
          // 아이생일
          normalfont("아이생일", 58, Color.fromARGB(255, 255, 114, 148)),
          Expanded(
            flex: 1,
            child: Container(
              margin: EdgeInsets.fromLTRB(82.w, 0, 118.w, 0),
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: () async {
                      var result = await yearPicker(context);
                      setState(() {
                        birthday[index] = result;
                        isbirthday = true;
                      });
                    },
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: yController,
                        onChanged: (txt) {
                          setState(() {
                            birthday[index] = txt;
                            isbirthday = true;
                          });
                        },
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Color(0xffff7292),
                            fontSize: 73.sp,
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
                          hintText: birthday[index] == ''
                              ? "생년월일을 선택해주세요"
                              : birthday[index],
                          hintStyle: TextStyle(
                              color: birthday[index] == ''
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
                          birthday[index] = result;
                        });
                      },
                      icon: Image.asset(
                        './assets/register/calendar.png',
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
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
}
