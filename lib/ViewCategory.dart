import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:freshcart_seller/AddProduct.dart';
import 'package:freshcart_seller/AddSaleLocation.dart';
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
              icon: new Icon(Icons.arrow_back,color:Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
            backgroundColor: Colors.green,
            actions: <Widget>[




              // Here we take the value from the MyHomePage object that was created by
              // the App.build method, and use it to set our appbar title.
              //title: Text(widget.title),
            ]
        ),



        body:
        SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,

            children: <Widget>[


              progress?Center( child: CircularProgressIndicator(),):
              Container(
                  padding: EdgeInsets.all(20),

                  child:Text("Select Category", style: TextStyle(fontSize: 18,color:Colors.black,fontWeight: FontWeight.bold)),
              ),
             SizedBox(
               height: 5,
             ),

              Container(
                width: 1000,
                padding: EdgeInsets.all(20),
                child: GridView.count(
                      childAspectRatio: 0.45,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 3 ,
                  children: List.generate(listcat.length,(index){
                    return GestureDetector(
                        child: Card(
                          child: Container(
                            height: MediaQuery.of(context).size.height/2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,

                              children: [
                                SizedBox(
                                  height: 80,

                                ),
                                Icon(
                                  Icons.category,
                                  size:80,
                                  color: Colors.green,
                                ),
                                //Icon(IconData(int.parse(listcat[index]["flutterIcon"]),fontFamily: "MaterialIcons"),color: Colors.blue),

                                SizedBox(
                                  height: 20,
                                ),
                                Text(listcat[index]['name'],style: TextStyle(color: Colors.black,fontSize: 20),textAlign: TextAlign.center),

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




