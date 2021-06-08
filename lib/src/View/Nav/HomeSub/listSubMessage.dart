import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:uahage/src/Controller/user.controller.dart';
import 'package:uahage/src/Static/Font/font.dart';
import 'package:uahage/src/Static/Widget/dialog.dart';
import 'package:uahage/src/Static/Widget/progress.dart';
import 'package:uahage/src/Static/url.dart';
import 'package:http/http.dart' as http;

class SubMessage extends StatefulWidget {
  final data;
  const SubMessage({Key key, this.data}) : super(key: key);

  @override
  _SubMessageState createState() => _SubMessageState();
}

class _SubMessageState extends State<SubMessage> {
  var data;
  List imageLink;
  initState() {
    // 부모의 initState호출
    super.initState();
    data = widget.data;
    imageLink = data.image_path != null ? data.image_path.split(',') : null;
    print(imageLink);
    setState(() {});
  }

  delete(reviewId) async {
    String url = URL;
    try {
      var response = await http.delete(
        Uri.parse(url + "/api/places/restaurants/reviews/${reviewId}"),
      );
      return "정말 삭제하시겠습니까?";
    } catch (err) {
      return Future.error(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = 1500 / 720;
    var height = 2667 / 1280;
    print("listsubmessage");
    ScreenUtil.init(context, width: 1500, height: 2667);
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(40 * width.w, 30.h, 40 * width.w, 33.h),
            width: double.infinity,
            child: Column(
              children: [
                // first container
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 40 * width.w,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: NetworkImage(data.profile),
                              fit: BoxFit.cover),
                        ),
                      ),
                    ),
                    // Container after avatar image
                    Container(
                      margin: EdgeInsets.only(left: 15 * width.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // userName
                          Row(
                            children: [
                              boldfont("${data.nickname} ", 58, Colors.black),
                              Padding(
                                  padding: EdgeInsets.only(left: 16 * width.w)),
                              normalfont(
                                  "${data.created_at} ", 58, Color(0xff808080)),
                            ],
                          ),
                          // 3 Rating buttons
                          Row(
                            children: [
                              ContainerRating(
                                  width: 110 * width.w,
                                  text: '맛',
                                  rating: "${data.taste_rating}"),
                              Padding(
                                  padding: EdgeInsets.only(left: 8 * width.w)),
                              ContainerRating(
                                  width: 115 * width.w,
                                  text: '가격',
                                  rating: "${data.cost_rating}"),
                              Padding(padding: EdgeInsets.only(left: 8.w)),
                              ContainerRating(
                                  width: 140 * width.w,
                                  text: '서비스',
                                  rating: "${data.service_rating}"),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    UserController.to.userId == data.user_id.toString()
                        ? Row(
                            children: [
                              InkWell(
                                onTap: () {},
                                child: Text(
                                  "수정",
                                  style: TextStyle(
                                      fontSize: 24 * width.sp,
                                      fontFamily: "NotoSansCJKkr_Medium",
                                      color:
                                          Color.fromRGBO(147, 147, 147, 1.0)),
                                ),
                              ),
                              Padding(
                                  padding: EdgeInsets.only(left: 20 * width.w)),
                              InkWell(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0)),
                                      ),
                                      title: normalfont("리뷰를 삭제하시겠습니까", 58,
                                          Color(0xff4d4d4d)),
                                      actions: [
                                        FlatButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: normalfont(
                                              "아니요", 55, Color(0xffff7292)),
                                        ),
                                        FlatButton(
                                          onPressed: () async {
                                            Navigator.pop(context, true);

                                            //delete data in the database
                                            showDialog(
                                              context: context,
                                              builder: (_) => FutureBuilder(
                                                future: delete(data.id),
                                                builder: (context, snapshot) {
                                                  if (snapshot.hasData) {
                                                    WidgetsBinding.instance
                                                        .addPostFrameCallback(
                                                            (_) async {
                                                      Get.back();
                                                    });
                                                  } else if (snapshot
                                                      .hasError) {
                                                    return AlertDialog(
                                                      title: Text(
                                                          "${snapshot.error}"),
                                                    );
                                                  }
                                                  return progress();
                                                },
                                              ),
                                            );
                                          },
                                          child: // 네
                                              normalfont(
                                                  "예", 55, Color(0xffff7292)),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                child: Text(
                                  "삭제",
                                  style: TextStyle(
                                      fontSize: 24 * width.sp,
                                      fontFamily: "NotoSansCJKkr_Medium",
                                      color:
                                          Color.fromRGBO(147, 147, 147, 1.0)),
                                ),
                              ),
                            ],
                          )
                        : InkWell(
                            onTap: () {},
                            child: Text(
                              "신고",
                              style: TextStyle(
                                  fontSize: 24 * width.sp,
                                  fontFamily: "NotoSansCJKkr_Medium",
                                  color: Color.fromRGBO(147, 147, 147, 1.0)),
                            ),
                          ),
                  ],
                ),
                //text message
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 16 * width.w),
                  padding: EdgeInsets.symmetric(
                      horizontal: 13 * width.w, vertical: 19 * width.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    color: Color.fromRGBO(248, 248, 248, 1.0),
                  ),
                  child: Text(
                    "${data.description} ", //
                    style: TextStyle(
                        color: Color.fromRGBO(0, 0, 0, 0.8),
                        fontSize: 58.sp,
                        fontFamily: "NotoSansCJKkr_Medium"),
                  ),
                ),
                //Images
                Stack(
                  children: [
                    imageLink == null
                        ? Container()
                        : Container(
                            height: 236 * height.h,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.only(top: 16 * height.h),
                              children: <Widget>[
                                for (int i = 0; i < imageLink.length; i++)
                                  InkWell(
                                    child: Container(
                                      margin:
                                          EdgeInsets.only(right: 10 * width.w),
                                      width: 308 * width.w,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        image: DecorationImage(
                                            image: NetworkImage(imageLink[i]),
                                            fit: BoxFit.fitWidth),
                                      ),
                                    ),
                                    onTap: () {
                                      Get.to(ImageBig(image: imageLink[i]));
                                    },
                                  ),
                              ],
                            ),
                          ),
                  ],
                )
              ],
            ),
          ),
          Divider(
            color: Color.fromRGBO(212, 212, 212, 1.0),
          )
        ],
      ),
    );
  }
}

class ContainerRating extends StatelessWidget {
  final width;
  final text;
  final rating;
  const ContainerRating({
    Key key,
    @required this.width,
    @required this.text,
    @required this.rating,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          //taste
          // normalfont("$text", 20 * width.sp, Color(0xff808080)),
          // normalfont("$text", 20 * width.sp, Color(0xff808080)),
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
}

class ImageBig extends StatelessWidget {
  final image;

  const ImageBig({
    Key key,
    @required this.image,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          image:
              DecorationImage(image: NetworkImage(image), fit: BoxFit.contain),
        ),
      ),
      color: Colors.black,
    );
  }
}
