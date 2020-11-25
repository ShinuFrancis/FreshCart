import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:freshcart_seller/AddProduct.dart';
import 'package:freshcart_seller/Home.dart';
import 'package:freshcart_seller/NetworkUtils/Prefmanager.dart';
import 'package:freshcart_seller/ViewProfile.dart';
import 'package:freshcart_seller/main.dart';
import 'package:http/http.dart' as http;
class ViewCategory extends StatefulWidget {
  @override
  _ViewCategory createState() => _ViewCategory();
}


class _ViewCategory extends State<ViewCategory> {
  void initState(){
    super.initState();
    viewprofile();
    category();


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
  var listcat=[];
  bool prog=true;
  void  category() async {
    print("pro");
    var url =  Prefmanager.baseurl+'/category/getlist';
    var token = await Prefmanager.getToken();
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'x-auth-token':token
    };
    var response = await http.get(url,headers:requestHeaders);
    print(json.decode(response.body));
    if (json.decode(response.body)['status']) {
      listcat = json.decode(response.body)['data'];

      print(listcat[0]['name']);
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
    prog=false;
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async => false,

      child: Scaffold(
        appBar: AppBar(

            title: Text("FRESH CART"),

            //leading: Icon(Icons.arrow_back),
           leading: new IconButton(
              icon: new Icon(Icons.arrow_back,color:Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            backgroundColor: Colors.green,
            actions: <Widget>[




              // Here we take the value from the MyHomePage object that was created by
              // the App.build method, and use it to set our appbar title.
              //title: Text(widget.title),
            ]
        ),


        // bottomNavigationBar: BottomAppBar(
        //   color: Colors.green,
        //   child: new Row(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: <Widget>[
        //       Expanded(child: IconButton(icon: Icon(Icons.home,color: Colors.white,),onPressed: () {
        //         Navigator.pushReplacement(
        //             context, new MaterialPageRoute(
        //             builder: (context) => new AddProfile()));
        //       }
        //       ),
        //       ),
        //
        //       Expanded(child: IconButton(icon: Icon(Icons.person,color: Colors.white,),onPressed: () {
        //         Navigator.push(
        //             context, new MaterialPageRoute(
        //             builder: (context) => new Viewprofile()));
        //       },),
        //       ),
        //     ],
        //   ),
        // ),

        // drawer: Drawer(
        //   child:progress?Center( child: CircularProgressIndicator(),):
        //   ListView(
        //     // Important: Remove any padding from the ListView.
        //     padding: EdgeInsets.zero,
        //     children: <Widget>[
        //       Row(
        //         children: [
        //           Container(
        //             padding: EdgeInsets.all(30),
        //             alignment: Alignment.bottomCenter,
        //             child: profile[ "photo"] !=null ? CircleAvatar(
        //
        //               radius: 60.0,
        //               backgroundColor: Colors.white,
        //
        //               backgroundImage:NetworkImage(Prefmanager.baseurl+"/u/"+profile[ "photo"]),
        //
        //             ) : CircleAvatar(
        //               radius: 60.0,
        //               backgroundColor: Colors.blue,
        //               backgroundImage: AssetImage('Assets/sigup.png'),
        //
        //             ),
        //           ),
        //
        //
        //           Expanded(
        //             flex:1,
        //             child: Container(
        //               padding: EdgeInsets.all(10),
        //
        //               child:Text(profile["name"],style: TextStyle(fontSize: 20,
        //                   //fontStyle: FontStyle.italic,
        //                   fontWeight: FontWeight.bold)),
        //             ),
        //           ),
        //
        //         ],
        //       ),
        //
        //
        //       ListTile(
        //         leading: Icon(Icons.home), title: Text("Home"),
        //         onTap: () {
        //           //Navigator.pop(context);
        //           Navigator.push(context,MaterialPageRoute(builder: (context) => AddProfile()));
        //         },
        //       ),
        //       ListTile(
        //         leading: Icon(Icons.account_circle), title: Text("My Account"),
        //         onTap: () {
        //           Navigator.push(
        //               context, new MaterialPageRoute(
        //               builder: (context) => new Viewprofile()));
        //         },
        //       ),
        //       ListTile(
        //         leading: Icon(Icons.collections), title: Text("View orders"),
        //         onTap: () {
        //           Navigator.pop(context);
        //         },
        //       ),
        //       ListTile(
        //         leading: Icon(Icons.add), title: Text("Add Product"),
        //         onTap: () {
        //           // Navigator.push(
        //           //     context, new MaterialPageRoute(
        //           //     builder: (context) => new ViewCategory());
        //         },
        //       ),
        //
        //       ListTile(
        //         leading: Icon(Icons.home), title: Text("Change Password"),
        //         onTap: () {
        //           // Navigator.pushReplacement(
        //           //     context, new MaterialPageRoute(builder: (context) => new ChangePassword()));
        //         },
        //       ),
        //
        //       ListTile(
        //         leading: Icon(Icons.account_circle), title: Text("Logout"),
        //         onTap: () {
        //           //Navigator.pop(context);
        //           Prefmanager.clear();
        //           Navigator.push(context,MaterialPageRoute(builder: (context) => SecondScreen()));
        //         },
        //       ),
        //     ],
        //   ),
        // ),
        body:
        SingleChildScrollView(
          child: Column(

            children: <Widget>[


              progress?Center( child: CircularProgressIndicator(),):
              Container(
                  padding: EdgeInsets.all(10),

                  child:Text("View Category", style: TextStyle(fontSize: 18,color:Colors.green)),
              ),
             SizedBox(
               height: 20,
             ),
              Container(
                padding: EdgeInsets.all(20),
                child: GridView.count(

                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 3 ,
                  children: List.generate(listcat.length,(index){
                    return GestureDetector(
                        child: Container(
                          child: Card(

                            child: Column(

                              children: [
                                SizedBox(
                                  height: 30,

                                ),
                                Icon(
                                  Icons.description,
                                  size: 20,
                                  color: Colors.green,
                                ),
                                //Icon(IconData(int.parse(listcat[index]["flutterIcon"]),fontFamily: "MaterialIcons"),color: Colors.blue),

                                SizedBox(
                                  height: 10,
                                ),
                                Text(listcat[index]['name'],style: TextStyle(color: Colors.black),textAlign: TextAlign.center),

                              ],

                            ),

                          ),
                        ),
                        onTap:() {

                          Navigator.push(context,MaterialPageRoute(builder: (context) => AddProduct(listcat[index]["_id"])));

                        }

                    );


                  }),
                ),
              ),

            ]
          ),

        ),
      ),
    );
  }

}




