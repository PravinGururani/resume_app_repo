import 'package:resume/model/academic_details.dart';
import 'package:resume/model/achievements.dart';
import 'package:resume/model/personal_details.dart';
import 'package:resume/model/project_details.dart';
import 'package:resume/model/skills.dart';
import 'package:resume/model/work_experience.dart';

class ResumeData{
  int resumeId;
  PersonalDetails personalDetails;
  List<Skills> skills;
  List<WorkExperience> workExperience;
  List<ProjectDetails> projectDetails;
  List<AcademicDetails> academicdetails;
  List<Achievements> achievements;

  ResumeData({this.resumeId,
    this.personalDetails,
    this.skills,
    this.workExperience,
    this.projectDetails,
    this.academicdetails,
    this.achievements});
}