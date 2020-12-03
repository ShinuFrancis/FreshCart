import 'dart:convert';
import 'package:freshcart_seller/MyOrder.dart';
import 'package:freshcart_seller/NetworkUtils/Prefmanager.dart';
import 'package:freshcart_seller/OrderApproved.dart';
import 'package:freshcart_seller/OrderDelivered.dart';
import 'package:freshcart_seller/OrderMap.dart';
import 'package:freshcart_seller/OrderRejected.dart';
import 'package:freshcart_seller/RequestMap.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
class OrderRejected extends StatefulWidget {

  @override
  _OrderRejected createState() => new _OrderRejected();
}


class _OrderRejected extends State< OrderRejected>{
  var formattedDate = new DateFormat('dd-MM-yyyy');


  @override
  void initState() {
    super.initState();
    OrderView();


  }
  bool progress=false;

  int len,total;
  int page=1,count=5;
  List order=[] ;
  void OrderView () async {
    setState(() {
      progress=true;
    });
    var url = Prefmanager.baseurl+'/Purchase/groupedmyorders?status='+'Rejected''&count='+count.toString()+'&page='+page.toString();
    var token = await Prefmanager.getToken();
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'x-auth-token':token,




  };
    print(requestHeaders.toString());
    var response = await http.get(url,headers:requestHeaders);
    print(json.decode(response.body));
    if (json.decode(response.body)['status']) {
      total=json.decode(response.body)['count'];
      len=json.decode(response.body)['pages'];
      for(int i=0;i<json.decode(response.body)['data'].length;i++)
        order.add(json.decode(response.body)['data'][i]);
      page++;
    }
    else
      Fluttertoast.showToast(
        msg: json.decode(response.body)['msg'],
        backgroundColor: Colors.grey,
        textColor: Colors.black,
      );
    progress=false;
    pageLoading =false;
    setState(() {

    });

  }
  bool pageLoading = false;


  @override
  Widget build(BuildContext context) {

    return  WillPopScope(
      onWillPop: ()async=>false,
      child: Scaffold(
          appBar: AppBar(
              title: Text("Rejected Orders",style: TextStyle(color: Colors.white,fontSize: 20),),
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
          body:progress?Center( child: CircularProgressIndicator(),):

          Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 15),
                  height:50,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      GestureDetector(
                        child:Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width / 4,
                          margin: const EdgeInsets.only(right: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: Colors.white,
                          ),
                          child: Text("All"),
                        ),
                        onTap:(){
                          Navigator.push(
                              context, new MaterialPageRoute(
                              builder: (context) => new MyOrder()));
                        },
                      ),
                      GestureDetector(
                        child:Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width / 3,
                          margin: const EdgeInsets.only(right: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: Colors.white,
                          ),
                          child: Text("Approved"),
                        ),
                        onTap:(){
                          Navigator.push(
                              context, new MaterialPageRoute(
                              builder: (context) => new OrderApproved()));
                        },
                      ),
                      GestureDetector(
                        child:Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width / 3,
                          margin: const EdgeInsets.only(right: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: Colors.white,
                          ),
                          child: Text("Rejected",style: TextStyle(color: Colors.red),),
                        ),
                        onTap:(){
                          Navigator.push(
                              context, new MaterialPageRoute(
                              builder: (context) => new OrderRejected()));
                        },
                      ),
                      GestureDetector(
                        child:Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width / 3,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: Colors.white,
                          ),
                          child: Text("Delivered"),
                        ),
                        onTap:(){
                          Navigator.push(
                              context, new MaterialPageRoute(
                              builder: (context) => new OrderDelivered()));
                        },
                      ),

                    ],
                  ),


                ),
                order.length==0?
                Container(
                  height: 200,
                  width: double.infinity,
                  //color: Colors.grey,
                  alignment: Alignment.bottomCenter,
                  margin: EdgeInsets.all(20),
                  padding: EdgeInsets.all(30),
                  child: Text("No Rejected Request",
                      style: TextStyle(fontSize: 20)),
                )
                :Expanded(
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollInfo) {
                      if (!pageLoading && scrollInfo.metrics.pixels ==
                          scrollInfo.metrics.maxScrollExtent) {
                        print(total);
                        print(order.length);
                        if(total>len){
                          OrderView();
                          setState(() {
                            pageLoading = true;
                          });
                        }
                        else{
                          setState(() {
                            pageLoading = false;
                          });
                        }


                      }
                      return true;
                    },

                    child: ListView.builder(

                        itemCount:order.length,
                        itemBuilder:(BuildContext context,int index) {

                          return
                            Card(
                              child: InkWell(
                                child: new Container(
                                  padding: new EdgeInsets.all(20.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height:50,
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
                                                    Text(formattedDate.format(DateTime.parse(order[index]['orderdate']))),
                                                  ],
                                                ),
                                                order[index]['total']>0?
                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text("Total:"),
                                                    Text(order[index]['total'].toString()),
                                                  ],
                                                ):SizedBox.shrink(),

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
                                                List.generate(order[index]['orderdata'].length, (k) {
                                                  return Column(
                                                    mainAxisAlignment: MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      Column(
                                                        children:
                                                        List.generate(
                                                            order[index]['orderdata'][k]['customer']
                                                                .length, (c) {
                                                          return new Column(
                                                            mainAxisAlignment: MainAxisAlignment
                                                                .spaceBetween,
                                                            children: <Widget>[
                                                              Column(
                                                                  children:
                                                                  List.generate(
                                                                      order[index]['orderdata'][k]['product']
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
                                                                              order[index]['orderdata'][k]['product'][j]['productname'],
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
                                                                            order[index]['orderdata'][k]['quantity']
                                                                                .toString() +
                                                                                order[index]['orderdata'][k]['product'][j]['unit'],
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
                                                                          order[index]['orderdata'][k]['customer'][c]['phone'])
                                                                  ),

                                                                ],
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Expanded(
                                                                      flex: 1,
                                                                      child: Text(
                                                                          order[index]['orderdata'][k]['customer'][c]['name'])
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
                                                                          order[index]['orderdata'][k]['deliveryaddress']['fulladdress'])),

                                                                ],
                                                              ),
                                                              Column(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                    children: [
                                                                      Text("OrderStatus:"),
                                                                      Text(
                                                                        order[index]['orderdata'][k]['status'],style: TextStyle(color: Colors.red),)

                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                              Column(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                    children: [
                                                                      Text("Reject Reason:"),
                                                                      Text(
                                                                        order[index]['orderdata'][k]['rejectreason'],style: TextStyle(color: Colors.red),)

                                                                    ],
                                                                  ),
                                                                ],
                                                              ),



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
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .start,
                                        children: [
                                          MaterialButton(
                                              textColor: Colors
                                                  .red,
                                              color: Colors
                                                  .white,
                                              child: Text(
                                                  'View in Map',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight: FontWeight
                                                          .bold)),
                                              onPressed: () {
                                                Navigator
                                                    .push(
                                                    context,
                                                    new MaterialPageRoute(
                                                        builder: (
                                                            context) =>
                                                            OrderMap(
                                                                order[index])));
                                              }

                                          ),

                                        ],
                                      ),

                                    ],
                                  ),
                                ),
                              ),
                            );


                        }
                    ),
                  ),
                ),
                Container(
                  height: pageLoading ? 50.0 : 0,
                  color: Colors.transparent,
                  child: Center(
                    child: new CircularProgressIndicator(),
                  ),
                ),
              ]
          )
      ),
    );





  }

}

