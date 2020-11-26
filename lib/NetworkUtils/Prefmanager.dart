import 'package:shared_preferences/shared_preferences.dart';

class Prefmanager{
  //static final baseurl="http://192.168.50.75:3300";
  static final baseurl="http://192.168.50.110:3300";

  static setToken(var token)async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    await prefs.setString('token',token);
  }
  static Future<String> getToken()async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
  static Future<void>clear()async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    prefs.clear();
  }
  static setuserid(String userid)async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    await prefs.setString('userid',userid);
  }
  static Future<String> getuserid()async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    return prefs.getString('userid');
  }


}