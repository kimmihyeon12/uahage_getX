import 'package:dio/dio.dart';
import 'package:uahage/src/Controller/user.controller.dart';

suggestionFormData(placeId, placeCategoryId, text, uploadingImage) async {
  FormData formData = FormData.fromMap({
    "userId": UserController.to.userId.toString(),
    "placeCategoryId": placeCategoryId,
    "placeId": placeId,
    "desc": text,
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
