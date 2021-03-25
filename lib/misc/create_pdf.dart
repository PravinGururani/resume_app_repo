import 'dart:io';
import 'package:flutter/material.dart' as material;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:image/image.dart' as ImageLibrary;
import 'package:permission_handler/permission_handler.dart';
import 'package:resume/model/academic_details.dart';
import 'package:resume/model/project_details.dart';
import 'package:resume/model/resume_data.dart';
import 'package:resume/model/work_experience.dart';
import 'package:resume/pdf_viewer_page.dart';
import 'dart:convert';

Future<String> createFolder(String cow) async {
  final folderName = cow;
  final path = Directory("storage/emulated/0/$folderName");
  var status = await Permission.storage.status;
  if (!status.isGranted) {
    await Permission.storage.request();
  }
  if ((await path.exists())) {
    return path.path;
  } else {
    path.create();
    print(path.path);
    return path.path;
  }
}

getPdf(ResumeData resume, int resumeId, material.BuildContext context) async {
  final Document pdf = Document();
  //final img = ImageLibrary.decodeImage(File("${resume.personalDetails.image}").readAsBytesSync());
  /*final image = PdfImage(
    pdf.document,
    image: img.data.buffer.asUint8List(),
    width: img.width,
    height: img.height,
  );*/

  final pageWidth = 21.0 * PdfPageFormat.cm;
  final pageHeight = 29.7 * PdfPageFormat.cm;

  getDivider() => Container(color: PdfColors.black, margin: EdgeInsets.all(8), height: 1, width: pageWidth);

  getExperienceItem(Context context, WorkExperience experience) => Padding(
      padding: EdgeInsets.only(left: 8, right: 8, bottom: 8),
      child: Column(children: <Widget>[
        UrlLink(
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(
                '${experience.companyName}',
                style: Theme.of(context).header5.copyWith(color: PdfColors.blue),
              ),
            ),
            destination: experience.companyName),
        SizedBox(height: 1),
        Row(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              child: Text(experience.jobTitle, style: Theme.of(context).paragraphStyle),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                  '${DateFormat.yMMM().format(DateTime.parse(experience.startDate))} - ${DateTime.parse(experience.endDate).difference(DateTime.now()).inDays == 0 ? 'Present': DateFormat.yMMM().format(DateTime.parse(experience.endDate))}',
                  style: Theme.of(context).paragraphStyle),
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        ),
        SizedBox(height: 1),
        Container(
          alignment: Alignment.centerLeft,
          child: Text(
            '${experience.details}',
            style: Theme.of(context).tableCell,
            textAlign: TextAlign.justify,
          ),
        ),
      ],),);

  List<Widget> _buildExperienceList(Context context) {
    List<Widget> experienceWidgetList = List();
    resume.workExperience.forEach((item) {
      experienceWidgetList.add( getExperienceItem(context, item));
    });

    experienceWidgetList.insert(
      0,
      Container(
        alignment: Alignment.centerLeft,
        child: Text('Experience', style: Theme.of(context).header3),
      ),
    );

    experienceWidgetList.insert(
      1,
      getDivider(),
    );

    return experienceWidgetList;
  }

  getExperience(Context context) => Column(children: _buildExperienceList(context));

  getEducationItem(Context context, AcademicDetails
  education) => Padding(
      padding: EdgeInsets.only(left: 8, right: 8, bottom: 8),
      child: Column(children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                '${education.course}',
                style: Theme.of(context).header5,
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                '${education.yearOfPassing}',
                style: Theme.of(context).paragraphStyle,
              ),
            ),
          ]
        ),
        SizedBox(height: 1),
        UrlLink(
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(
                '${education.university
                }',
                style: Theme.of(context).header5.copyWith(color: PdfColors.blue),
              ),
            ),
            destination: education.university),
        SizedBox(height: 1),
      ]));

  List<Widget> _buildEducationList(Context context) {
    List<Widget> widgetList = List();
    resume.academicdetails.forEach((item) {
      widgetList.add(getEducationItem(context, item));
    });

    widgetList.insert(
      0,
      Container(
        alignment: Alignment.centerLeft,
        child: Text('Education', style: Theme.of(context).header3),
      ),
    );

    widgetList.insert(
      1,
      getDivider(),
    );

    return widgetList;
  }

  getEducation(Context context) => Column(children: _buildEducationList(context));

  getProjectItem(Context context, ProjectDetails project) => Padding(
      padding: EdgeInsets.only(left: 8, right: 8, bottom: 8),
      child: Column(children: <Widget>[
        UrlLink(
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(
                project.projectName,
                style: Theme.of(context).header5.copyWith(color: PdfColors.blue),
              ),
            ),
            destination: project.projectName),
        SizedBox(height: 1),
        Container(
          alignment: Alignment.centerLeft,
          child: Text(
            '${DateFormat.yMMM().format(DateTime.parse(project.startDate))} - ${DateTime.parse(project.endDate).difference(DateTime.now()).inDays == 0 ? 'Present': DateFormat.yMMM().format(DateTime.parse(project.endDate))}',
            style: Theme.of(context).paragraphStyle,
          ),
        ),
        SizedBox(height: 1),
        Container(
          alignment: Alignment.centerLeft,
          child: Text(
            project.description,
            textAlign: TextAlign.justify,
            style: Theme.of(context).tableCell,
          ),
        ),
      ]));

  List<Widget> _buildProjectList(Context context) {
    List<Widget> widgetList = List();
    resume.projectDetails.forEach((item) {
      widgetList.add(getProjectItem(context, item));
    });

    widgetList.insert(
      0,
      Container(
        alignment: Alignment.centerLeft,
        child: Text('Project', style: Theme.of(context).header3),
      ),
    );

    widgetList.insert(
      1,
      getDivider(),
    );

    return widgetList;
  }

  getProjects(Context context) => Column(children: _buildProjectList(context));

  /*getReferenceItem(Context context, Reference reference) => Padding(
      padding: EdgeInsets.only(left: 8, right: 8, bottom: 8),
      child: Column(children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          child: Text(
            reference.name,
            style: Theme.of(context).header5,
          ),
        ),
        SizedBox(height: 1),
        Container(
          alignment: Alignment.centerLeft,
          child: Text(
            '${reference.company}',
            style: Theme.of(context).bulletStyle,
          ),
        ),
        SizedBox(height: 1),
        Container(
          alignment: Alignment.centerLeft,
          child: Text(
            'Email: ${reference.email}',
            style: Theme.of(context).paragraphStyle,
          ),
        ),
      ]));

  List<Widget> _buildReferenceList(Context context) {
    List<Widget> widgetList = List();
    resume.references.forEach((item) {
      widgetList.add(getReferenceItem(context, item));
    });

    widgetList.insert(
      0,
      Container(
        alignment: Alignment.centerLeft,
        child: Text('Reference', style: Theme.of(context).header3),
      ),
    );

    widgetList.insert(
      1,
      getDivider(),
    );

    return widgetList;
  }

  getReference(Context context) => Column(
        children: _buildReferenceList(context),
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
      );*/

  getSkillsItem(Context context, String skill) => Padding(
      padding: EdgeInsets.only(left: 8, right: 8, bottom: 4),
      child: Text(
        skill,
        style: Theme.of(context).bulletStyle,
        textAlign: TextAlign.left,
      ));

  List<Widget> _buildSkillList(Context context) {
    List<Widget> widgetList = List();
    resume.skills.forEach((item) {
      widgetList.add(getSkillsItem(context, item.name));
    });

    widgetList.insert(
      0,
      Container(
        alignment: Alignment.centerLeft,
        child: Text('Skill', style: Theme.of(context).header3),
      ),
    );

    widgetList.insert(
      1,
      getDivider(),
    );

    return widgetList;
  }

  getSkills(Context context) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _buildSkillList(context),
      );

  /*getLanguageItem(Context context, Language language) => Padding(
      padding: EdgeInsets.only(left: 8, right: 8, bottom: 4),
      child: Column(
        children: <Widget>[
          Text(
            '${language.name}',
            style: Theme.of(context).paragraphStyle,
            textAlign: TextAlign.left,
          ),
          SizedBox(height: 1),
          Text(
            '${language.level}',
            style: Theme.of(context).bulletStyle,
            textAlign: TextAlign.left,
          )
        ],
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
      ));

  List<Widget> _buildLanguageList(Context context) {
    List<Widget> widgetList = List();
    resume.languages.forEach((item) {
      widgetList.add(getLanguageItem(context, item));
    });

    widgetList.insert(
      0,
      Container(
        alignment: Alignment.centerLeft,
        child: Text('Language', style: Theme.of(context).header3),
      ),
    );

    widgetList.insert(
      1,
      getDivider(),
    );

    return widgetList;
  }

  getLanguage(Context context) => Column(
        children: _buildLanguageList(context),
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
      );*/

  getContact(Context context) => Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              child: Text('Contact', style: Theme.of(context).header3),
            ),
            getDivider(),
            Padding(
              padding: EdgeInsets.only(left: 8, right: 8, bottom: 4),
              child: Text(
                '${resume.personalDetails.address}',
                style: Theme.of(context).bulletStyle,
              ),
            ),
            SizedBox(height: 1),
            Padding(
              padding: EdgeInsets.only(left: 8, right: 8, bottom: 4),
              child: Text(
                '+91- ${resume.personalDetails.phone}',
                style: Theme.of(context).bulletStyle,
              ),
            ),
            SizedBox(height: 1),
            Padding(
              padding: EdgeInsets.only(left: 8, right: 8, bottom: 4),
              child: Text(
                '${resume.personalDetails.email}',
                style: Theme.of(context).bulletStyle,
              ),
            ),
            SizedBox(height: 1),
            Padding(
              padding: EdgeInsets.only(left: 8, right: 8, bottom: 4),
              child: UrlLink(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'LinkedIn',
                      style: Theme.of(context).bulletStyle.copyWith(color: PdfColors.blue),
                    ),
                  ),
                  destination: resume.personalDetails.email),
            ),
          ]);

  getMainRowItem(Context context) => Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 16, right: 16),
            width: pageWidth * 0.6,
            child: Column(
              children: <Widget>[
                getExperience(context),
                SizedBox(height: 12),
                getProjects(context),
              ],
            ),
          ),
          Expanded(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  getContact(context),
                  SizedBox(height: 12),
                  getEducation(context),
                  SizedBox(height: 12),
                  getSkills(context),
                  SizedBox(height: 12),
                ],
              ),
            ),
          )
        ],
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
      );

  _getProfileImage(Context context) {
    return Positioned(
      top: 16,
      left: 16,
      child: resume.personalDetails.image!=null && resume.personalDetails!=null
          ?
      Container(
        width: pageHeight * 0.125,
        height: pageHeight * 0.125,
        decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover, 
              image: MemoryImage(base64Decode(resume.personalDetails.image),)

          ),
          shape: BoxShape.circle,
        ),
      )
      :
      Container(
        width: pageHeight * 0.125,
        height: pageHeight * 0.125,
      ),
      /*Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          image: new DecorationImage(
              fit: BoxFit.cover, image: MemoryImage(base64Decode(resume.personalDetails.image),)),
        ),
      ),*/
    );
  }

  _getSummary(Context context) {
    return Positioned(
      top: 16,
      left: pageHeight * 0.15 + 16,
      right: 16,
      bottom: pageHeight * 0.075,
      child: Container(
          child: Column(children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                'Summary',
                style: Theme.of(context).header3,
                textAlign: TextAlign.justify,
              ),
            ),
            getDivider(),
            Padding(
              padding: EdgeInsets.only(left: 8, right: 8, bottom: 4),
              child: Text(
                resume.personalDetails.professionalSummary,
                style: Theme.of(context).tableCell,
                softWrap: true,
              ),
            ),
          ])),
    );
  }

  _getName(Context context) {
    return Positioned(
      top: pageHeight * 0.15,
      left: 0,
      child: Container(
        padding: EdgeInsets.only(left: 16),
        alignment: Alignment.bottomLeft,
        height: pageHeight * 0.05,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  resume.personalDetails.name,
                  style: Theme.of(context).header2,
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  resume.personalDetails.jobTitle,
                  style: Theme.of(context).header5,
                ),
              ),
            ]),
      ),
    );
  }

  getProfileRow(Context context) => Container(
        height: pageHeight * 0.2,
        child: Stack(children: <Widget>[
          _getProfileImage(context),
          _getSummary(context),
          _getName(context),
        ]),
      );

  pdf.addPage(
    MultiPage(
        pageFormat: PdfPageFormat(pageWidth, pageHeight, marginAll: 0),
        crossAxisAlignment: CrossAxisAlignment.start,
        build: (Context context) => <Widget>[
          Padding(padding: EdgeInsets.all(32),
          child: getProfileRow(context), ),

              SizedBox(height: 8),
          Padding(padding: EdgeInsets.all(32),
            child: getMainRowItem(context), ),

            ]),
  );

  //final String dir = (await getApplicationDocumentsDirectory()).path;
  //final String dir = '/storage/emulated/0/Download/resume';
  final String dir= await createFolder('resumes');
  final String path = '$dir/resume$resumeId.pdf';
  final File file = File(path);
  if(await file.exists()){
    await file.delete();
  }
  await file.writeAsBytes(await pdf.save());
  material.Navigator.push(context, material.MaterialPageRoute(builder: (context) => PdfViewerPage(path: path,),fullscreenDialog: true));
}
