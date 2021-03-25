import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:resume/misc/create_pdf.dart';
import 'package:resume/model/resume_data.dart';
import 'package:resume/templates/classic_template.dart';
import 'package:resume/utility/template_list.dart';

class SelectResumeTemplate extends StatefulWidget {
  @override
  _SelectResumeTemplateState createState() => _SelectResumeTemplateState();

  SelectResumeTemplate({@required this.resumeData, @required this.resumeId , @required this.context});
  final ResumeData resumeData;
  final int resumeId;
  final BuildContext context;

}

class _SelectResumeTemplateState extends State<SelectResumeTemplate> {
  int _radioValue = -1;

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;

      switch (_radioValue) {
        case 0:
          getPdf(widget.resumeData, widget.resumeId, context);
          break;
        case 1:
          classicTemplate(widget.resumeData, widget.resumeId, context);
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        title: Center(child: Text("Select Template",
          style: TextStyle(
              color: Colors.white
          ),
        ),
        ),
      ),
      body: GridView.count(
        childAspectRatio: 0.75,
        crossAxisCount: 2 ,
        padding: EdgeInsets.all(4),
        children: List.generate(resumeTemplates.length,(index){
          return Container(
            child: GestureDetector(
              onTap: (){
                _handleRadioValueChange(index);
              },
              child: Card(
                color: Colors.black87,
                child: Wrap(
                  children: [
                    Row(
                      children: [
                        Radio(
                          value: index,
                          groupValue: _radioValue,
                          activeColor: Colors.white,
                          focusColor: Colors.white,
                          onChanged: _handleRadioValueChange,
                        ),
                        Text(
                          '${resumeTemplates[index]}',
                          style: new TextStyle(fontSize: 16.0, color: Colors.white),
                        )
                      ],
                    ),
                    Image.asset('resources/resume_thumbnails/${resumeTemplates[index]}.jpg',
                      height:300,
                      width:225,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
