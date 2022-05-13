import 'package:shared_preferences/shared_preferences.dart';

class AppStrings {
  static String serverURL = "";

  void loadServerIP() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    serverURL = prefs.getString('serverip') ?? "http://192.168.1.30:8016/";
  }

  void addServerIP(String ip) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('serverip', "http://" + ip + "/");
    print("Added");
  }
}
