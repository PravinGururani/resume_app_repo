import 'package:resume/model/work_experience.dart';

import 'personal_details.dart';
import 'skills.dart';

class Resume {
  Resume({
    this.id,
    this.name,
    this.personName,
    this.image,
    //this.personalDetails,
    /*this.skills,
    this.workExperience,*/
  });

  int id;
  String name;
  String personName;
  String image;
  //PersonalDetails personalDetails;
  /*List<Skills> skills;
  List<WorkExperience> workExperience;*/

  factory Resume.fromMap(Map<String, dynamic> json) => Resume(
    id: json["id"],
    name: json["name"],
    personName: json["personName"],
    image: json["image"],

    //personalDetails: PersonalDetails.fromMap(json["personalDetails"]),
    /*skills: List<Skills>.from(json["skills"].map((x) => Skills.fromMap(x))),
    workExperience: List<WorkExperience>.from(json["workExperience"].map((x) => WorkExperience.fromMap(x))),*/
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "personName":personName,
    "image":image,
    //"personalDetails": personalDetails.toMap(),
    /*"skills": List<dynamic>.from(skills.map((x) => x.toMap())),
    "workExperience": List<dynamic>.from(workExperience.map((x) => x.toMap())),*/
  };
}