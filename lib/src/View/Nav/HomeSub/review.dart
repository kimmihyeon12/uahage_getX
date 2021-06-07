import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uahage/src/Controller/user.controller.dart';
import 'package:uahage/src/Service/review.dart';
import 'package:uahage/src/Static/Font/font.dart';
import 'package:uahage/src/Static/Widget/appbar.dart';
import 'package:uahage/src/Static/url.dart';

class ReviewPage extends StatefulWidget {
  final data;

  const ReviewPage({Key key, @required this.data}) : super(key: key);
  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  var data;
  List ratingLabel = ["아주 좋아요", "맘에 들어요", "보통이에요", "그냥 그래요", "별로예요", "평가없음"];
  List<dynamic> uploadingImage = [];
  int index1 = 5, index2 = 5, index3 = 5;
  bool btnColor = false;
  var width = 1500 / 720;
  var height = 2667 / 1280;

  String review = "1";
  double taste, cost, service;
  @override
  void initState() {
    super.initState();
    data = widget.data;
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: Icon(
                        Icons.photo_library,
                        color: Color.fromRGBO(255, 114, 148, 1.0),
                      ),
                      title: Text('겔러리'),
                      onTap: () async {
                        await _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: Icon(
                      Icons.photo_camera,
                      color: Color.fromRGBO(255, 114, 148, 1.0),
                    ),
                    title: Text('카메라'),
                    onTap: () async {
                      await _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future _imgFromCamera() async {
    try {
      var image = await ImagePicker().getImage(
        source: ImageSource.camera,
        imageQuality: 20,
      );

      setState(() {
        uploadingImage.add(File(image.path));
      });
    } catch (err) {
      print(err);
    }
  }

  Future _imgFromGallery() async {
    try {
      var image = await ImagePicker()
          .getImage(source: ImageSource.gallery, imageQuality: 20);

      setState(() {
        uploadingImage.add(File(image.path));
      });
    } catch (err) {
      print(err);
    }
  }

  _formData() async {
    FormData formData = FormData.fromMap({
      "userId": UserController.to.userId.toString(),
      "placeId": data.id,
      "desc": review.toString(),
      "tasteRating": taste.toString(),
      "costRating": cost.toString(),
      "serviceRating": service.toString(),
    });
    for (int i = 0; i < uploadingImage.length; i++) {
      formData.files.add(MapEntry(
        "images",
        MultipartFile.fromFileSync(
          uploadingImage[i].path,
          filename: uploadingImage[i].path.split('/').last,
        ),
      ));
    }

    return formData;
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 1500, height: 2667);

    return Scaffold(
      appBar: appBar(
        context,
        data.name,
        "",
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Container(
            width: double.infinity,
            margin:
                EdgeInsets.only(top: 36 * height.h, bottom: 27.5 * height.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                normalfont("${data.name}", 58, Colors.black),
                normalfont("방문하셨나요?", 58, Color(0xff939393)),
              ],
            ),
          ),
          Divider(
            thickness: 2.h,
          ),

          // 3 stars
          Container(
            height: 207 * height.h,
            width: double.infinity,
            margin: EdgeInsets.only(
                top: 36 * height.sp,
                bottom: 35.7 * height.sp,
                right: 77 * width.sp,
                left: 77 * width.sp),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Padding(padding: EdgeInsets.only(left: 22.w)),
                    Container(
                        width: 82 * width.w,
                        child: normalfont("맛", 58, Colors.black)),

                    Rating(
                      changed: (v) {
                        if (v == 5) {
                          index1 = 0;
                        } else if (v >= 4) {
                          index1 = 1;
                        } else if (v >= 3) {
                          index1 = 2;
                        } else if (v >= 2) {
                          index1 = 3;
                        } else if (v >= 1) {
                          index1 = 4;
                        } else {
                          index1 = 5;
                        }
                        setState(() {
                          taste = v;
                        });
                      },
                    ),

                    Container(
                      width: 160 * width.w,
                      child: normalfont("${ratingLabel[index1]}", 58,
                          index1 == 5 ? Colors.transparent : Colors.black),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Padding(padding: EdgeInsets.only(left: 11.w)),
                    Container(
                      width: 82 * width.w,
                      child: normalfont("가격", 58, Colors.black),
                    ),

                    Rating(
                      changed: (v) {
                        if (v == 5) {
                          index2 = 0;
                        } else if (v >= 4) {
                          index2 = 1;
                        } else if (v >= 3) {
                          index2 = 2;
                        } else if (v >= 2) {
                          index2 = 3;
                        } else if (v >= 1) {
                          index2 = 4;
                        } else {
                          index2 = 5;
                        }
                        setState(() {
                          cost = v;
                        });
                      },
                    ),

                    Container(
                      width: 160 * width.w,
                      child: normalfont("${ratingLabel[index2]}", 58,
                          index1 == 5 ? Colors.transparent : Colors.black),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 82 * width.w,
                      child: normalfont("서비스", 58, Colors.black),
                    ),
                    Rating(
                      changed: (v) {
                        if (v == 5) {
                          index3 = 0;
                        } else if (v >= 4) {
                          index3 = 1;
                        } else if (v >= 3) {
                          index3 = 2;
                        } else if (v >= 2) {
                          index3 = 3;
                        } else if (v >= 1) {
                          index3 = 4;
                        } else {
                          index3 = 5;
                        }
                        setState(() {
                          service = v;
                        });
                      },
                    ),
                    Container(
                      width: 160 * width.w,
                      child: normalfont("${ratingLabel[index3]}", 58,
                          index1 == 5 ? Colors.transparent : Colors.black),
                    )
                  ],
                ),
              ],
            ),
          ),

          // Text input
          Container(
            margin: EdgeInsets.only(
              // top: 25.7.w,
              right: 36 * width.w,
              left: 36 * width.w,
            ),
            padding: EdgeInsets.only(bottom: 15.sp),
            width: double.infinity,
            height: 330 * width.w,
            decoration: BoxDecoration(
              color: Color.fromRGBO(255, 114, 142, 0.05),
              borderRadius: BorderRadius.all(Radius.circular(10)),
              border: Border.all(
                color: Color.fromRGBO(255, 114, 142, 0.4),
              ),
            ),
            child: TextFormField(
              onChanged: (value) {
                setState(() {
                  review = value;
                });
                print(review);
                if (review.length >= 10) {
                  setState(() {
                    btnColor = true;
                  });
                } else {
                  if (btnColor)
                    setState(() {
                      btnColor = false;
                    });
                }
              },
              textAlign: TextAlign.left,
              style: TextStyle(color: Color.fromRGBO(255, 114, 142, 0.6)),
              maxLines: 20,
              maxLength: 1000,
              cursorColor: Color.fromRGBO(255, 114, 142, 0.6),
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: "  최소 10자 이상 리뷰를 작성해주세요.",
                hintStyle: TextStyle(color: Color.fromRGBO(255, 114, 142, 0.6)),
                counterStyle: TextStyle(
                    color: Color.fromRGBO(255, 114, 142, 0.6),
                    fontFamily: "NotoSansCJKkr_Medium"),
                contentPadding:
                    EdgeInsets.only(top: 10.sp, right: 19.sp, left: 19.sp),
              ),
            ),
          ),

