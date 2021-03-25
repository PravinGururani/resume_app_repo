import 'package:resume/misc/database_provider.dart';
import 'package:resume/model/resume_data.dart';


Future<ResumeData> getFullResumeData(int resumeId) async {
  ResumeData resumeData=new ResumeData();
  resumeData.resumeId=resumeId;
  await DatabaseProvider.db.getPersonalDetails(resumeData.resumeId).then((value) {
    resumeData.personalDetails=value;
  });
  await DatabaseProvider.db.getAllSkills(resumeData.resumeId).then((value) {
    resumeData.skills=value;
  });
  await DatabaseProvider.db.getAllWorkExperience(resumeData.resumeId).then((value) {
    resumeData.workExperience=value;
  });
  await DatabaseProvider.db.getAllProjectDetails(resumeData.resumeId).then((value) {
    resumeData.projectDetails=value;
  });
  await DatabaseProvider.db.getAllAcademicDetails(resumeData.resumeId).then((value) {
    resumeData.academicdetails=value;
  });
  await DatabaseProvider.db.getAllAchievements(resumeData.resumeId).then((value) {
    resumeData.achievements=value;
  });
  return resumeData;
}