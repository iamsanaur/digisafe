import 'package:digisafe/res/strings/strings.dart';
import 'package:digisafe/screens/home_screen.dart';
import 'package:digisafe/screens/pdf_viewer_news.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class News extends StatefulWidget {
  final String userID;

  const News({Key key, this.userID}) : super(key: key);

  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News> {
  final appString = AppStrings();

  static int page = 1;
  ScrollController _sc = new ScrollController();
  bool isLoading = false;
  List users = new List();
  List aList = new List();
  @override
  void initState() {
    this._getMoreData(page);
    super.initState();
    _sc.addListener(() {
      if (_sc.position.pixels == _sc.position.maxScrollExtent) {
        _getMoreData(page);
      }
    });
  }

  Future<void> _getMoreData(int index) async {
    final dio = new Dio();
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });

      var url = AppStrings.serverURL + "api/news?page=" + index.toString();
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        print(response);
        List tList = new List();
        for (int i = 0; i < response.data['news'].length; i++) {
          tList.add(response.data['news'][i]);
        }

        setState(() {
          isLoading = false;
          users.addAll(tList);
          page++;
        });
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text(
                "Error Connecting to DB, Please check your connection"),
            actions: <Widget>[
              FlatButton(
                child: new Text("OK"),
                onPressed: () => {Navigator.of(context).pop()},
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void dispose() {
    _sc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.share,
                    size: 45,
                  ),
                ),
                accountName: Text(widget.userID),
                accountEmail: Text("Nord Valorous")),
            ListTile(
              title: Text("Safety Messages"),
              trailing: Icon(Icons.arrow_forward),
              onTap: () => {
                Navigator.of(context).pop(),
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomeScreen(
                              userID: widget.userID,
                            ))).then((value) => {page = 1})
              },
            ),
            ListTile(
                title: Text("Daily News"),
                trailing: Icon(Icons.arrow_forward),
                onTap: () => {
                      Navigator.of(context).pop(),
                    })
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("Digi Safe - News"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.info),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: new Text("Logged in as: " + widget.userID),
                      actions: <Widget>[
                        FlatButton(
                          child: new Text("OK"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              }),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => {users.clear(), this._getMoreData(1)},
          )
        ],
      ),
      body: _buildList(),
    );
  }

  Widget _buildList() {
    return ListView.builder(
      itemCount: users.length + 1, // Add one more item for progress indicator
      padding: EdgeInsets.symmetric(vertical: 8.0),
      itemBuilder: (BuildContext context, int index) {
        if (index == users.length) {
          return _buildProgressIndicator();
        } else {
          return new ListTile(
            onTap: () => {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PDFViewerNews(
                          articleDetails: users[index], userID: widget.userID)))
            },
            leading: CircleAvatar(backgroundColor: Colors.green),
            title: Text(
              (users[index]['news']),
              style: TextStyle(fontSize: 20, color: Colors.redAccent),
            ),
          );
        }
      },
      controller: _sc,
    );
  }

  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: isLoading ? 1.0 : 00,
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }
}
