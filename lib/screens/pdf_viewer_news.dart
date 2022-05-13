import 'package:digisafe/res/strings/strings.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';

import 'package:flutter/material.dart';

class PDFViewerNews extends StatefulWidget {
  final articleDetails;
  final userID;

  const PDFViewerNews({Key key, this.articleDetails, this.userID})
      : super(key: key);

  @override
  _PDFViewerNewsState createState() => _PDFViewerNewsState();
}

class _PDFViewerNewsState extends State<PDFViewerNews> {
  String urlPDFPath = "";

  PDFDocument doc;
  final appString = AppStrings();

  @override
  void initState() {
    super.initState();
    getFileFromUrl(AppStrings.serverURL +
            "downloadnews?filename=" +
            widget.articleDetails['news_location'])
        .then((f) {
      setState(() {
        urlPDFPath = f.path;
        print(urlPDFPath);
      });
    });
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
          title: Text(widget.articleDetails['news']),
          centerTitle: true,
        ),
        body: PDFViewer(
          document: doc,
        ));
  }
}
