import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uahage/src/Static/url.dart';
import 'package:http/http.dart' as http;

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
  }

  reviewSelectImage() async {
    String url = URL;
    try {
      var response = await http.get(
        Uri.parse(url + "/api/places/restaurants/${data.id}/reviews?type=IMG"),
        // headers: <String, String>{"Authorization": controller.token.value}
      );

      return response.statusCode == 200 ? "성공" : "실패";
    } catch (err) {
      return Future.error(err);
    }
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
          itemCount: 40,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 1.0,
            mainAxisSpacing: 1.0,
          ),
          itemBuilder: (context, index) {
            return SizedBox(
              // width: 178.w,
              // height: 178.w,
              child: Image.asset("assets/reviewPage/${index % 8 + 1}.png"),
            );
          }),
    );
  }
}
