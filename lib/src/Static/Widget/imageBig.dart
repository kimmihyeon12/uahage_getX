import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
