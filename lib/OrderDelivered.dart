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
class OrderDelivered extends StatefulWidget {

  @override
  _OrderDelivered createState() => new _OrderDelivered();
}


class _OrderDelivered extends State< OrderDelivered>{
  var formattedDate = new DateFormat('dd-MM-yyyy');


  @override
  void initState() {
    super.initState();
    OrderView();


  }
  bool progress=false;

  int len,total;
  int page=1,count=10;
  List order=[] ;
  // ignore: non_constant_identifier_names
  void OrderView () async {
    setState(() {
      progress=true;
    });
    var url = Prefmanager.baseurl+'/Purchase/groupedmyorders?status='+'Delivered''&count='+count.toString()+'&page='+page.toString();
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
      print(total);
      print(len);
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
              title: Text("Delivered Orders",style: TextStyle(color: Colors.white,fontSize: 20),),
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
          body:
          progress?Center( child: CircularProgressIndicator(),):

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
                          Navigator.pushReplacement(
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
                          Navigator.pushReplacement(
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
                          child: Text("Rejected"),
                        ),
                        onTap:(){
                          Navigator.pushReplacement(
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
                          child: Text("Delivered",style: TextStyle(color: Colors.red),),
                        ),
                        onTap:(){
                          Navigator.pushReplacement(
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
                  child: Text("You have not at delivered any products",
                      style: TextStyle(fontSize: 20)),
                )
                :Expanded(
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollInfo) {
                      if (!pageLoading && scrollInfo.metrics.pixels ==
                          scrollInfo.metrics.maxScrollExtent) {
                        print(total);
                        print(len);
                        print(order.length);
                        if(len>total){
                          OrderView();
                          setState(() {
                            pageLoading = true;
                          });
                        }
                        else{
                          setState(() {
                            print("No more Data");
                            pageLoading = false;
                          });
                        }


                      }
                      return true;
                    },

                      child: ListView.builder(
                          itemCount: order.length,
                          itemBuilder: (BuildContext context,int index){
                            return
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
                                            Text("Order Date "+formattedDate.format(DateTime.parse(order[index]['orderdate'].toString())),style: TextStyle(color:Colors.red,fontSize:12,fontWeight: FontWeight.bold),),
                                            Spacer(),
                                            order[index]['total']>0?
                                            Text("Total price "+order[index]['total'].toString(),style: TextStyle(color:Colors.red,fontSize:12,fontWeight: FontWeight.bold),):SizedBox.shrink()

                                          ],
                                        ),
                                      ),
                                      Column(
                                        children:
                                        List.generate(order[index]['orderdata'].length,(p){
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
                                                                List.generate(order[index]['orderdata'][p]['product'].length,(k){
                                                                  return Column(
                                                                      children:[
                                                                        SizedBox(
                                                                          height: 5,
                                                                        ),

                                                                        Row(
                                                                          children:[
                                                                            Text(order[index]['orderdata'][p]['product'][k]['productname'],style:TextStyle(fontSize:16,fontWeight: FontWeight.bold,)),
                                                                            // Expanded(flex:1,child: Text(profile[index]['bid']['name'],style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),)),
                                                                          ],
                                                                        ),
                                                                        SizedBox(
                                                                          height:10,
                                                                        ),
                                                                        Row(
                                                                          children: [
                                                                            Text("Quantity : "+order[index]['orderdata'][p]['quantity'].toString()+order[index]['orderdata'][p]['product'][k]['unit'],style: TextStyle(color:Colors.grey,fontSize:12,fontWeight: FontWeight.bold),),

                                                                          ],
                                                                        ),
                                                                        SizedBox(
                                                                            height:10
                                                                        ),
                                                                        Row(
                                                                            children:[
                                                                              order[index]['orderdata'][p]['status']=='Delivered'&&order[index]['orderdata'][p]['totalprice']!=null?
                                                                              Text("Price : "+order[index]['orderdata'][p]['totalprice'].toString(),style: TextStyle(color:Colors.grey,fontSize:12,fontWeight: FontWeight.bold),):SizedBox.shrink()
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
                                                              List.generate(order[index]['orderdata'][p]['customer'].length,(c){
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
                                                                          Text("Name:"+order[index]['orderdata'][p]['customer'][c]['name'],style:TextStyle(fontSize:12,fontWeight: FontWeight.bold,color: Colors.grey)),
                                                                          // Expanded(flex:1,child: Text(profile[index]['bid']['name'],style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),)),
                                                                        ],
                                                                      ),
                                                                      SizedBox(
                                                                        height:5,
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          Text("Phone: "+order[index]['orderdata'][p]['customer'][c]['phone'],style: TextStyle(color:Colors.grey,fontSize:12,fontWeight: FontWeight.bold),),

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
                                                            Text("Delivery Address",style: TextStyle(color:Colors.indigo,fontSize:12,fontWeight: FontWeight.bold),),
                                                            SizedBox(
                                                                height:10
                                                            ),

                                                            Expanded(
                                                              flex:0,
                                                              child: Text(
                                                                order[index]['orderdata'][p]['deliveryaddress']['fulladdress'],style: TextStyle(color:Colors.black,fontSize:12),),
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

                                                          if(order[index]['orderdata'][p]['status']=='Pending')
                                                            Text("Order awaiting Approval",style: TextStyle(color:Colors.orange,fontSize:12,fontWeight: FontWeight.bold),),
                                                          if(order[index]['orderdata'][p]['status']=='Approved')
                                                            Text("Order approved ",style: TextStyle(color:Colors.orange,fontSize:12,fontWeight: FontWeight.bold),),
                                                          if(order[index]['orderdata'][p]['status']=='Rejected')
                                                            Text("Order rejected  due to "+order[index]['orderdata'][p]['rejectreason'],style: TextStyle(color:Colors.red,fontSize:12,fontWeight: FontWeight.bold),),
                                                          // Text(orders[index]['orderdata'][p]['rejectreason'].toString(),style: TextStyle(color:Colors.red,fontSize:12,fontWeight: FontWeight.bold),),
                                                          if(order[index]['orderdata'][p]['status']=='Delivered')
                                                            Text("Delivered on "+formattedDate.format(DateTime.parse(order[index]['orderdata'][p]['deliverydate'])),style: TextStyle(color:Colors.green,fontSize:12,fontWeight: FontWeight.bold),)
                                                        ],
                                                      )
                                                    ],
                                                  ),

                                                ),

                                              ]
                                          );
                                        }
                                        ),

                                      ),
                                      Container(
                                        child:Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .center,
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

                                      ),
                                    ]

                                ),


                              );

                          }
                      )
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

