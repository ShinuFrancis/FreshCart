import 'dart:convert';
import 'package:freshcart_seller/NetworkUtils/Prefmanager.dart';
import 'package:freshcart_seller/RequestMap.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
class MyOrder extends StatefulWidget {

  @override
  _MyOrder createState() => new _MyOrder();
}


class _MyOrder extends State< MyOrder>{


  @override
  void initState() {
    super.initState();
    OrderView();


  }
  bool progress=false;

  int len,total;
  int page=1,count=10;
  List order=[] ;
  void OrderView () async {
    setState(() {
      progress=true;
    });
    var url = Prefmanager.baseurl+'/Purchase/myorders';
    var token = await Prefmanager.getToken();
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'x-auth-token':token
    };
    var response = await http.get(url,headers:requestHeaders);
    print(json.decode(response.body));
    if (json.decode(response.body)['status']) {
      total=json.decode(response.body)['count'];
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
              title: Text("My Orders",style: TextStyle(color: Colors.white,fontSize: 20),),
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
                Expanded(
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollInfo) {
                      if (!pageLoading && scrollInfo.metrics.pixels ==
                          scrollInfo.metrics.maxScrollExtent) {
                        print(total);
                        print(order.length);
                        if(total>order.length){
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
                                // onTap: ()async{
                                //   bool pro=await
                                //
                                //   Navigator.push(
                                //       context, new MaterialPageRoute(
                                //       builder: (context) => DetailProductView(product[index]['_id'])));
                                //   product.clear();
                                //   page =1;
                                //   ProductView();
                                //
                                // },

                                child: new Container(
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
                                                CircleAvatar(
                                                  radius: 40.0,
                                                  backgroundColor: Colors.white,
                                                  backgroundImage: AssetImage('Assets/green.png'),
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Text("Product:",style: TextStyle(
                                                    fontSize: 15,fontWeight: FontWeight.bold),),
                                                Expanded(
                                                    flex: 2,
                                                    child: Text(order[index]['product']['productname'],
                                                      style: TextStyle(
                                                          fontSize: 15,fontWeight: FontWeight.bold),
                                                      maxLines: 2,
                                                      overflow: TextOverflow
                                                          .ellipsis,)),
                                                Text("Quantity:",style: TextStyle(
                                                    fontSize: 15,fontWeight: FontWeight.bold),),
                                                Text(order[index]['quantity'].toString(),style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold)
                                                ),

                                              ],
                                            ),

                                            SizedBox(
                                              height: 10,
                                            ),

                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Text("Contact:",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                                              ],
                                            ),

                                            Row(
                                              children: [
                                                Expanded(
                                                    flex:1,
                                                    child: Text(order[index]['customer']['phone'])
                                                ),

                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                    flex:1,
                                                    child: Text(order[index]['customer']['name'])
                                                ),

                                              ],
                                            ),

                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Text("Delivery Address:",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                                              ],
                                            ),

                                            Row(
                                              children: [
                                                Expanded(
                                                    flex:1,
                                                    child: Text(order[index]['deliveryaddress']['fulladdress'])),

                                              ],
                                            ),



                                            SizedBox(
                                              height: 20,
                                            ),

                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                FlatButton(
                                                    textColor: Colors.green,
                                                    color: Colors.white,
                                                    child: Text('View in Map',style: TextStyle(
                                                        fontSize: 15,fontWeight: FontWeight.bold)),
                                                    onPressed: ()  {

                                                      // Navigator.push(
                                                      //     context, new MaterialPageRoute(
                                                      //     builder: (context) => RequestMap(order[index])));

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

