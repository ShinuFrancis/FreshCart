import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:freshcart_seller/AddDeliveryDate.dart';
import 'package:freshcart_seller/AddProduct.dart';
import 'package:freshcart_seller/AddSaleLocation.dart';
import 'package:freshcart_seller/EditProduct.dart';
import 'package:freshcart_seller/EditProfile.dart';
import 'package:freshcart_seller/MyOrder.dart';
import 'package:freshcart_seller/NetworkUtils/Prefmanager.dart';
import 'package:freshcart_seller/PurchaseRequest.dart';
import 'package:freshcart_seller/SetDeliveryDate.dart';
import 'package:freshcart_seller/UpdateSaleLocation.dart';
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
  @override
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
    print(token);
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
            centerTitle: true,

            //leading: Icon(Icons.menu),

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

        drawer: Drawer(

          child:progress?Center( child: CircularProgressIndicator(),):
          ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(40),
                    alignment: Alignment.bottomCenter,
                    child:CircleAvatar(
                      radius: 60.0,
                      backgroundColor: Colors.white,
                      backgroundImage: AssetImage('Assets/green.png'),

                    ),
                  ),


                  Expanded(
                    flex:1,
                    child: Container(
                      padding: EdgeInsets.all(10),

                     child:Text(profile['name'],style: TextStyle(fontWeight: FontWeight.bold,fontSize:18),),
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

    body:progress ? Center(child:  CircularProgressIndicator(),):
    Card(
      child: Container(

        height:MediaQuery.of(context).size.height-70 ,

        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50.0,
                  backgroundColor: Colors.white,
                  backgroundImage: AssetImage('Assets/green.png'),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(profile['name']),
                  Text(profile['phone']),
                   Text(profile['email'])
                  ],
                ),
                IconButton(
                    icon: new Icon(Icons.edit),
                    color:Colors.black,
                    onPressed: () async{
                      bool pro=await
                      Navigator.push(
                          context, new MaterialPageRoute(builder: (context) =>new Profile()));
                      if(pro){
                        print("pro");
                        viewprofile();
                      }
                      else{}
                    }
                ),


              ],
            ),
                SizedBox(
                  height: 10,
                ),

            Container(
              //height: 300,
              //width:MediaQuery.of(context).size.width/1,

              height:MediaQuery.of(context).size.height-250,

              child: GridView.extent(
                shrinkWrap: true,

                primary: false,
                padding: const EdgeInsets.all(15),
                crossAxisSpacing: 10,
                mainAxisSpacing: 20,
                maxCrossAxisExtent: 180.0,
                children: <Widget>[
                  GestureDetector(
                      child: Card(

                        elevation: 5.0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add,
                              size: 40,
                              color: Colors.green,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text("Add Product",textAlign: TextAlign.center,),

                          ],
                        ),
                      ),
                      onTap:() {Navigator.push(
                          context, new MaterialPageRoute(
                          builder: (context) => new ViewCategory()));

                      }
                  ),
                  GestureDetector(
                    child: Card(
                      elevation: 5.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.collections,
                            size: 40,
                            color: Colors.green,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text("View Products",textAlign: TextAlign.center,),
                        ],
                      ),
                      color: Colors.white,
                    ),
                    onTap: (){
                      Navigator.push(
                          context, new MaterialPageRoute(
                          builder: (context) => new ViewProduct()));
                    },
                  ),
                  GestureDetector(
                    child: Card(
                      elevation: 5.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_location,
                            size: 40,
                            color: Colors.green,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text("Sales Location",textAlign: TextAlign.center,),
                        ],
                      ),
                      color: Colors.white,
                    ),
                    onTap: (){
                      Navigator.push(
                          context, new MaterialPageRoute(
                          builder: (context) => new UpdateSaleLocation()));
                    },
                  ),
                  GestureDetector(
                    child: Card(
                      elevation: 5.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.date_range,
                            size: 40,
                            color: Colors.green,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text("Delivery Date",textAlign: TextAlign.center,),
                        ],
                      ),
                      color: Colors.white,
                    ),
                    onTap: (){
                      Navigator.push(
                          context, new MaterialPageRoute(
                          builder: (context) => new AddDeliveryDate()));
                    },
                  ),
                  GestureDetector(
                    child: Card(
                      elevation: 5.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_shopping_cart,
                            size: 40,
                            color: Colors.green,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text("Purchase Request",textAlign: TextAlign.center,),
                        ],
                      ),
                      color: Colors.white,
                    ),
                    onTap: (){
                      Navigator.push(
                          context, new MaterialPageRoute(
                          builder: (context) => new PurchaseRequest()));
                    },
                  ),
                  GestureDetector(
                    child: Card(
                      elevation: 5.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.collections,
                            size: 40,
                            color: Colors.green,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text("Orders",textAlign: TextAlign.center,),
                        ],
                      ),
                      color: Colors.white,
                    ),
                    onTap:(){
                      Navigator.push(
                          context, new MaterialPageRoute(
                          builder: (context) => new MyOrder()));
                    },
                  ),
                  GestureDetector(
                    child: Card(

                      elevation: 5.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.description,
                            size: 40,
                            color: Colors.green,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text("Delivery History",textAlign: TextAlign.center),
                        ],
                      ),
                      color: Colors.white,
                    ),
                  ),

                  // Container(
                  //   padding: const EdgeInsets.all(8),
                  //   child: Column(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       Icon(
                  //         Icons.add_location_alt_outlined,
                  //         size: 30,
                  //         color: Colors.green,
                  //       ),
                  //       SizedBox(
                  //         height: 20,
                  //       ),
                  //       Text("Delivery Locations"),
                  //     ],
                  //   ),
                  //   color: Colors.white,
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),

    ),
    );
  }
}


