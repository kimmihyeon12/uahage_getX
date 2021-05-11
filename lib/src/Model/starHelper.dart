class StarList {
  StarList({
    this.id,
    this.place_code,
    this.name,
    this.address,
    this.phone,
    this.menu,
    this.bed,
    this.tableware,
    this.meetingroom,
    this.diapers,
    this.playroom,
    this.carriage,
    this.nursingroom,
    this.chair,
    this.fare,
    this.examination,
  });

  final int id;
  final int place_code;
  final String name;
  final String address;
  final String phone;
  final String menu;
  final String bed;
  final String tableware;
  final String meetingroom;
  final String diapers;
  final String playroom;
  final String carriage;
  final String nursingroom;
  final String chair;
  final String fare;
  final String examination;

  factory StarList.fromJson(Map<String, dynamic> json) {
    return StarList(
        id: json["id"],
        place_code: json["place_code"],
        name: json["name"],
        address: json["address"],
        phone: json["phone"],
        menu: json["menu"],
        bed: json["bed"],
        tableware: json["tableware"],
        meetingroom: json["meetingroom"],
        diapers: json["diapers"],
        playroom: json["playroom"],
        carriage: json["carriage"],
        nursingroom: json["nursingroom"],
        chair: json["chair"],
        fare: json["fare"],
        examination: json["examination"]);
  }
}
