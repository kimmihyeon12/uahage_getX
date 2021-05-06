import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:uahage/src/Controller/image.controller.dart';
import 'package:uahage/src/Controller/place.controller.dart';
import 'package:uahage/src/API/places.dart';
import 'package:uahage/src/View/Nav/HomeSub/listMap.dart';
import '../../../Static/url.dart';

class PlaceList extends GetView<PlaceController> {
  String url = URL;
  int placeCode = Get.arguments;
  ScrollController scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  getList() async {
    Place place = new Place();
    await place.getPlaceList(placeCode);
  }

  var restaurantListImage = [
    "https://uahage.s3.ap-northeast-2.amazonaws.com/restaurant_image/image1.png",
    "https://uahage.s3.ap-northeast-2.amazonaws.com/restaurant_image/image2.png",
    "https://uahage.s3.ap-northeast-2.amazonaws.com/restaurant_image/image3.png",
  ];
  var hospitalListImage = [
    "https://uahage.s3.ap-northeast-2.amazonaws.com/hospital_image/image1.png",
    "https://uahage.s3.ap-northeast-2.amazonaws.com/hospital_image/image2.png",
  ];
  var kidsCafeListImage = [
    "https://uahage.s3.ap-northeast-2.amazonaws.com/kids_cafe/image1.png",
    "https://uahage.s3.ap-northeast-2.amazonaws.com/kids_cafe/image2.png",
  ];
  var experienceListImage = [
    "https://uahage.s3.ap-northeast-2.amazonaws.com/experience_/image1.png",
    "https://uahage.s3.ap-northeast-2.amazonaws.com/experience_/image2.png",
    "https://uahage.s3.ap-northeast-2.amazonaws.com/experience_/image3.png",
    "https://uahage.s3.ap-northeast-2.amazonaws.com/experience_/image4.png",
  ];

