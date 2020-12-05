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
            infoWindow: InfoWindow(
              //anchor : Offset(0.45, 0.8),

              title: 'Delivery Address',
              snippet: '${widget
                  .details['orderdata'][i]['deliveryaddress']['fulladdress']}',

            ),

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
              height:350,
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
        Card(
          elevation: 8.0,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                    height:10
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text("Ordered on "+formattedDate.format(DateTime.parse(widget.details['orderdate'].toString())),style: TextStyle(color:Colors.red,fontSize:12,fontWeight: FontWeight.bold),),
                      Spacer(),
                      widget.details['total']>0?
                      Text("Total price "+widget.details['total'].toString(),style: TextStyle(color:Colors.red,fontSize:12,fontWeight: FontWeight.bold),):SizedBox.shrink()

                    ],
                  ),
                ),


                Column(
                  children:
                  List.generate(widget.details['orderdata'].length,(p){
                    return Column(
                        children: [


                          Row(
                            children: [
                              SizedBox(
                                width: 5,
                              ),

                              Expanded(
                                child: new Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children:[
                                    Container(
                                      padding: EdgeInsets.all(8),
                                      child: ClipRRect(
                                        borderRadius:BorderRadius.circular(15.0),
                                        child:FadeInImage(
                                          // image:NetworkImage(
                                          //     Prefmanager.baseurl+"/document/get/"+profile[index]["icon"]) ,
                                          image: AssetImage('Assets/product.jpg'),
                                          placeholder: AssetImage('Assets/product.jpg'),
                                          fit: BoxFit.fill,
                                          width:70,
                                          height:70,
                                        ),
                                      ),
                                    ),
                                    Expanded(

                                      child:Column(
                                          children:
                                          List.generate(widget.details['orderdata'][p]['product'].length,(k){
                                            return Column(
                                                children:[
                                                  SizedBox(
                                                    height: 5,
                                                  ),

                                                  Row(
                                                    children:[
                                                      Text(widget.details['orderdata'][p]['product'][k]['productname'],style:TextStyle(fontSize:16,fontWeight: FontWeight.bold,)),
                                                      // Expanded(flex:1,child: Text(profile[index]['bid']['name'],style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),)),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height:10,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text("Quantity : "+widget.details['orderdata'][p]['quantity'].toString()+widget.details['orderdata'][p]['product'][k]['unit'],style: TextStyle(color:Colors.grey,fontSize:12,fontWeight: FontWeight.bold),),

                                                    ],
                                                  ),
                                                  SizedBox(
                                                      height:10
                                                  ),
                                                  Row(
                                                      children:[
                                                        widget.details['orderdata'][p]['status']=='Delivered'&&widget.details['orderdata'][p]['totalprice']!=null?
                                                        Text("Price : "+widget.details['orderdata'][p]['totalprice'].toString(),style: TextStyle(color:Colors.grey,fontSize:12,fontWeight: FontWeight.bold),):SizedBox.shrink()
                                                      ]
                                                  ),

                                                  SizedBox(
                                                    height:5,
                                                  ),

                                                ]
                                            );
                                          })
                                      ),
                                    ),
                                    Column(
                                        children:
                                        List.generate(widget.details['orderdata'][p]['customer'].length,(c){
                                          return Column(
                                              children:[
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Row(
                                                  children: [
                                                    Text("Customer Details:",style: TextStyle(fontWeight: FontWeight.bold),),
                                                  ],
                                                ),

                                                Row(
                                                  children:[
                                                    Text("Name:"+widget.details['orderdata'][p]['customer'][c]['name'],style:TextStyle(fontSize:12,fontWeight: FontWeight.bold,color: Colors.grey)),
                                                    // Expanded(flex:1,child: Text(profile[index]['bid']['name'],style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),)),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height:5,
                                                ),
                                                Row(
                                                  children: [
                                                    Text("Phone:"+widget.details['orderdata'][p]['customer'][c]['phone'],style: TextStyle(color:Colors.grey,fontSize:12,fontWeight: FontWeight.bold),),

                                                  ],
                                                ),
                                                SizedBox(
                                                    height:10
                                                ),


                                                SizedBox(
                                                  height:5,
                                                ),

                                              ]
                                          );
                                        })
                                    ),
                                  ],
                                ),

                              ),

                            ],
                          ),
                          Container(
                            color:Colors.grey[50],
                            padding:EdgeInsets.all(8.0),
                            width:MediaQuery.of(context).size.width,
                            //width:double.infinity,
                            child:Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:CrossAxisAlignment.start,
                                    mainAxisAlignment:MainAxisAlignment.start,
                                    children: [
                                      Text("Delivery Address",style: TextStyle(color:Colors.grey,fontSize:12,fontWeight: FontWeight.bold),),
                                      SizedBox(
                                          height:10
                                      ),

                                      Expanded(
                                        flex:0,
                                        child: Text(
                                          widget.details['orderdata'][p]['deliveryaddress']['fulladdress'],style: TextStyle(color:Colors.black,fontSize:12),),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),

                          ),
                          Container(
                            color:Colors.grey[50],
                            padding:EdgeInsets.all(8.0),
                            width:MediaQuery.of(context).size.width,
                            //width:double.infinity,
                            child:Row(
                              children: [
                                Column(
                                  crossAxisAlignment:CrossAxisAlignment.start,
                                  mainAxisAlignment:MainAxisAlignment.start,
                                  children: [
                                    Text("Order status",style: TextStyle(color:Colors.grey,fontSize:12,fontWeight: FontWeight.bold),),
                                    SizedBox(
                                        height:10
                                    ),

                                    if(widget.details['orderdata'][p]['status']=='Pending')
                                      Text("Order awaiting Approval",style: TextStyle(color:Colors.orange,fontSize:12,fontWeight: FontWeight.bold),),
                                    if(widget.details['orderdata'][p]['status']=='Approved')
                                      Text("Order approved ",style: TextStyle(color:Colors.orange,fontSize:12,fontWeight: FontWeight.bold),),
                                    if(widget.details['orderdata'][p]['status']=='Rejected')
                                      Text("Order rejected  due to "+widget.details['orderdata'][p]['rejectreason'],style: TextStyle(color:Colors.red,fontSize:12,fontWeight: FontWeight.bold),),
                                    // Text(orders[index]['orderdata'][p]['rejectreason'].toString(),style: TextStyle(color:Colors.red,fontSize:12,fontWeight: FontWeight.bold),),
                                    if(widget.details['orderdata'][p]['status']=='Delivered')
                                      Text("Delivered on "+formattedDate.format(DateTime.parse(widget.details['orderdata'][p]['deliverydate'])),style: TextStyle(color:Colors.green,fontSize:12,fontWeight: FontWeight.bold),)
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            //color:Colors.grey,
                            child: Card(
                              //color: Colors.transparent,
                              elevation: 0.6,
                              child: widget.details['orderdata'][p]['status']=='Approved'?
                              Column(
                                  children:[
                                    TextField(
                                      controller: priceController,
                                      //obscureText: true,
                                      textAlign: TextAlign.left,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'PLEASE ENTER TOTAL PRICE',
                                        hintStyle: TextStyle(color: Colors.black),
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

                                              SendData(widget.details['orderdata'][p]['_id']);
                                            }

                                        ),


                                      ],
                                    ),
                                  ]
                              ):SizedBox.shrink(),
                            ),
                          ),
                        ]

                    );

                  }
                  ),


                ),


              ]

          ),

        ),

          ],
        ),
      ),

    );
  }
  void SendData(_id) async {
    var url = Prefmanager.baseurl +'/Purchase/deliver';
    var token = await Prefmanager.getToken();
    Map data = {
      "x-auth-token": token,
      "id": _id,
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