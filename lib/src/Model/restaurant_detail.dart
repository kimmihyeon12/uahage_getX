class RestaurantDetail {
  RestaurantDetail(
      {this.id,
      this.name,
      this.address,
      this.phone,
      this.categoryId,
      this.isBookmarked,
      this.info,
      this.reviewTotal,
      this.facility,
      this.menu,
      this.images});

  int id;
  String name;
  String address;
  String phone;
  int categoryId;
  bool isBookmarked;
  double reviewTotal;
  var facility;
  var images;
  var info;
  var menu;

  factory RestaurantDetail.fromJson(Map<String, dynamic> json) {
    return RestaurantDetail(
      id: json["id"],
      name: json["name"],
      address: json["address"],
      phone: json["phone"],
      categoryId: json["categoryId"],
      isBookmarked: json["isBookmarked"],
      reviewTotal: json["reviewTotal"],
      facility: json["facility"],
      images: json["images"],
      info: json["info"],
      menu: json["menu"],
    );
  }
}
