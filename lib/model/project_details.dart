class ProjectDetails {
  ProjectDetails({
    this.id,
    this.projectName,
    this.clientName,
    this.startDate,
    this.endDate,
    this.role,
    this.description,
    this.techStack,
    this.teamSize,
    this.resumeId,
  });

  int id;
  String projectName;
  String clientName;
  String startDate;
  String endDate;
  String role;
  String description;
  String techStack;
  int teamSize;
  int resumeId;

  factory ProjectDetails.fromMap(Map<String, dynamic> json) => ProjectDetails(
    id: json["id"],
    projectName: json["projectName"],
    clientName: json["clientName"],
    startDate: json["startDate"],
    endDate: json["endDate"],
    role: json["role"],
    description: json["description"],
    techStack: json["techStack"],
    teamSize: json["teamSize"],
    resumeId: json["resumeId"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "projectName": projectName,
    "clientName": clientName,
    "startDate": startDate,
    "endDate": endDate,
    "role": role,
    "description": description,
    "techStack": techStack,
    "teamSize": teamSize,
    "resumeId": resumeId,
  };
}