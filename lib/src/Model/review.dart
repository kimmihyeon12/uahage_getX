class Review {
  Review({
    this.id,
    this.user_id,
    this.nickname,
    this.profile,
    this.description,
    this.total_rating,
    this.taste_rating,
    this.cost_rating,
    this.service_rating,
    this.created_at,
    this.image_path,
  });

  int id;
  int user_id;
  String nickname;
  String profile;
  String description;
  int total_rating;
  int taste_rating;
  int cost_rating;
  int service_rating;
  String created_at;
  String image_path;

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json["id"],
      user_id: json["user_id"],
      nickname: json["nickname"],
      profile: json["profile"],
      description: json["description"],
      total_rating: json["total_rating"],
      taste_rating: json["taste_rating"],
      cost_rating: json["cost_rating"],
      service_rating: json["service_rating"],
      created_at: json["created_at"],
      image_path: json["image_path"],
    );
  }
}
