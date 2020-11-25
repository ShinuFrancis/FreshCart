import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



import 'package:fluttertoast/fluttertoast.dart';
import 'package:freshcart_seller/EditProfile.dart';
import 'package:freshcart_seller/Home.dart';
import 'package:freshcart_seller/NetworkUtils/Prefmanager.dart';
import 'package:freshcart_seller/main.dart';


import 'package:http/http.dart' as http;




class Viewprofile extends StatefulWidget {
  @override
  _Viewprofile createState() => new _Viewprofile();
}

//State is information of the application that can change over time or when some actions are taken.
class _Viewprofile extends State<Viewprofile>{

  @override
  void initState() {
    super.initState();
    viewprofile();

  }
  var profile ;
  var pro;
  bool progress=true;
  void  viewprofile() async {
    print("pro");
    var url =  Prefmanager.baseurl+'/user/profile';
    var token = await Prefmanager.getToken();
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'x-auth-token':token
    };
    var response = await http.get(url,headers:requestHeaders);
    print(json.decode(response.body));
    if (json.decode(response.body)['status']) {
      profile = json.decode(response.body)['data'];
      print(profile);
    }

    else
      Fluttertoast.showToast(
          msg: json.decode(response.body)['msg'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 20.0
      );

    setState(() {

    });
    progress=false;
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: ()async=>false,
      child: Scaffold(
        // appBar: new AppBar(
        //   title: new Text('Profile', style: TextStyle(color: Colors.blue),),
        //  backgroundColor: Colors.white,
        // ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.white,
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(child: IconButton(icon: Icon(Icons.home),onPressed: () {
                Navigator.pushReplacement(
                    context, new MaterialPageRoute(
                    builder: (context) => new AddProfile()));
              }
              ),
              ),

              Expanded(child: IconButton(icon: Icon(Icons.person),onPressed: () {
                Navigator.push(
                    context, new MaterialPageRoute(
                    builder: (context) => new Viewprofile()));
              },),
              ),
            ],
          ),
        ),
        body:progress?Center( child: CircularProgressIndicator(),):
        SafeArea(
          child: Container(
            padding: new EdgeInsets.all(20.0),
            child: new Center(
              child: SingleChildScrollView(
                child: new Column(
                    children: <Widget>[
                      new Card(

                        color:Colors.green,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                        elevation: 4.0,
                        child: new Container(
                          child: new Column(
                              children: <Widget>[
                                Row(
                                    mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                          padding: EdgeInsets.all(5),
                                          alignment: Alignment.topLeft,

                                          //child: IconButton(icon: Icon(Icons.person,color: Colors.white,),onPressed: () {})
                                      ),
                                      Container(
                                          padding: EdgeInsets.all(5),
                                          alignment: Alignment.topRight,

                                         // child: IconButton(icon: Icon(Icons.settings,color: Colors.white,),onPressed: () {})
                                      ),
                                    ]
                                ),

                                Container(
                                  padding: EdgeInsets.all(10),
                                  alignment: Alignment.bottomCenter,
                                  child: CircleAvatar(

                                    radius: 60.0,
                                    backgroundColor: Colors.white,
                                    backgroundImage: AssetImage('Assets/sigup.png'),

                                  ),
                                ),
                                //Text(profile['name']),
                                Text(profile["name"],style: TextStyle(fontSize: 20,color: Colors.white,
                                fontWeight: FontWeight.bold)),
                                Text(profile["phone"],style: TextStyle(fontSize: 15,color: Colors.white,
                                    //fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold)),
                                //Text(profile['phone']),
                                SizedBox(
                                  height: 20,
                                  width: 20,
                                ),
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.all(20),
                                  child: FlatButton(

                                    child: Text('Update Profile',style: TextStyle(fontSize: 15,color: Colors.white,
                                        //fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.bold)),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.0),),
                                    color: Colors.green,
                                    textColor: Colors.white,
                                    onPressed: () {
                                      Navigator.push(
                                          context, new MaterialPageRoute(builder: (context) => new Profile()));
                                      },
                                  ),
                                ),
                              ]

                            //new Text('Hello World'),
                            //new Text('How are you?')

                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                        width: 40,
                      ),
                      new Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                        elevation: 4.0,

                        child: new Container(
                          padding: new EdgeInsets.all(10.0),
                          child: new Column(
                            children: <Widget>[

                              ListTile(
                                leading: Icon(Icons.person),
                                title: Text('Change Password'),
                                trailing: Icon(Icons.arrow_right),
                                //onTap: () {Navigator.push(context,MaterialPageRoute(builder: (context) => NewOrder()));},
                              ),
                              ListTile(
                                leading: Icon(Icons.account_circle),
                                title: Text('Logout'),
                                trailing: Icon(Icons.arrow_right),
                                onTap: () {
                                  Prefmanager.clear();
                                  Navigator.push(context,MaterialPageRoute(builder: (context) => SecondScreen()));
                                },

                              ),
                            ],
                          ),
                        ),


                        //),
                      ),
                    ]
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}