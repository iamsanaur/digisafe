import 'package:digisafe/res/strings/strings.dart';
import 'package:http/http.dart' as http;
import 'package:digisafe/screens/home_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final appString = AppStrings();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _serverAdd = TextEditingController();
  final snackBar = SnackBar(content: Text("Updated."));
  bool visible = false;
  @override
  void initState() {
    super.initState();
    appString.loadServerIP();
  }

  Future userLogin() async {
    // Showing CircularProgressIndicator.
    setState(() {
      visible = true;
    });

    // SERVER LOGIN API URL
    var url = AppStrings.serverURL + 'auth';

    // Store all data with Param Name.
    var data = {
      'username': _usernameController.text,
      'password': _passwordController.text
    };
    try {
      // Starting Web API Call.
      var response = await http.post(url, body: data);

      // Getting Server response into variable.
      var message = response.body;

      // If the Response Message is Matched.
      if (message == 'Login Matched' && response.statusCode == 200) {
        // Hiding the CircularProgressIndicator.
        setState(() {
          visible = false;
        });

        // Navigate to Profile Screen & Sending Email to Next Screen.
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    HomeScreen(userID: _usernameController.text)));
      } else if (response.statusCode == 200) {
        // If Email or Password did not Matched.
        // Hiding the CircularProgressIndicator.
        setState(() {
          visible = false;
        });

        // Showing Alert Dialog with Response JSON Message.
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Text(message),
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
      } else {
        setState(() {
          visible = false;
        });

        // Showing Alert Dialog with Response JSON Message.
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Text(
                  "Error Connecting to DB, Please check your connection"),
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
      }
    } catch (e) {
      setState(() {
        visible = false;
      });

      // Showing Alert Dialog with Response JSON Message.
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text(
                "Error Connecting to DB, Please check your connection"),
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Digi Safe"),
        actions: <Widget>[
          IconButton(
            onPressed: () => {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: new Text("Server Settings"),
                    content: TextField(
                        controller: _serverAdd,
                        decoration:
                            InputDecoration(hintText: "Enter Server IP")),
                    actions: <Widget>[
                      FlatButton(
                        child: new Text("Update"),
                        onPressed: () {
                          appString.addServerIP(_serverAdd.text);
                          appString.loadServerIP();
                          Navigator.of(context).pop();
                        },
                      ),
                      FlatButton(
                        child: new Text("Cancel"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              )
            },
            icon: Icon(
              Icons.settings,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Icon(
              Icons.device_hub,
              size: 150,
              color: Colors.redAccent,
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: MediaQuery.of(context).size.height / 3,
              width: MediaQuery.of(context).size.width - 20,
              decoration: BoxDecoration(
                  border: Border.all(width: 0.6),
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Login with Credentials',
                    style: TextStyle(fontSize: 18),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      children: <Widget>[
                        TextField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                              hintText: "User ID",
                              icon: Icon(Icons.person),
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10)),
                        ),
                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                              hintText: "Password",
                              icon: Icon(Icons.vpn_key),
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10)),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        InkWell(
                          onTap: userLogin,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            height: MediaQuery.of(context).size.height / 15,
                            width: MediaQuery.of(context).size.width - 50,
                            decoration: BoxDecoration(
                                color: Colors.redAccent,
                                borderRadius: BorderRadius.circular(25)),
                            child: Center(
                              child: visible
                                  ? CircularProgressIndicator(
                                      backgroundColor: Colors.white,
                                    )
                                  : Text(
                                      "Login",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 25),
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text("Connected to : " + AppStrings.serverURL)
          ],
        ),
      ),
    );
  }
}
