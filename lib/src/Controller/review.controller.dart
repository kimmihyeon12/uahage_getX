import 'package:get/get.dart';
import 'package:uahage/src/Model/restaurant.dart';
import 'package:uahage/src/Model/review.dart';

class ReviewController extends GetxService {
  static ReviewController get to => Get.find();

  RxList review = <Review>[].obs;
  setReview(value) {
    review.add(value);
  }

  reviewInit() {
    review(<Review>[]);
  }
}
