import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:resume/misc/create_pdf.dart';
import 'package:resume/misc/database_provider.dart';
import 'package:resume/model/resume_data.dart';
import 'package:resume/pdf_viewer_page.dart';
import 'package:resume/templates/classic_template.dart';
import 'package:resume/view/add_academic_details.dart';
import 'package:resume/view/add_achievements.dart';
import 'package:resume/view/add_projects.dart';
import 'package:resume/view/add_skills.dart';
import 'package:resume/view/add_personal_details.dart';
import 'package:resume/view/add_work_experience.dart';

import 'dart:io';

import 'package:pdf/widgets.dart' as pw;
import 'package:resume/view/colors/colors.dart';
import 'package:resume/view/select_resume_template.dart';

class CreateResume extends StatelessWidget {

  CreateResume({@required this.resumeId});
  final int resumeId;

  ResumeData resumeData=new ResumeData();


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 6,
        initialIndex: 0,
        child: Scaffold(
          bottomNavigationBar: GestureDetector(
            onTap: ()  {
              getFullResume(context);
            },
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  color: Colors.black54,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text('GENERATE RESUME',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          appBar: AppBar(
            backgroundColor: main,
            automaticallyImplyLeading: false,
            title: Center(child: Text("CREATE RESUME")),
            bottom: TabBar(
              isScrollable: true,
              tabs: [
                Tab(text: "1.Personal Details",),
                Tab(text: "2.Skills",),
                Tab(text: "3.Work Experience",),
                Tab(text: "4.Projects",),
                Tab(text: "5.Academic",),
                Tab(text: "6.Achievements",),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              AddPersonalDetails(resumeId: resumeId),
              AddSkills(resumeId: resumeId),
              AddWorkExperience(resumeId: resumeId),
              AddProjects(resumeId: resumeId),
              AddAcademicDetails(resumeId: resumeId),
              AddAchievements(resumeId: resumeId),
            ],
          ),
          // bottomNavigationBar: SizedBox(
          //   height: 100,
          //   width: MediaQuery.of(context).size.width,
          //   child: Stack(
          //     children: [
          //
          //     ],
          //   ),
          // ),
        ),
    );
  }

  void getFullResume(BuildContext context) async {
    final pageTheme = await _myPageTheme(PdfPageFormat.a4);
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
    //generatePdf(context,pageTheme);
    if(resumeData.personalDetails==null){
      Fluttertoast.showToast(
          msg: "Please Save Personal Details",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
    else{
      Navigator.of(context).push(new MaterialPageRoute<Null>(
          builder: (BuildContext context) {
            return new SelectResumeTemplate(resumeData: resumeData,resumeId: resumeId,);
          },
          fullscreenDialog: true
      ));
    }
  }

  Future<void> generatePdf(BuildContext context,pw.PageTheme pageTheme) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageTheme: pageTheme,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        header: (pw.Context context) {
          if (context.pageNumber == 1) {
            return null;
          }
          return pw.Container(
              alignment: pw.Alignment.centerRight,
              margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
              padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
              child: pw.Text('Resume',
                  style: pw.Theme.of(context)
                      .defaultTextStyle
                      .copyWith(color: PdfColors.grey)));
        },
        footer: (pw.Context context) {
          return pw.Container(
              alignment: pw.Alignment.centerRight,
              margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
              child: pw.Text('Page ${context.pageNumber} of ${context.pagesCount}',
                  style: pw.Theme.of(context)
                      .defaultTextStyle
                      .copyWith(color: PdfColors.grey)));
        },
        build: (pw.Context context) => [
          pw.Partitions(
            children: [
              pw.Partition(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: <pw.Widget>[
                    pw.Container(
                      padding: const pw.EdgeInsets.only(left: 30, bottom: 20),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: <pw.Widget>[
                          pw.Row(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                            children: <pw.Widget>[
                              pw.Column(
                                children: [
                                  pw.Text('${resumeData.personalDetails.name}',
                                      textScaleFactor: 2,
                                      style: pw.Theme.of(context)
                                          .defaultTextStyle
                                          .copyWith(fontWeight: pw.FontWeight.bold)),
                                  pw.Padding(padding: const pw.EdgeInsets.only(top: 10)),
                                  pw.Text('${resumeData.personalDetails.jobTitle}',
                                      textScaleFactor: 1.2,
                                      style: pw.Theme.of(context)
                                          .defaultTextStyle
                                          .copyWith(
                                          fontWeight: pw.FontWeight.bold)),
                                  pw.Padding(padding: const pw.EdgeInsets.only(top: 20)),
                                ]
                              ),
                              /*pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: <pw.Widget>[
                                  pw.Text('568 Port Washington Road'),
                                  pw.Text('Nordegg, AB T0M 2H0'),
                                  pw.Text('Canada, ON'),
                                ],
                              ),*/
                              pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: <pw.Widget>[
                                  pw.Text('${resumeData.personalDetails.phone}'),
                                  _UrlText('${resumeData.personalDetails.email}',
                                      'mailto:p.charlesbois@yahoo.com'),
                                ],
                              ),
                              pw.Padding(padding: pw.EdgeInsets.zero)
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    _Category(title: 'Work Experience'),
                    pw.ListView.builder(
                        itemCount: resumeData.workExperience.length,
                        itemBuilder:(context,index){
                          return _Block(title: resumeData.workExperience[index].companyName, icon: const pw.IconData(0xe3f3));
                        }),
                    pw.SizedBox(height: 20),
                    _Category(title: 'Projects'),
                    pw.ListView.builder(
                        itemCount: resumeData.projectDetails.length,
                        itemBuilder:(context,index){
                          return _Block(title: resumeData.projectDetails[index].projectName, icon: const pw.IconData(0xe3f3));
                        }),
                    pw.SizedBox(height: 20),
                    _Category(title: 'Education'),
                    pw.ListView.builder(
                        itemCount: resumeData.academicdetails.length,
                        itemBuilder:(context,index){
                          return _Block(title: resumeData.academicdetails[index].course, icon: const pw.IconData(0xe3f3));
                        }),
                    pw.SizedBox(height: 20),
                    _Category(title: 'Achievements'),
                    pw.ListView.builder(
                        itemCount: resumeData.achievements.length,
                        itemBuilder:(context,index){
                          return _Block(title: resumeData.achievements[index].achievement, icon: const pw.IconData(0xe3f3));
                        }),
                    pw.SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );

    final String dir = (await getApplicationDocumentsDirectory()).path;
    final String path = '$dir/resume$resumeId.pdf';
    final File file = File(path);
    if(await file.exists()){
      await file.delete();
    }
    await file.writeAsBytes(await pdf.save());
    Navigator.push(context, MaterialPageRoute(builder: (context) => PdfViewerPage(path: path,),fullscreenDialog: true));
  }
}


Future<pw.PageTheme> _myPageTheme(PdfPageFormat format) async {

  format = format.applyMargin(
      left: 2.0 * PdfPageFormat.cm,
      top: 4.0 * PdfPageFormat.cm,
      right: 2.0 * PdfPageFormat.cm,
      bottom: 2.0 * PdfPageFormat.cm);
  return pw.PageTheme(
    pageFormat: format,
  );
}







class _Block extends pw.StatelessWidget {
  _Block({
    this.title,
    this.icon,
  });

  final String title;

  final pw.IconData icon;




  @override
  pw.Widget build(pw.Context context) {
    return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: <pw.Widget>[
          pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: <pw.Widget>[
                pw.Container(
                  width: 6,
                  height: 6,
                  margin: const pw.EdgeInsets.only(top: 2.5, left: 2, right: 5),
                  decoration: const pw.BoxDecoration(
                      shape: pw.BoxShape.circle),
                ),
                pw.Text(title,
                    style: pw.Theme.of(context)
                        .defaultTextStyle
                        .copyWith(fontWeight: pw.FontWeight.bold)),
                pw.Spacer(),
              ]),
          pw.Container(
            decoration: const pw.BoxDecoration(
                border: pw.Border(left: pw.BorderSide(width: 2))),
            padding: const pw.EdgeInsets.only(left: 10, top: 5, bottom: 5),
            margin: const pw.EdgeInsets.only(left: 5),
            child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: <pw.Widget>[
                  pw.Lorem(length: 200),
                ]),
          ),
        ]);
  }
}

class _Category extends pw.StatelessWidget {
  _Category({this.title});

  final String title;

  @override
  pw.Widget build(pw.Context context) {
    return pw.Container(
        decoration: const pw.BoxDecoration(
          borderRadius: pw.BorderRadius.all(pw.Radius.circular(6)),
        ),
        margin: const pw.EdgeInsets.only(bottom: 10, top: 20),
        padding: const pw.EdgeInsets.fromLTRB(10, 7, 10, 4),
        child: pw.Text(title, textScaleFactor: 1.5));
  }
}

class _Percent extends pw.StatelessWidget {
  _Percent({
    this.size,
    this.value,
    this.title,
    this.fontSize = 1.2,
    this.backgroundColor = PdfColors.grey300,
    this.strokeWidth = 5,
  });

  final double size;

  final double value;

  final pw.Widget title;

  final double fontSize;

  final PdfColor backgroundColor;

  final double strokeWidth;

  @override
  pw.Widget build(pw.Context context) {
    final widgets = <pw.Widget>[
      pw.Container(
        width: size,
        height: size,
        child: pw.Stack(
          alignment: pw.Alignment.center,
          fit: pw.StackFit.expand,
          children: <pw.Widget>[
            pw.Center(
              child: pw.Text(
                '${(value * 100).round().toInt()}%',
                textScaleFactor: fontSize,
              ),
            ),
            pw.CircularProgressIndicator(
              value: value,
              backgroundColor: backgroundColor,
              strokeWidth: strokeWidth,
            ),
          ],
        ),
      )
    ];

    widgets.add(title);

    return pw.Column(children: widgets);
  }
}

class _UrlText extends pw.StatelessWidget {
  _UrlText(this.text, this.url);

  final String text;
  final String url;

  @override
  pw.Widget build(pw.Context context) {
    return pw.UrlLink(
      destination: url,
      child: pw.Text(text,
          style: const pw.TextStyle(
            decoration: pw.TextDecoration.underline,
            color: PdfColors.blue,
          )),
    );
  }
}



