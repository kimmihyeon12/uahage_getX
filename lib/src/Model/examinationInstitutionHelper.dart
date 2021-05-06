class Examinationinstitution {
  Examinationinstitution(
      {this.id,
      this.name,
      this.address,
      this.phone,
      this.examination,
      this.bookmark});
  int id;
  String name;
  String address;
  String phone;
  String examination;
  int bookmark;

  factory Examinationinstitution.fromJson(Map<String, dynamic> json) =>
      Examinationinstitution(
          id: json["id"],
          name: json["name"],
          address: json["address"],
          phone: json["phone"],
          examination: json["examination"],
          bookmark: json["bookmark"]);
}