          // image upload
          Container(
            margin: EdgeInsets.only(
                top: 20 * height.h, right: 36 * width.w, left: 36 * width.w),
            width: double.infinity,
            height: 130 * width.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () async {
                    FocusScope.of(context).unfocus();
                    _showPicker(context);
                  },
                  child: Image.asset(
                    "assets/reviewPage/camera_button.png",
                  ),
                ),
                Padding(padding: EdgeInsets.only(left: 17 * width.w)),
                Expanded(
                  flex: 1,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount:
                          uploadingImage == null ? 0 : uploadingImage.length,
                      itemBuilder: (context, index) {
                        print(
                            "uploadingImage.length: ${uploadingImage.length}");
                        return Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Stack(
                                children: [
                                  SizedBox(
                                    width: 130 * width.w,
                                    height: 130 * height.w,
                                    child: Image.file(
                                      uploadingImage[index],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      image: DecorationImage(
                                          image: FileImage(
                                              uploadingImage[index]), //imageURL
                                          fit: BoxFit.cover),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  Container(
                                    width: 130 * width.w,
                                    height: 130 * height.w,
                                    color: Colors.grey.withOpacity(0.3),
                                  ),
                                  Positioned(
                                    right: 5 * width,
                                    top: 5 * height,
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          uploadingImage.removeAt(index);
                                        });
                                      },
                                      child: Image.asset(
                                        "assets/reviewPage/x_button.png",
                                        height: 27.3 * width.w,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.only(left: 17 * width.w)),
                          ],
                        );
                      }),
                ),
              ],
            ),
          ),
          //  Bottom button
          Container(
            margin: EdgeInsets.only(
                top: 36 * height.w,
                right: 110 * width.w,
                left: 110 * width.w,
                bottom: 65 * height.w),
            width: double.infinity,
            height: 93 * width.w,
            child: RaisedButton(
              elevation: 0,
              hoverElevation: 0,
              color: btnColor
                  ? Color.fromRGBO(255, 114, 142, 1.0)
                  : Color.fromRGBO(212, 212, 212, 1.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Text(
                "리뷰 남기기",
                style: TextStyle(
                    letterSpacing: -0.75.h,
                    fontSize: 58.sp,
                    fontFamily: "NotoSansCJKkr_Bold",
                    color: Colors.white),
              ),
              onPressed: () async {
                var formdata = await _formData();
                reviewInsert(formdata);
              },
            ),
          )
        ],
      )),
    );
  }
}

class Rating extends StatelessWidget {
  final rateValue;
  final Function changed;
  const Rating({
    Key key,
    this.rateValue,
    this.changed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return SmoothStarRating(
    //     allowHalfRating: true,
    //     onRated: changed,
    //     starCount: 5,
    //     rating: 0,
    //     size: 26.0,
    //     isReadOnly: false,
    //     color: Colors.amber,
    //     borderColor: Colors.amber,
    //     spacing: 0.0);
    return RatingBar(
      initialRating: 0,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      itemSize: 80.w,
      ratingWidget: RatingWidget(
        full: Image.asset(
          'assets/listPage/star_color.png',
          // width: 1.3.h,
        ),
        half: Image.asset(
          'assets/listPage/star_half.png',
          // width: 1.3.h,
        ),
        empty: Image.asset(
          'assets/listPage/star_grey.png',
          // width: 1.3.h,
        ),
      ),
      itemPadding: EdgeInsets.symmetric(horizontal: 3.0),
      onRatingUpdate: changed,
    );
  }
}
