class Review {
  Review({
    this.id,
    this.desc,
    this.totalRating,
    this.tasteRating,
    this.costRating,
    this.serviceRating,
    this.updatedAt,
    this.user,
    this.images,
  });

  int id;
  String desc;
  double totalRating;
  double tasteRating;
  double costRating;
  double serviceRating;
  String updatedAt;
  var user;
  var images;

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json["id"],
      desc: json["desc"],
      totalRating: json["totalRating"],
      tasteRating: json["tasteRating"],
      costRating: json["costRating"],
      serviceRating: json["serviceRating"],
      updatedAt: json["updatedAt"],
      user: json["user"],
      images: json["images"],
    );
  }
}
