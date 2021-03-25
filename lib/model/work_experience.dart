class WorkExperience {
  WorkExperience({
    this.id,
    this.companyName,
    this.jobTitle,
    this.startDate,
    this.endDate,
    this.details,
    this.resumeId,
  });

  int id;
  String companyName;
  String jobTitle;
  String startDate;
  String endDate;
  String details;
  int resumeId;

  factory WorkExperience.fromMap(Map<String, dynamic> json) => WorkExperience(
    id: json["id"],
    companyName: json["companyName"],
    jobTitle: json["jobTitle"],
    startDate: json["startDate"],
    endDate: json["endDate"],
    details: json["details"],
    resumeId: json["resumeId"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "companyName": companyName,
    "jobTitle": jobTitle,
    "startDate": startDate,
    "endDate": endDate,
    "details": details,
    "resumeId": resumeId,
  };
}
