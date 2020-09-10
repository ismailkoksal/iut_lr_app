import 'dart:convert';

List<Course> courseFromJson(String str) =>
    List<Course>.from(json.decode(str).map((x) => Course.fromJson(x)));

String courseToJson(List<Course> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Course {
  String uid;
  Description description;
  String summary;
  String location;
  DateTime dtstart;
  DateTime dtend;

  Course({
    this.uid,
    this.description,
    this.summary,
    this.location,
    this.dtstart,
    this.dtend,
  });

  factory Course.fromJson(Map<String, dynamic> json) => Course(
        uid: json["uid"],
        description: Description.fromJson(json["description"]),
        summary: json["summary"],
        location: json["location"],
        dtstart: DateTime.parse(json["dtstart"]),
        dtend: DateTime.parse(json["dtend"]),
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "description": description.toJson(),
        "summary": summary,
        "location": location,
        "dtstart": dtstart.toIso8601String(),
        "dtend": dtend.toIso8601String(),
      };
}

class Description {
  String salle;
  String prof;
  String spe;

  Description({
    this.salle,
    this.prof,
    this.spe,
  });

  factory Description.fromJson(Map<String, dynamic> json) => Description(
        salle: json["Salle"],
        prof: json["Prof"],
        spe: json["Spe"],
      );

  Map<String, dynamic> toJson() => {
        "Salle": salle,
        "Prof": prof,
        "Spe": spe,
      };
}
