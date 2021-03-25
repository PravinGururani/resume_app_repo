import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
import 'package:wc_flutter_share/wc_flutter_share.dart';

class PdfViewerPage extends StatelessWidget {
  final String path;
  const PdfViewerPage({Key key, this.path}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.deepOrange,
      child: PDFViewerScaffold(
        appBar: AppBar(
          backgroundColor: Colors.black54,
          title: Center(child: Text("Resume Preview")),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.share),
              onPressed: _shareFile,
            ),
          ],
        ),
          path: path,
      ),
    );
  }

  _shareFile() async {
    ByteData bytes;
    await _readFileByte(path).then((value) => bytes = ByteData.view(value.buffer));
    await WcFlutterShare.share(
        sharePopupTitle: 'share',
        fileName: '${path.substring(path.lastIndexOf("/") + 1)}',
        mimeType: 'application/pdf',
        bytesOfFile: bytes.buffer.asUint8List());
  }

  Future<Uint8List> _readFileByte(String filePath) async {
    Uri myUri = Uri.parse(filePath);
    File file = new File.fromUri(myUri);
    Uint8List bytes;
    await file.readAsBytes().then((value) {
      bytes = Uint8List.fromList(value);
      print('reading of bytes is completed');
    }).catchError((onError) {
      print('Exception Error while reading file from path:' +
          onError.toString());
    });
    return bytes;
  }
}