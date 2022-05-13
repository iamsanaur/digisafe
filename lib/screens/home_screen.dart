import 'package:digisafe/res/strings/strings.dart';
import 'package:digisafe/screens/news.dart';
import 'package:digisafe/screens/pdf_viewer_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final String userID;

  const HomeScreen({Key key, this.userID}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final appString = AppStrings();

  static int page = 1;
  ScrollController _sc = new ScrollController();
  bool isLoading = false;
  List users = new List();
  List aList = new List();
  @override
  void initState() {
    this._getUserView();
    this._getMoreData(page);
    super.initState();
    _sc.addListener(() {
      if (_sc.position.pixels == _sc.position.maxScrollExtent) {
        _getMoreData(page);
      }
    });
  }

  void _getUserView() async {
    final dio = new Dio();
    var urlA = AppStrings.serverURL + "getuserview";

    var userData = {'userID': widget.userID};
    var responseA = await dio.post(urlA, data: userData);
    if (responseA.statusCode == 200) {
      print(responseA);
      for (int i = 0; i < responseA.data.length; i++) {
        aList.add(responseA.data[i]['article_id']);
      }
      print(aList);
    } else {
      print("Not Found");
    }
  }

  Future<void> _getMoreData(int index) async {
    final dio = new Dio();
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });

      var url = AppStrings.serverURL + "api/articles?page=" + index.toString();
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        print(response);
        List tList = new List();
        for (int i = 0; i < response.data['articles'].length; i++) {
          tList.add(response.data['articles'][i]);
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
                accountEmail: Text("Testbvgt6")),
            ListTile(
              title: Text("Safety Messages"),
              trailing: Icon(Icons.arrow_forward),
              onTap: () => {
                Navigator.of(context).pop(),
              },
            ),
            ListTile(
              title: Text("Daily News"),
              trailing: Icon(Icons.arrow_forward),
              onTap: () => {
                Navigator.of(context).pop(),
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => News(
                              userID: widget.userID,
                            ))).then((value) => page = 1)
              },
            )
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("Digi Safe"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.info),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: new Text("Check for Updates ? "),
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
            onPressed: () =>
                {users.clear(), this._getMoreData(1), this._getUserView()},
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
                      builder: (context) => PDFViewerScreen(
                          articleDetails: users[index], userID: widget.userID)))
            },
            leading: CircleAvatar(
              backgroundColor: aList.contains(users[index]['id'])
                  ? Colors.green
                  : Colors.red,
            ),
            title: Text(
              (users[index]['article_name']),
              style: TextStyle(fontSize: 20, color: Colors.redAccent),
            ),
            subtitle: Text(("Date: " + users[index]['trn_date'])),
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
