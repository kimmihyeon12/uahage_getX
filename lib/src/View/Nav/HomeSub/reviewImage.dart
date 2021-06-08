import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:uahage/src/Service/review.dart';
import 'package:uahage/src/Static/url.dart';
import 'package:http/http.dart' as http;
import 'package:uahage/src/View/Nav/HomeSub/listSubMessage.dart';

class ReviewImage extends StatefulWidget {
  final data;
  const ReviewImage({Key key, @required this.data}) : super(key: key);
  @override
  _ReviewImageState createState() => _ReviewImageState();
}

class _ReviewImageState extends State<ReviewImage> {
  var data;
  @override
  void initState() {
    super.initState();
    data = widget.data;
    select();
  }

  List image = [];
  select() async {
    image = await reviewSelectImage(data.id);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 720, height: 1280);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90.h),
        child: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Color(0xffff7292)),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            '사진리뷰 모아보기',
            style: TextStyle(
                color: Color(0xffff728e),
                fontFamily: "NotoSansCJKkr_Medium",
                fontSize: 30.0.sp),
          ),
        ),
      ),
      body: GridView.builder(
          itemCount: image.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 1.0,
            mainAxisSpacing: 1.0,
          ),
          itemBuilder: (context, index) {
            return InkWell(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(image[index]["image_path"]),
                      fit: BoxFit.fitWidth),
                ),
              ),
              onTap: () {
                Get.to(ImageBig(image: image[index]["image_path"]));
              },
            );
          }),
    );
  }
}
