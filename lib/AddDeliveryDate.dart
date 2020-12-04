import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:freshcart_seller/AddProduct.dart';

import 'package:freshcart_seller/DeliveryDate.dart';import 'package:freshcart_seller/Home.dart';
import 'package:freshcart_seller/NetworkUtils/Prefmanager.dart';
import 'package:freshcart_seller/SetDeliveryDate.dart';
import 'package:freshcart_seller/ViewProfile.dart';
import 'package:freshcart_seller/main.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'DeliveryDate.dart';
import 'DeliveryDate.dart';
class AddDeliveryDate extends StatefulWidget {
  @override
  _AddDeliveryDate createState() => _AddDeliveryDate();
}


class _AddDeliveryDate extends State<AddDeliveryDate> {
  DateTime selectedDate = DateTime.now();
  var formattedDate = new DateFormat('dd-MM-yyyy');
  void initState(){
    super.initState();
    DeliveryDate();


  }

 bool pro=true;
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

            title: Text("Delivery Date"),
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
                  padding: EdgeInsets.all(10),
                  height: 300.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                          'https://black.bird.eu/media/contenttype/blog/cache/640x/estimated-delivery-date-for-magento_3.png'),
                      fit: BoxFit.contain,
                    ),
                    //shape: BoxShape.circle,
                  ),

                  //child:Text("Delivery Date", style: TextStyle(fontSize: 18,color:Colors.black)),
                ),
                // SizedBox(
                //   height: 10,
                // ),
                Container(
                  padding: EdgeInsets.all(20),
                  child: GridView.count(
                    childAspectRatio:0.45,

                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisCount: 3 ,

                    children: List.generate(date.length,(index){
                      return Container(
                        height: MediaQuery.of(context).size.height/2,
                        child: Card(

                          child: Column(

                            children: [
                              SizedBox(
                                height: 50,

                              ),
                              Icon(
                                Icons.category,
                                size: 80,
                                color: Colors.green,
                              ),
                              //Icon(IconData(int.parse(listcat[index]["flutterIcon"]),fontFamily: "MaterialIcons"),color: Colors.blue),

                              SizedBox(
                                height: 10,
                              ),
                              Text(date[index]['category']['name'],style: TextStyle(color: Colors.black),textAlign: TextAlign.center),
                              SizedBox(
                                height: 10,
                              ),
                              date[index]['deliveryDate']==null?SizedBox.shrink():Text(formattedDate.format(DateTime.parse(date[index]['deliveryDate']))),
                              //Text(date[index]['deliveryDate'],style: TextStyle(color: Colors.black),textAlign: TextAlign.center),
                              date[index]['deliveryDate']==null?
                              RaisedButton(
                                textColor: Colors.red,
                                   color: Colors.green,
                                padding: EdgeInsets.all(16),
                                child: Text('Add delivery date',style:TextStyle(fontSize: 14.0,fontWeight: FontWeight.bold)),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                onPressed: () {
                                  Navigator.push(context,MaterialPageRoute(builder: (context)=> DeliveryDates(date[index]['category']['name'],date[index]['category']['_id'])));
                                },
                              ):selectedDate.difference(DateTime.parse(date[index]['deliveryDate'])).inDays>0?
                        RaisedButton(
                          textColor: Colors.red,
                          color: Colors.green,
                                padding: EdgeInsets.all(16),

                                child: Text('Update delivery date',style:TextStyle(fontSize: 14.0,fontWeight: FontWeight.bold)),

                                onPressed: () {
                                  print(selectedDate);
                                  print(date[index]['deliveryDate']);
                                  print(formattedDate.format(selectedDate).compareTo(date[index]['deliveryDate']));
                                  Navigator.push(context,MaterialPageRoute(builder: (context) => SetDeliveryDate(date[index]['category']['name'],date[index]['deliveryDate'],date[index]['category']['_id'])));
                                },
                              )
                            :SizedBox.shrink()
                            ],


                          ),


                        ),
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




