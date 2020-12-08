import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:freshcart_seller/AddProduct.dart';
import 'package:freshcart_seller/AddSaleLocation.dart';

import 'package:freshcart_seller/DeliveryDate.dart';import 'package:freshcart_seller/Home.dart';
import 'package:freshcart_seller/NetworkUtils/Prefmanager.dart';
import 'package:freshcart_seller/SetDeliveryDate.dart';
import 'package:freshcart_seller/UpdateSaleLocation.dart';
import 'package:freshcart_seller/ViewProfile.dart';
import 'package:freshcart_seller/main.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'DeliveryDate.dart';
import 'DeliveryDate.dart';
class SalesLocation extends StatefulWidget {
  @override
  _SalesLocation createState() => _SalesLocation();
}


class _SalesLocation extends State<SalesLocation> {

  void initState(){
    super.initState();
    SalesLocation();


  }

  bool pro=true;
  var location=[];
  void  SalesLocation() async {
    print("pro");
    var url =  Prefmanager.baseurl+'/user/getsalelocations';
    var token = await Prefmanager.getToken();
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'x-auth-token':token
    };
    var response = await http.get(url,headers:requestHeaders);
    print(json.decode(response.body));
    if (json.decode(response.body)['status']) {
      location = json.decode(response.body)['data'];

      //print(date[0]['deliveryDate']);
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
    pro=false;
  }


  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async => false,

      child: Scaffold(
        appBar: AppBar(

            title: Text("Sales Location"),
            centerTitle: true,

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


              children: <Widget>[


                pro?Center( child: CircularProgressIndicator(),):
                SizedBox(
                  height: 30,
                ),
                Container(
                  height: 600,
                  padding: EdgeInsets.all(20),
                  child: ListView.builder(

                    //childAspectRatio:0.25,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    //physics: NeverScrollableScrollPhysics(),
                    //crossAxisCount: 3 ,
                  itemCount: location.length,
                    itemBuilder: (BuildContext context, int index) {

                   // },
                   // children: List.generate(location.length,(index){
                      return Container(
                        height:300,
                        child: Card(

                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,

                            children: [
                              SizedBox(
                                height: 20,

                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,

                                children: [
                                  Container(
                                    color:Colors.grey[50],
                                    padding: EdgeInsets.all(10),
                                    child: ClipRRect(
                                      borderRadius:BorderRadius.circular(15.0),
                                      child: Icon(
                                        Icons.category,
                                        size: 80,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text("Category:"+location[index]['category']['name'],style: TextStyle(color: Colors.red,fontSize: 16,fontWeight: FontWeight.bold)),
                                ],
                              ),
                              //Icon(IconData(int.parse(listcat[index]["flutterIcon"]),fontFamily: "MaterialIcons"),color: Colors.blue),

                              SizedBox(
                                height: 2,
                              ),
                              //Text(location[index]['category']['name'],style: TextStyle(color: Colors.black),textAlign: TextAlign.center),

                              //location[index]['seller']['salelocations']==null?SizedBox.shrink():Text(formattedDate.format(DateTime.parse(date[index]['deliveryDate']))),
                              //Text(date[index]['deliveryDate'],style: TextStyle(color: Colors.black),textAlign: TextAlign.center),
                               location[index]['salelocations']==null||location[index]['salelocations'].isEmpty?
                              RaisedButton(
                                textColor: Colors.red,
                                color: Colors.green,
                                padding: EdgeInsets.all(16),
                                child: Text('Add Sales Location',style:TextStyle(fontSize: 14.0,fontWeight: FontWeight.bold)),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                onPressed: () {
                                  Navigator.push(context,MaterialPageRoute(builder: (context)=>AddSaleLocation(location[index]['category']['_id'])));
                                },
                              ):
                                   Container(
                                     padding: EdgeInsets.all(5),
                                     color: Colors.grey[50],
                                     child: Column(
                                       mainAxisAlignment: MainAxisAlignment.start,
                                       crossAxisAlignment: CrossAxisAlignment.center,
                                       children: [
                                         Text("Sale Locations",textAlign: TextAlign.left,style:TextStyle(fontSize: 14.0,fontWeight: FontWeight.bold,color: Colors.indigo)),
                                         Container(
                                           padding: EdgeInsets.all(10),
                                         height: 90,
                                         child: Column(
                                      children:
                                     List.generate(location[index]['salelocations'].length,(c){
                                  return Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                Text(location[index]['salelocations'][c]['city'],style: TextStyle(color: Colors.black),textAlign: TextAlign.center),


                                  ],
                               );
                               }
                      ),
                                         ),
                                       ),
                              RaisedButton(
                                textColor: Colors.red,
                                color: Colors.green,
                                padding: EdgeInsets.all(16),

                                child: Text('Update Sales Location',style:TextStyle(fontSize: 14.0,fontWeight: FontWeight.bold,)),

                                onPressed: () {
                                  //showAlertDialog();


                                  Navigator.push(context,MaterialPageRoute(builder: (context) => UpdateSaleLocation(location[index]['category']['_id'])));
                                },
                              )
                                       ]
                      ),

                                   ),
                          ]
                      ),

                        ),

                      );


                    },
                  ),
                ),


              ]

          ),
        ),
      ),
    );
  }



}