  Widget build(BuildContext context) {
    Get.put(PlaceController());
    Get.put(ImageController());
    controller.placeInit();
    getList();
    scrollController.addListener(() {
      double maxScroll = scrollController.position.maxScrollExtent;
      double currentScroll = scrollController.position.pixels;
      if (currentScroll == maxScroll) {
        getList();
      }
    });

    ScreenUtil.init(context, width: 1500, height: 2667);
    ImageController.to.indexcountState(0);
    return SafeArea(
      child: Obx(
        () => Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.white,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    highlightColor: Colors.white,
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        Image.asset(
                          "./assets/listPage/backbutton.png",
                          width: 44.w,
                          height: 76.h,
                        ),
                        Padding(
                            padding: EdgeInsets.only(
                          left: 45.w,
                        )),
                        Container(
                          child: Text(
                            (() {
                              if (placeCode == 1) {
                                return "식당·카페";
                              } else if (placeCode == 2) {
                                return "병원";
                              } else if (placeCode == 5) {
                                return "키즈카페";
                              } else {
                                return "체험관";
                              }
                            }()),
                            style: TextStyle(
                                fontSize: 62.sp,
                                fontFamily: 'NotoSansCJKkr_Medium',
                                color: Color.fromRGBO(255, 114, 148, 1.0)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 30.w),
                    child: ImageController.to.indexcount.value == 1
                        ? GestureDetector(
                            onTap: () {
                              ImageController.to.indexcountState(0);
                            },
                            child: Image.asset(
                              './assets/on.png',
                              width: 284.w,
                              height: 133.h,
                            ),
                          )
                        : GestureDetector(
                            onTap: () {
                              ImageController.to.indexcountState(1);
                            },
                            child: Image.asset(
                              './assets/off.png',
                              width: 284.w,
                              height: 133.h,
                            ),
                          ),
                  ),
                ],
              ),
            ),
            body: IndexedStack(
                index: ImageController.to.indexcount.value,
                children: <Widget>[
                  ListViews(),
                  ListMap(),
                ])),
      ),
    );
  }

  ListViews() {
    return ListView.builder(
        controller: scrollController,
        itemCount: controller.place.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Card(
            elevation: 0.3,
            child: Container(
                height: 450.h,
                padding: EdgeInsets.only(
                  top: 1.h,
                  left: 26.w,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      highlightColor: Colors.white,
                      onTap: () async {
                        // var result = await Navigator.push(
                        //     context,
                        //     PageTransition(
                        //       type: PageTransitionType.rightToLeft,
                        //       child: SubListPage(
                        //         index: index,
                        //         data: snapshot.data[index],
                        //         userId: userId,
                        //         tableType: tableType,
                        //       ),
                        //       duration: Duration(milliseconds: 250),
                        //       reverseDuration:
                        //           Duration(milliseconds: 100),
                        //     ));
                        // setState(() {
                        //   snapshot.data[index].bookmark =
                        //       int.parse(result);
                        // });
                      },
                      child: Container(
                        width: 1280.w,
                        //     color:Colors.pink,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  // border: Border.all(width: 3.0),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      (() {
                                        if (placeCode == 1) {
                                          if (index % 3 == 1)
                                            return restaurantListImage[0];
                                          else if (index % 3 == 2)
                                            return restaurantListImage[1];
                                          else
                                            return restaurantListImage[2];
                                        } else if (placeCode == 2) {
                                          if (index % 2 == 1)
                                            return hospitalListImage[0];
                                          else
                                            return hospitalListImage[1];
                                        } else if (placeCode == 6) {
                                          if (index % 4 == 1)
                                            return experienceListImage[0];
                                          else if (index % 4 == 2)
                                            return experienceListImage[1];
                                          else if (index % 4 == 3)
                                            return experienceListImage[2];
                                          else
                                            return experienceListImage[3];
                                        } else {
                                          if (index % 2 == 1)
                                            return kidsCafeListImage[0];
                                          else
                                            return kidsCafeListImage[1];
                                        }
                                      }()),
                                    ),
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0))),
                              height: 414.h,
                              width: 413.w,
                            ),
                            Padding(
                                padding: EdgeInsets.only(
                              left: 53.w,
                            )),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(padding: EdgeInsets.only(top: 10.h)),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(top: 20.h),
                                      width: 700.w,
                                      height: 82.h,
                                      child: Text(
                                        controller.place[index].name,
                                        style: TextStyle(
                                          fontSize: 56.sp,
                                          fontFamily: 'NotoSansCJKkr_Medium',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  height: 135.h,
                                  width: 650.w,
                                  child: Text(
                                    controller.place[index].address,
                                    style: TextStyle(
                                      // fontFamily: 'NatoSans',
                                      color: Colors.grey,
                                      fontSize: 56.sp,
                                      fontFamily: 'NotoSansCJKkr_Medium',
                                      height: 1.3,
                                    ),
                                  ),
                                ),
                                placeCode == 1
                                    ? Container(
                                        margin: EdgeInsets.only(top: 15.h),
                                        height: 120.h,
                                        width: 650.w,
                                        alignment: Alignment.bottomRight,
                                        child: Row(
                                          children: [
                                            // icon.chair(
                                            //     snapshot
                                            //         .data[index].chair,
                                            //     context),
                                            // icon.carriage(
                                            //     snapshot.data[index]
                                            //         .carriage,
                                            //     context),
                                            // icon.menu(
                                            //     snapshot
                                            //         .data[index].menu,
                                            //     context),
                                            // icon.bed(
                                            //     snapshot
                                            //         .data[index].bed,
                                            //     context),
                                            // icon.tableware(
                                            //     snapshot.data[index]
                                            //         .tableware,
                                            //     context),
                                            // icon.meetingroom(
                                            //     snapshot.data[index]
                                            //         .meetingroom,
                                            //     context),
                                            // icon.diapers(
                                            //     snapshot.data[index]
                                            //         .diapers,
                                            //     context),
                                            // icon.playroom(
                                            //     snapshot.data[index]
                                            //         .playroom,
                                            //     context),
                                            // icon.nursingroom(
                                            //     snapshot.data[index]
                                            //         .nursingroom,
                                            //     context),
                                          ],
                                        ),
                                      )
                                    : Container()
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Container(
                    //   margin: EdgeInsets.only(left: 30.w, top: 25.h),

                    //   //         color:Colors.yellow,
                    //   child: IconButton(
                    //     padding: EdgeInsets.all(0),
                    //     constraints: BoxConstraints(
                    //       maxWidth: 70.w,
                    //       maxHeight: 70.h,
                    //     ),
                    //     // icon: Image.asset(
                    //     //   snapshot.data[index].bookmark == 0
                    //     //       ? "./assets/listPage/star_grey.png"
                    //     //       : "./assets/listPage/star_color.png",
                    //     //   height: 60.h,
                    //     // ),
                    //     onPressed: () async {
                    //       // setState(() {
                    //       //   print(snapshot.data[index].id);
                    //       //   place_id = snapshot.data[index].id;
                    //       // });
                    //       // if (snapshot.data[index].bookmark == 0) {
                    //       //   bookMark.bookmarkCreate(userId, place_id);
                    //       //   snapshot.data[index].bookmark = 1;
                    //       // } else {
                    //       //   bookMark.bookmarkDelete(userId, place_id);
                    //       //   snapshot.data[index].bookmark = 0;
                    //       // }
                    //     },
                    //   ),
                    // ),
                  ],
                )),
          );
        });
  }
}
