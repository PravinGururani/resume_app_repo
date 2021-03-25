import 'dart:convert';

class PersonalDetails {
  PersonalDetails({
    this.id,
    this.name,
    this.jobTitle,
    this.professionalSummary,
    this.email,
    this.phone,
    this.address,
    this.resumeId,
    this.image
  });

  int id;
  String name;
  String jobTitle;
  String professionalSummary;
  String email;
  int phone;
  String address;
  int resumeId;
  String image;

  factory PersonalDetails.fromMap(Map<String, dynamic> json) => PersonalDetails(
    id: json["id"],
    name: json["name"],
    jobTitle: json["jobTitle"],
    email: json["email"],
    phone: json["phone"],
    professionalSummary: json["professionalSummary"],
    address: json["address"],
    resumeId: json["resumeId"],
    image: json["image"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "jobTitle": jobTitle,
    "professionalSummary": professionalSummary,
    "email": email,
    "phone": phone,
    "address": address,
    "resumeId": resumeId,
    "image":image,
  };
}
