class Restaurant {
  Restaurant(
      {this.id,
      this.name,
      this.address,
      this.phone,
      this.categoryId,
      this.isBookmarked,
      this.reviewTotal,
      this.facility,
      this.image});

  int id;
  String name;
  String address;
  String phone;
  int categoryId;
  bool isBookmarked;
  double reviewTotal;
  var facility;
  var image;

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json["id"],
      name: json["name"],
      address: json["address"],
      phone: json["phone"],
      categoryId: json["categoryId"],
      isBookmarked: json["isBookmarked"],
      reviewTotal: json["reviewTotal"],
      facility: json["facility"],
      image: json["image"],
    );
  }
}
