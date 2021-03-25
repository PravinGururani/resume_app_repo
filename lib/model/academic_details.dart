class AcademicDetails {
  AcademicDetails({
    this.id,
    this.course,
    this.university,
    this.yearOfPassing,
    this.isGraduated,
    this.percentage,
    this.resumeId,
  });

  int id;
  String course;
  String university;
  int yearOfPassing;
  int isGraduated;
  double percentage;
  int resumeId;

  factory AcademicDetails.fromMap(Map<String, dynamic> json) => AcademicDetails(
    id: json["id"],
    course: json["course"],
    university: json["university"],
    yearOfPassing: json["yearOfPassing"],
    isGraduated: json["isGraduated"],
    percentage: json["percentage"].toDouble(),
    resumeId: json["resumeId"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "course": course,
    "university": university,
    "yearOfPassing": yearOfPassing,
    "isGraduated": isGraduated,
    "percentage": percentage,
    "resumeId": resumeId,
  };
}