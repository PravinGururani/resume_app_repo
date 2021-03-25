import 'package:pdf/pdf.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart' as material;
import 'package:resume/misc/database_provider.dart';
import 'package:resume/model/personal_details.dart';
import 'package:resume/pdf_viewer_page.dart';

reportView(context) async {
  final PdfPageFormat format=PdfPageFormat.a4;
  final pdf = pw.Document();
  final pageTheme = await _myPageTheme(format);
  PersonalDetails personalDetails;

  await DatabaseProvider.db.getPersonalDetails(1).then((value) => personalDetails=value);

  pdf.addPage(pw.MultiPage(
    pageTheme: pageTheme,
      // pageFormat:
      // PdfPageFormat.letter.copyWith(marginBottom: 1.5 * PdfPageFormat.cm),


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
      //
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
                      pw.Text('${personalDetails.name}',
                          textScaleFactor: 2,
                          style: pw.Theme.of(context)
                              .defaultTextStyle
                              .copyWith(fontWeight: pw.FontWeight.bold)),
                      pw.Padding(padding: const pw.EdgeInsets.only(top: 10)),
                      pw.Text('${personalDetails.jobTitle}',
                          textScaleFactor: 1.2,
                          style: pw.Theme.of(context)
                              .defaultTextStyle
                              .copyWith(
                              fontWeight: pw.FontWeight.bold)),
                      pw.Padding(padding: const pw.EdgeInsets.only(top: 20)),
                      pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: <pw.Widget>[
                          pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: <pw.Widget>[
                              pw.Text('568 Port Washington Road'),
                              pw.Text('Nordegg, AB T0M 2H0'),
                              pw.Text('Canada, ON'),
                            ],
                          ),
                          pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: <pw.Widget>[
                              pw.Text('${personalDetails.phone}'),
                              _UrlText('${personalDetails.email}',
                                  'mailto:p.charlesbois@yahoo.com'),
                              _UrlText(
                                  'wholeprices.ca', 'https://wholeprices.ca'),
                            ],
                          ),
                          pw.Padding(padding: pw.EdgeInsets.zero)
                        ],
                      ),
                    ],
                  ),
                ),
                _Category(title: 'Work Experience'),
                _Block(
                    title: 'Tour bus driver',
                    icon: const pw.IconData(0xe530)),
                _Block(
                    title: 'Logging equipment operator',
                    icon: const pw.IconData(0xe30d)),
                _Block(title: 'Foot doctor', icon: const pw.IconData(0xe3f3)),
                _Block(
                    title: 'Unicorn trainer',
                    icon: const pw.IconData(0xf0cf)),
                _Block(
                    title: 'Chief chatter', icon: const pw.IconData(0xe0ca)),
                pw.SizedBox(height: 20),
                _Category(title: 'Education'),
                _Block(title: 'Bachelor Of Commerce'),
                _Block(title: 'Bachelor Interior Design'),
              ],
            ),
          ),
        ],
      ),
    ],
  ),
  );
  //save PDF

  final String dir = (await getApplicationDocumentsDirectory()).path;
  final String path = '$dir/report.pdf';
  final File file = File(path);
  await file.writeAsBytes(await pdf.save());
  material.Navigator.of(context).push(
    material.MaterialPageRoute(
      builder: (_) => PdfViewerPage(path: path),
    ),
  );
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
                  pw.Lorem(length: 20),
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


