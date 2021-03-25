class Skills {
  Skills({
    this.id,
    this.name,
    this.resumeId
  });

  int id;
  String name;
  int resumeId;

  factory Skills.fromMap(Map<String, dynamic> json) => Skills(
    id: json["id"],
    name: json["name"],
    resumeId: json["resumeId"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "resumeId":resumeId,
  };
}