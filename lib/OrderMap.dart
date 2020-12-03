import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:freshcart_seller/Home.dart';
import 'package:freshcart_seller/NetworkUtils/Prefmanager.dart';
import 'package:freshcart_seller/PurchaseRejected.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class OrderMap extends StatefulWidget {
  final  details;
  OrderMap(this.details);
  @override
  _OrderMap createState() => new _OrderMap();
}

class _OrderMap extends State<OrderMap> {
  var formattedDate = new DateFormat('dd-MM-yyyy');

  TextEditingController priceController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    print(widget.details);
    for(int i=0;i<widget.details['orderdata'].length;i++) {
      _markers.add(
          Marker(
            markerId: MarkerId("$i"),
            position: LatLng(widget
                .details['orderdata'][i]['deliveryaddress']['location'][0],
                widget
                    .details['orderdata'][i]['deliveryaddress']['location'][1]),
            //icon: pinLocationIcon
          )
      );
    }
    //print(widget.details["deliveryaddress"]);


    // lat=widget.lat;
    // lon=widget.lon;
    // print(lat);
    // print(lon);
  }
  BitmapDescriptor pinLocationIcon;
  Set<Marker> _markers = Set();
  Completer<GoogleMapController> _controller = Completer();
  bool approved=false;
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
          title: Text("Orders",style: TextStyle(color: Colors.white,fontSize: 20),),
          centerTitle: true,
          // iconTheme: IconThemeData(
          // color: Colors.black
          // ),
          elevation: 0.0,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back,color:Colors.black),
            onPressed: () => Navigator.of(context).pop(true),
          ),
          backgroundColor: Colors.green,
          //elevation: 0.0,
          actions: <Widget>[
          ]

      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height:250,
              child: GoogleMap(
                myLocationEnabled: true,
                markers: _markers,
                mapType: MapType.hybrid,

                initialCameraPosition: CameraPosition(
                  target: LatLng(widget.details['orderdata'][0]['deliveryaddress']['location'][0],widget.details['orderdata'][0]['deliveryaddress']['location'][1]),
                  zoom: 14.4746,
                ),
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                  setState(() {

                  });

                },

              ),
            ),
            Container(
              height:MediaQuery.of(context).size.height-100 ,
              padding: new EdgeInsets.all(10.0),
                      child:Card(
                        child: InkWell(
                          child: new Container(
                            padding: new EdgeInsets.all(20.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 50,
                                  //color:Colors.grey,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          //Text("OrderDate:"),
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("OrderDate:"),
                                              Text(formattedDate.format(DateTime.parse(widget.details['orderdate']))),
                                            ],
                                          ),
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Total:"),
                                              //Text(widget.details[index]['total'].toString()),
                                            ],
                                          ),

                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Column(
                                          children:
                                          List.generate(widget.details['orderdata'].length, (k) {
                                            return Column(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Column(
                                                  children:
                                                  List.generate(
                                                      widget.details['orderdata'][k]['customer']
                                                          .length, (c) {
                                                    return new Column(
                                                      mainAxisAlignment: MainAxisAlignment
                                                          .spaceBetween,
                                                      children: <Widget>[
                                                        Column(
                                                            children:
                                                            List.generate(
                                                                widget.details['orderdata'][k]['product']
                                                                    .length, (
                                                                j) {
                                                              return Row(
                                                                children: [

                                                                  CircleAvatar(
                                                                    radius: 40.0,
                                                                    backgroundColor: Colors
                                                                        .white,
                                                                    backgroundImage: AssetImage(
                                                                        'Assets/product.jpg'),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 20,
                                                                  ),
                                                                  Text(
                                                                    "Product:",
                                                                    style: TextStyle(
                                                                        fontSize: 15,
                                                                        fontWeight: FontWeight
                                                                            .bold),),
                                                                  Expanded(
                                                                      flex: 2,
                                                                      child: Text(
                                                                        widget.details['orderdata'][k]['product'][j]['productname'],
                                                                        style: TextStyle(
                                                                            fontSize: 15,
                                                                            fontWeight: FontWeight
                                                                                .bold),
                                                                        maxLines: 2,
                                                                        overflow: TextOverflow
                                                                            .ellipsis,)),
                                                                  Text(
                                                                    "Quantity:",
                                                                    style: TextStyle(
                                                                        fontSize: 15,
                                                                        fontWeight: FontWeight
                                                                            .bold),),
                                                                  Text(
                                                                      widget.details['orderdata'][k]['quantity']
                                                                          .toString() +
                                                                          widget.details['orderdata'][k]['product'][j]['unit'],
                                                                      style: TextStyle(
                                                                          fontSize: 15,
                                                                          fontWeight: FontWeight
                                                                              .bold)
                                                                  ),


                                                                ],
                                                              );
                                                            })),

                                                        SizedBox(
                                                          height: 10,
                                                        ),

                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment
                                                              .start,
                                                          children: [
                                                            Text("Contact:",
                                                              style: TextStyle(
                                                                  fontWeight: FontWeight
                                                                      .bold,
                                                                  fontSize: 15),),
                                                          ],
                                                        ),

                                                        Row(
                                                          children: [
                                                            Expanded(
                                                                flex: 1,
                                                                child: Text(
                                                                    widget.details['orderdata'][k]['customer'][c]['phone'])
                                                            ),

                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                                flex: 1,
                                                                child: Text(
                                                                    widget.details['orderdata'][k]['customer'][c]['name'])
                                                            ),

                                                          ],
                                                        ),

                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment
                                                              .start,
                                                          children: [
                                                            Text(
                                                              "Delivery Address:",
                                                              style: TextStyle(
                                                                  fontWeight: FontWeight
                                                                      .bold,
                                                                  fontSize: 15),),
                                                          ],
                                                        ),

                                                        Row(
                                                          children: [
                                                            Expanded(
                                                                flex: 1,
                                                                child: Text(
                                                                    widget.details['orderdata'][k]['deliveryaddress']['fulladdress'])),

                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 40,
                                                        ),
                                                        widget.details['status']=='Approved'?
                                                        Column(
                                                            children:[
                                                              TextField(
                                                                controller: priceController,
                                                                //obscureText: true,
                                                                textAlign: TextAlign.left,
                                                                decoration: InputDecoration(
                                                                  border: InputBorder.none,
                                                                  hintText: 'PLEASE ENTER TOTAL PRICE',
                                                                  hintStyle: TextStyle(color: Colors.grey),
                                                                ),
                                                              ),
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                  MaterialButton(
                                                                      textColor: Colors.red,
                                                                      color: Colors.white,
                                                                      child: Text('Mark As Delivered',style: TextStyle(
                                                                          fontSize: 15,fontWeight: FontWeight.bold)),
                                                                      onPressed: ()  {

                                                                        SendData();
                                                                      }

                                                                  ),


                                                                ],
                                                              )]):SizedBox.shrink(),

                                                        SizedBox(
                                                          height: 10,
                                                        ),

                                                      ],
                                                    );
                                                  }
                                                  ),
                                                ),
                                              ],
                                            );
                                          }
                                          ),

                                        ),
                                      ),
                                    ]

                                ),

                              ],
                            ),
                          ),
                        ),
                      ),




            ),
          ],
        ),
      ),

    );
  }
  void SendData() async {
    var url = Prefmanager.baseurl +'/Purchase/deliver';
    var token = await Prefmanager.getToken();
    Map data = {
      "x-auth-token": token,
      "id": widget.details['_id'],
      "totalprice":priceController.text

    };

    print(data.toString());
    var body = json.encode(data);
    var response = await http.post(url, headers: {"Content-Type": "application/json", "x-auth-token": token},
        body: body);
    print(json.decode(response.body));
    if (json.decode(response.body)['status']) {
      Navigator.push(
          context, new MaterialPageRoute(
          builder: (context) => new AddProfile()));
    }
    Fluttertoast.showToast(
        msg: json.decode(response.body)['msg'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 20.0
    );
  }

}