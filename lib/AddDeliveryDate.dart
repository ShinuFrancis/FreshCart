import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:freshcart_seller/AddProduct.dart';
import 'package:freshcart_seller/Home.dart';
import 'package:freshcart_seller/NetworkUtils/Prefmanager.dart';
import 'package:freshcart_seller/SetDeliveryDate.dart';
import 'package:freshcart_seller/ViewProfile.dart';
import 'package:freshcart_seller/main.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
class AddDeliveryDate extends StatefulWidget {
  @override
  _AddDeliveryDate createState() => _AddDeliveryDate();
}


class _AddDeliveryDate extends State<AddDeliveryDate> {
  var formattedDate = new DateFormat('dd-MM-yyyy');
  void initState(){
    super.initState();
    category();
    DeliveryDate();


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
  var date=[];
  void  DeliveryDate() async {
    print("pro");
    var url =  Prefmanager.baseurl+'/user/getmycategories';
    var token = await Prefmanager.getToken();
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'x-auth-token':token
    };
    var response = await http.get(url,headers:requestHeaders);
    print(json.decode(response.body));
    if (json.decode(response.body)['status']) {
      date = json.decode(response.body)['data'];

      print(date[0]['deliveryDate']);
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
        body:
        SingleChildScrollView(
          child: Column(

              children: <Widget>[


                prog?Center( child: CircularProgressIndicator(),):
                Container(
                  padding: EdgeInsets.all(10),

                  child:Text("Delivery Date", style: TextStyle(fontSize: 18,color:Colors.green)),
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
                                  SizedBox(
                                    height: 10,
                                  ),
                                  //Text(formattedDate.format(DateTime.parse(date[index]['deliveryDate']))),
                                  //Text(date[index]['deliveryDate'],style: TextStyle(color: Colors.black),textAlign: TextAlign.center),
                                ],

                              ),

                            ),
                          ),
                          onTap:() {

                            Navigator.push(context,MaterialPageRoute(builder: (context) => SetDeliveryDate()));

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




