import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:freshcart_seller/Home.dart';
import 'package:freshcart_seller/NetworkUtils/Prefmanager.dart';
import 'package:freshcart_seller/PurchaseRejected.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class RequestMap extends StatefulWidget {
  final  details;
  RequestMap(this.details);
  @override
  _RequestMap createState() => new _RequestMap();
}

class _RequestMap extends State<RequestMap> {


 @override
  void initState() {
    super.initState();
    print(widget.details);
    print(widget.details['deliveryaddress']['location'][0]);
    _markers.add(
        Marker(
            infoWindow: InfoWindow(
              title: 'Delivery Address',
              snippet: '${widget
                  .details['deliveryaddress']['fulladdress']}',

            ),
          markerId: MarkerId("fghh"),
          position:LatLng(widget.details['deliveryaddress']['location'][0],widget.details['deliveryaddress']['location'][1]),
          icon: pinLocationIcon
        )
    );
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
          title: Text("Purchase Request",style: TextStyle(color: Colors.white,fontSize: 20),),
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
              height:300,
              child: GoogleMap(
                mapType: MapType.hybrid,
                initialCameraPosition: CameraPosition(
                  target: LatLng(widget.details['deliveryaddress']['location'][0],widget.details['deliveryaddress']['location'][1]),
                  zoom: 14.4746,
                ),
                markers: _markers,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                  setState(() {

                  });
                },
              ),
            ),
            Container(
              padding: new EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: [
                            ClipRRect(
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
                            SizedBox(
                              width: 20,
                            ),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Text(widget.details['product']['productname'],
                                        style: TextStyle(
                                            fontSize: 18,fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text("Quantity:"+widget.details['quantity'].toString()+widget.details['product']['unit'],
                                        style: TextStyle(
                                            fontSize: 18,fontWeight: FontWeight.bold)),
                                  ],
                                ),

                              ],
                            ),




                          ],
                        ),

                        SizedBox(
                          height: 10,
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
                                    Text("Customer Details:",style: TextStyle(color:Colors.blue,fontSize:15,fontWeight: FontWeight.bold),),
                                    SizedBox(
                                        height:10
                                    ),
                                    Text(
                                      widget.details['customer']['name'],style: TextStyle(color:Colors.black,fontSize:14),),
                                    Text(
                                      widget.details['customer']['phone'],style: TextStyle(color:Colors.black,fontSize:14),),
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
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:CrossAxisAlignment.start,
                                  mainAxisAlignment:MainAxisAlignment.start,
                                  children: [
                                    Text("Delivery Address",style: TextStyle(color:Colors.indigo,fontSize:15,fontWeight: FontWeight.bold),),
                                    SizedBox(
                                        height:10
                                    ),

                                    Expanded(
                                      flex:0,
                                      child: Text(
                                        widget.details['deliveryaddress']['fulladdress'],style: TextStyle(color:Colors.black,fontSize:14),),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),

                        ),



                        SizedBox(
                          height: 20,
                        ),


                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            MaterialButton(
                                textColor: Colors.red,
                                color: Colors.white,
                                child: Text('Approve',style: TextStyle(
                                    fontSize: 15,fontWeight: FontWeight.bold)),
                                onPressed: ()  {
                                  approved=true;
                                  SendData();
                                }

                            ),
                            MaterialButton(
                                textColor: Colors.red,
                                color: Colors.white,
                                child: Text('Reject',style: TextStyle(
                                    fontSize: 15,fontWeight: FontWeight.bold)),
                                onPressed: ()  {
                                  approved=false;
                                  Navigator.push(
                                      context, new MaterialPageRoute(
                                      builder: (context) => PurchaseRejected(widget.details['_id'],approved)));

                                }

                            ),

                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),




                      ],
                    ),
                  ),
                ],
              ),

            )
          ],
                    ),
                  ),
    );

  }
  void SendData() async {
    var url = Prefmanager.baseurl +'/Purchase/Approve';
    var token = await Prefmanager.getToken();
    Map data = {
      "x-auth-token": token,
      "id": widget.details['_id'],
      "approve": approved
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