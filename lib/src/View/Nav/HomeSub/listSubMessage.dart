import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uahage/src/Static/Font/font.dart';

class PostMessage extends StatelessWidget {
  final avatarLink;
  final userName;
  final datetime;
  final tasteLevel;
  final priceLevel;
  final serviceLevel;
  final textMessage;
  final imageList;

  const PostMessage({
    Key key,
    this.avatarLink,
    this.userName,
    this.datetime,
    this.tasteLevel,
    this.priceLevel,
    this.serviceLevel,
    this.textMessage,
    this.imageList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = 1500 / 720;
    var height = 2667 / 1280;
    print(imageList);
    print(avatarLink);

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
                              image: NetworkImage(avatarLink),
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
                              boldfont("$userName", 58, Colors.black),
                              Padding(
                                  padding: EdgeInsets.only(left: 16 * width.w)),
                              normalfont("$datetime", 58, Color(0xff808080)),
                            ],
                          ),
                          // 3 Rating buttons
                          Row(
                            children: [
                              ContainerRating(
                                  width: 110 * width.w,
                                  text: '맛',
                                  rating: "$tasteLevel"),
                              Padding(
                                  padding: EdgeInsets.only(left: 8 * width.w)),
                              ContainerRating(
                                  width: 115 * width.w,
                                  text: '가격',
                                  rating: "$priceLevel"),
                              Padding(padding: EdgeInsets.only(left: 8.w)),
                              ContainerRating(
                                  width: 140 * width.w,
                                  text: '서비스',
                                  rating: "$serviceLevel"),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    InkWell(
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
                      Radius.circular(20),
                    ),
                    color: Color.fromRGBO(248, 248, 248, 1.0),
                  ),
                  child: Text(
                    "$textMessage", //
                    style: TextStyle(
                        color: Color.fromRGBO(0, 0, 0, 0.8),
                        fontSize: 58.sp,
                        fontFamily: "NotoSansCJKkr_Medium"),
                  ),
                ),
                //Images
                Container(
                  height: 236 * height.h,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.all(8),
                    children: <Widget>[
                      for (int i = 0; i < imageList.length; i++)
                        Container(
                          margin: EdgeInsets.only(right: 10 * width.w),
                          width: 308 * width.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            image: DecorationImage(
                                image: NetworkImage(imageList[i]),
                                fit: BoxFit.fitWidth),
                          ),
                        ),
                      // Container(
                      //   decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.all(Radius.circular(30)),
                      //   ),
                      //   margin: EdgeInsets.only(right: 10 * width.w),
                      //   width: 318 * width.w,
                      //   child:
                      //       Image.network(imageList[i], fit: BoxFit.fitWidth),
                      // ),
                    ],
                  ),
                ),
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
