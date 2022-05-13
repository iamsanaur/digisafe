import 'package:digisafe/res/strings/strings.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class PDFViewerScreen extends StatefulWidget {
  final articleDetails;
  final userID;

  const PDFViewerScreen({Key key, this.articleDetails, this.userID})
      : super(key: key);

  @override
  _PDFViewerScreenState createState() => _PDFViewerScreenState();
}

class _PDFViewerScreenState extends State<PDFViewerScreen> {
  String urlPDFPath = "";

  PDFDocument doc;
  final appString = AppStrings();

  @override
  void initState() {
    super.initState();
    _addUserView();
    getFileFromUrl(AppStrings.serverURL +
            "download?filename=" +
            widget.articleDetails['article_location'])
        .then((f) {
      setState(() {
        urlPDFPath = f.path;
        print(urlPDFPath);
      });
    });
  }

  void _addUserView() async {
    final dio = new Dio();
    var url = AppStrings.serverURL + 'adduserview';

    var userData = {
      'article_id': widget.articleDetails['id'],
      'userID': widget.userID
    };
    var response = await dio.post(url, data: userData);
    print(response);
    print("Added");
  }

  getFileFromUrl(String url) async {
    try {
      doc = await PDFDocument.fromURL(url);
      setState(() {
        doc = doc;
      });
    } catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Text("Error opening File. "),
              actions: <Widget>[
                FlatButton(
                  child: new Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.articleDetails['article_name']),
          centerTitle: true,
        ),
        body: PDFViewer(
          document: doc,
        ));
  }
}
