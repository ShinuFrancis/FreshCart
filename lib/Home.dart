import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:freshcart_seller/AddProduct.dart';
import 'package:freshcart_seller/NetworkUtils/Prefmanager.dart';
import 'package:freshcart_seller/ViewCategory.dart';
import 'package:freshcart_seller/ViewProduct.dart';
import 'package:freshcart_seller/ViewProfile.dart';
import 'package:freshcart_seller/main.dart';
import 'package:http/http.dart' as http;
class AddProfile extends StatefulWidget {
  @override
  _AddProfile createState() => _AddProfile();
}


class _AddProfile extends State<AddProfile> {
  void initState(){
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

    return WillPopScope(
      onWillPop: () async => false,

      child: Scaffold(
        appBar: AppBar(

            title: Text("FRESH CART"),

            //leading: Icon(Icons.menu),

            backgroundColor: Colors.blue,
            actions: <Widget>[
              IconButton(icon: Icon(Icons.person), onPressed: ()  {
                Navigator.push(
                  context, new MaterialPageRoute(
                  builder: (context) =>  Viewprofile(),),
                );
              }
              ),



              // Here we take the value from the MyHomePage object that was created by
              // the App.build method, and use it to set our appbar title.
              //title: Text(widget.title),
            ]
        ),


        bottomNavigationBar: BottomAppBar(
          color: Colors.blue,
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

        drawer: Drawer(
          child:progress?Center( child: CircularProgressIndicator(),):
          ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(30),
                    alignment: Alignment.bottomCenter,
                    child: profile[ "photo"] !=null ? CircleAvatar(

                      radius: 60.0,
                      backgroundColor: Colors.white,

                      backgroundImage:NetworkImage(Prefmanager.baseurl+"/u/"+profile[ "photo"]),

                    ) : CircleAvatar(
                      radius: 60.0,
                      backgroundColor: Colors.blue,
                      backgroundImage: AssetImage('Assets/sigup.png'),

                    ),
                  ),


                  Expanded(
                    flex:1,
                    child: Container(
                      padding: EdgeInsets.all(10),

                      child:Text(profile["name"],style: TextStyle(fontSize: 20,
                             //fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold)),
                    ),
                  ),

                ],
              ),


              ListTile(
                leading: Icon(Icons.home), title: Text("Home"),
                onTap: () {
                  //Navigator.pop(context);
                  Navigator.push(context,MaterialPageRoute(builder: (context) => AddProfile()));
                },
              ),
              ListTile(
                leading: Icon(Icons.account_circle), title: Text("My Account"),
                onTap: () {
                  Navigator.push(
                      context, new MaterialPageRoute(
                      builder: (context) => new Viewprofile()));
                },
              ),
              ListTile(
                leading: Icon(Icons.collections), title: Text("View Products"),
                onTap: () {
                  Navigator.push(
                      context, new MaterialPageRoute(
                      builder: (context) => new ViewProduct()));
                },
              ),
              ListTile(
                leading: Icon(Icons.add), title: Text("Add Product"),
                onTap: () {
                  Navigator.push(
                      context, new MaterialPageRoute(
                      builder: (context) => new ViewCategory()));
                },
              ),

              ListTile(
                leading: Icon(Icons.home), title: Text("Change Password"),
                onTap: () {
                  // Navigator.pushReplacement(
                  //     context, new MaterialPageRoute(builder: (context) => new ChangePassword()));
                },
              ),

              ListTile(
                leading: Icon(Icons.account_circle), title: Text("Logout"),
                onTap: () {
                  //Navigator.pop(context);
                  Prefmanager.clear();
                 Navigator.push(context,MaterialPageRoute(builder: (context) => SecondScreen()));
                },
              ),
            ],
          ),
        ),
        body:
        SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.symmetric(vertical: 15),
                height: 45,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    GestureDetector(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width / 3,
                        height: 100,
                        margin: const EdgeInsets.only(right: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: Colors.white,
                        ),
                        child:Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.add,
                              size: 20,
                              color: Colors.blue,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text("Add Product"),
                          ],
                        ), // icon is 48px widget.,
                      ),
                      onTap:() {
                        Navigator.push(
                            context, new MaterialPageRoute(
                            builder: (context) => new ViewCategory()));

                      }
                    ),
                    GestureDetector(
                      child: Container(
                        alignment: Alignment.center,
                        height: 100,
                        width: MediaQuery.of(context).size.width / 3,
                        margin: const EdgeInsets.only(right: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: Colors.white,
                        ),

                        child: Row(
                          children: [
                            Icon(
                              Icons.collections,
                              size: 20,
                              color: Colors.blue,
                            ),
                            SizedBox(
                              height: 20,
                            ),

                            Text("View Products"),
                          ],
                        ),
                      ),
                      onTap: (){
                        Navigator.push(
                            context, new MaterialPageRoute(
                            builder: (context) => new ViewProduct()));
                      },
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: 100,
                      width: MediaQuery.of(context).size.width / 3,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.add_alarm_rounded,
                            size: 20,
                            color: Colors.blue,
                          ),
                          SizedBox(
                            height: 20,
                          ),

                          Text("Set Delivery Date"),
                        ],
                      ),
                    ),
                  ],
                ),


              ),
              Container(
                  padding: EdgeInsets.all(10),
                  constraints: BoxConstraints.expand(
                      height: 300,
                    width: double.infinity,
                  ),
                  child: imageSlider(context)
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("NOTIFICATIONS",style: TextStyle(color: Colors.blue,fontSize: 15),textAlign: TextAlign.start,),
                FlatButton(
                      textColor: Colors.blue,
                      //color: Colors.blue,
                      child: Text('See All',style: TextStyle(color: Colors.blue,fontSize: 15)),
                    onPressed: () {

                  }

                      ),
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
                Card(
                  child: Container(
                  padding: EdgeInsets.all(20),
                  height: 200,
                  child: ListView.builder(
                      itemCount: 3,
                      itemBuilder: (BuildContext context,int index) {
                        return Container(
                          padding: EdgeInsets.all(10),
                          height: 50,
                          width: double.infinity,

                          //child: Text("Notifications" + index.toString()),
                          child: ListTile(
                            leading: Icon(Icons.play_circle_filled,color: Colors.green,),
                            title: Text("Notifications" + index.toString()),
                            trailing: Icon(Icons.close),
                          ),
                        );
                      }
                  ),
                ),
              ),







            ],
          ),
        ),
      ),
    );



  }


}
Swiper imageSlider(context){

  return new Swiper(
    autoplay: true,
    itemBuilder: (BuildContext context, int index) {
      return new Image.network(
        'https://thumbs.dreamstime.com/b/balanced-diet-concept-fresh-meat-fish-pasta-fruits-vegetables-nuts-seeds-balanced-diet-concept-fresh-meat-fish-pasta-fruits-137873813.jpg', fit: BoxFit.fitHeight,
      );

    },
    itemCount: 10,
    viewportFraction: 0.8,
    scale: 0.9,
  );

}
