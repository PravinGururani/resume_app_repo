class Achievements {
  Achievements({
    this.id,
    this.achievement,
    this.year,
    this.resumeId,
  });

  int id;
  String achievement;
  int year;
  int resumeId;

  factory Achievements.fromMap(Map<String, dynamic> json) => Achievements(
    id: json["id"],
    achievement: json["achievement"],
    year: json["year"],
    resumeId: json["resumeId"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "achievement": achievement,
    "year": year,
    "resumeId": resumeId,
  };
}