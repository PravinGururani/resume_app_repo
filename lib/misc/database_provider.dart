import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:resume/model/academic_details.dart';
import 'package:resume/model/achievements.dart';
import 'package:resume/model/personal_details.dart';
import 'package:resume/model/project_details.dart';
import 'package:resume/model/resume.dart';
import 'package:resume/model/skills.dart';
import 'package:resume/model/work_experience.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider{
  DatabaseProvider._();

  static final DatabaseProvider db= DatabaseProvider._();
  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await getDatabaseInstance();
    return _database;
  }

  Future<Database> getDatabaseInstance() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "resume.db");
    return await openDatabase(path, version: 1,
    onCreate: (db, version) => _createDb(db)
    );
  }

  void _createDb(Database db) {
    db.execute("CREATE TABLE PERSONALDETAILS ("
        "id INTEGER primary key AUTOINCREMENT,"
        "name TEXT,"
        "jobTitle TEXT,"
        "professionalSummary TEXT,"
        "email TEXT,"
        "phone INTEGER,"
        "address TEXT,"
        "resumeId INTEGER,"
        "image TEXT"
        ")"
    );

    db.execute("CREATE TABLE PROJECTDETAILS ("
        "id INTEGER primary key AUTOINCREMENT,"
        "projectName TEXT,"
        "clientName TEXT,"
        "startDate TEXT,"
        "endDate TEXT,"
        "role TEXT,"
        "description TEXT,"
        "techStack TEXT,"
        "teamSize INTEGER,"
        "resumeId INTEGER"
        ")"
    );

    db.execute("CREATE TABLE ACADEMICDETAILS ("
        "id INTEGER primary key AUTOINCREMENT,"
        "course TEXT,"
        "university TEXT,"
        "yearOfPassing INTEGER,"
        "isGraduated INTEGER,"
        "percentage INTEGER,"
        "resumeId INTEGER"
        ")"
    );

    db.execute("CREATE TABLE ACHIEVEMENTS ("
        "id INTEGER primary key AUTOINCREMENT,"
        "achievement TEXT,"
        "year INTEGER,"
        "resumeId INTEGER"
        ")"
    );

    db.execute("CREATE TABLE WORKEXPERIENCE ("
        "id INTEGER primary key AUTOINCREMENT,"
        "companyName TEXT,"
        "jobTitle TEXT,"
        "startDate TEXT,"
        "endDate TEXT,"
        "details TEXT,"
        "resumeId INTEGER"
        ")"
    );
    db.execute("CREATE TABLE SKILLS ("
        "id INTEGER primary key AUTOINCREMENT,"
        "name TEXT,"
        "resumeId INTEGER"
        ")"
    );
    db.execute("CREATE TABLE RESUME ("
        "id INTEGER primary key AUTOINCREMENT,"
        "name TEXT UNIQUE,"
        "personName TEXT,"
        "image TEXT"
        ")"
    );
  }


  Future<int> insertResume(Resume newResume) async {
    final db = await database;
    int insertedId=await db.insert(
      'RESUME',
      newResume.toMap(),
    );
    print("INSERT INTO RESUME SUCCESSFUL with ID : $insertedId");
    return insertedId;
  }

  Future<Resume> getResume(int resumeId) async {
    final db = await database;
    Resume resume;
    var response = await db.query("RESUME",
        where: 'id=?',
        whereArgs: [resumeId]);
    if(response.isNotEmpty){
      resume = Resume.fromMap(response.first);
    }
    return resume;
  }

  Future<void> updateResume(Resume resume) async {
    final db = await database;
    await db.update(
      'RESUME',
      resume.toMap(),
      where: 'id=?',
      whereArgs: [resume.id],
    );
    print('${resume.personName},${resume.image}');
  }

  Future<void> addUpdatePersonalDetails(PersonalDetails personalDetails) async {
    final db = await database;
    if(personalDetails.id==null){
      await db.insert(
        'PERSONALDETAILS',
        personalDetails.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    else{
      await db.update(
        'PERSONALDETAILS',
        personalDetails.toMap(),
        where: 'id=?',
        whereArgs: [personalDetails.id],
      );
    }
    print(personalDetails.id);
    print("INSERT INTO PERSONAL DETAILS SUCCESSFUL");
  }

  Future<void> addUpdateWorkExperience(WorkExperience workExperience) async {
    final db = await database;
    if(workExperience.id==null){
      await db.insert(
        'WORKEXPERIENCE',
        workExperience.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    else{
      await db.update(
        'WORKEXPERIENCE',
        workExperience.toMap(),
        where: 'id=?',
        whereArgs: [workExperience.id],
      );
    }
    print(workExperience.id);
    print("INSERT INTO PERSONAL DETAILS SUCCESSFUL");
  }

  Future<void> addUpdateProjectDetails(ProjectDetails projectDetails) async {
    final db = await database;
    if(projectDetails.id==null){
      await db.insert(
        'PROJECTDETAILS',
        projectDetails.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    else{
      await db.update(
        'PROJECTDETAILS',
        projectDetails.toMap(),
        where: 'id=?',
        whereArgs: [projectDetails.id],
      );
    }
    print(projectDetails.id);
    print("INSERT INTO PROJECT DETAILS SUCCESSFUL");
  }

  Future<void> addUpdateAcademicDetails(AcademicDetails academicDetails) async {
    final db = await database;
    if(academicDetails.id==null){
      await db.insert(
        'ACADEMICDETAILS',
        academicDetails.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    else{
      await db.update(
        'ACADEMICDETAILS',
        academicDetails.toMap(),
        where: 'id=?',
        whereArgs: [academicDetails.id],
      );
    }
    print(academicDetails.id);
    print("INSERT INTO ACADEMIC DETAILS SUCCESSFUL");
  }

  Future<void> addUpdateAchievements(Achievements achievements) async {
    final db = await database;
    if(achievements.id==null){
      await db.insert(
        'ACHIEVEMENTS',
        achievements.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    else{
      await db.update(
        'ACHIEVEMENTS',
        achievements.toMap(),
        where: 'id=?',
        whereArgs: [achievements.id],
      );
    }
    print(achievements.id);
    print("INSERT INTO ACHIEVEMENTS SUCCESSFUL");
  }

  Future<void> insertSkills(Skills skills) async {
    // Get a reference to the database.
    final db = await database;

    // Insert the Dog into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert(
      'SKILLS',
      skills.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    // getAllPersonalDetails().then((value) {
    //   print("BEFORE ASYNC METHOD CALL");
    //   for(int i=0; i<value.length;i++){
    //     print(value[i].name);
    //   }
    // });
    print("INSERT SUCCESSFUL");
  }

  Future<PersonalDetails> getPersonalDetails(int resumeId) async {
    final db = await database;
    PersonalDetails personalDetails;
    var response = await db.query("PERSONALDETAILS",
        where: 'resumeId=?',
        whereArgs: [resumeId]);
    if(response.isNotEmpty){
      personalDetails = PersonalDetails.fromMap(response.first);
    }
    return personalDetails;
  }

  Future<List<WorkExperience>> getAllWorkExperience(int resumeId) async {
    final db = await database;
    var response = await db.query("WORKEXPERIENCE",
    where: 'resumeId=?',
    whereArgs: [resumeId]);
    List<WorkExperience> list = response.map((c) => WorkExperience.fromMap(c)).toList();
    print(list);
    return list;
  }

  Future<List<ProjectDetails>> getAllProjectDetails(int resumeId) async {
    final db = await database;
    var response = await db.query("PROJECTDETAILS",
        where: 'resumeId=?',
        whereArgs: [resumeId]);
    List<ProjectDetails> list = response.map((c) => ProjectDetails.fromMap(c)).toList();
    print(list);
    return list;
  }

  Future<List<Achievements>> getAllAchievements(int resumeId) async {
    final db = await database;
    var response = await db.query("ACHIEVEMENTS",
        where: 'resumeId=?',
        whereArgs: [resumeId]);
    List<Achievements> list = response.map((c) => Achievements.fromMap(c)).toList();
    print(list);
    return list;
  }

  Future<List<AcademicDetails>> getAllAcademicDetails(int resumeId) async {
    final db = await database;
    var response = await db.query("ACADEMICDETAILS",
        where: 'resumeId=?',
        whereArgs: [resumeId]);
    List<AcademicDetails> list = response.map((c) => AcademicDetails.fromMap(c)).toList();
    print(list);
    return list;
  }

  Future<List<Resume>> getAllResumes() async {
    final db = await database;
    var response = await db.query("RESUME",);
    List<Resume> list = response.map((c) => Resume.fromMap(c)).toList();
    return list;
  }


  Future<List<Skills>> getAllSkills(int resumeId) async {
    final db = await database;
    var response = await db.query("SKILLS",
        where: 'resumeId=?',
        whereArgs: [resumeId]);
    List<Skills> list = response.map((c) => Skills.fromMap(c)).toList();
    return list;
  }

  Future<void> deleteWorkExperienceById(int id) async {
    final db = await database;
    await db.delete(
      'WORKEXPERIENCE',
      where: "id = ?",
      whereArgs: [id],
    );
    print("Entry with ID $id is deleted");
  }

  Future<void> deleteProjectDetailsById(int id) async {
    final db = await database;
    await db.delete(
      'PROJECTDETAILS',
      where: "id = ?",
      whereArgs: [id],
    );
    print("Entry with ID $id is deleted");
  }

  Future<void> deleteAcademicDetailsById(int id) async {
    final db = await database;
    await db.delete(
      'ACADEMICDETAILS',
      where: "id = ?",
      whereArgs: [id],
    );
    print("Entry with ID $id is deleted");
  }

  Future<void> deleteAchievementsById(int id) async {
    final db = await database;
    await db.delete(
      'ACHIEVEMENTS',
      where: "id = ?",
      whereArgs: [id],
    );
    print("Entry with ID $id is deleted");
  }
  Future<void> deleteSkillById(int id) async {
    final db = await database;
    await db.delete(
      'SKILLS',
      where: "id = ?",
      whereArgs: [id],
    );
    print("Entry with ID $id is deleted");
  }

  Future<void> deleteResumeById(int id) async {
    final db = await database;
    await db.delete(
      'PERSONALDETAILS',
      where: "resumeId = ?",
      whereArgs: [id],
    );
    await db.delete(
      'SKILLS',
      where: "resumeId = ?",
      whereArgs: [id],
    );
    await db.delete(
      'WORKEXPERIENCE',
      where: "resumeId = ?",
      whereArgs: [id],
    );
    await db.delete(
      'PROJECTDETAILS',
      where: "resumeId = ?",
      whereArgs: [id],
    );
    await db.delete(
      'ACADEMICDETAILS',
      where: "resumeId = ?",
      whereArgs: [id],
    );
    await db.delete(
      'ACHIEVEMENTS',
      where: "resumeId = ?",
      whereArgs: [id],
    );
    await db.delete(
      'RESUME',
      where: "id = ?",
      whereArgs: [id],
    );

  }


}