import 'dart:convert';
import 'package:freshcart_seller/NetworkUtils/Prefmanager.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
class PurchaseRequest extends StatefulWidget {

  @override
  _PurchaseRequest createState() => new _PurchaseRequest();
}


class _PurchaseRequest extends State<PurchaseRequest>{


  @override
  void initState() {
    super.initState();
    PurchaseView();


  }
  bool progress=false;

  int len,total;
  int page=1,count=10;
  List purchase=[] ;
  void PurchaseView () async {
    setState(() {
      progress=true;
    });
    var url = Prefmanager.baseurl+'/Purchase/pending';
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
        purchase.add(json.decode(response.body)['data'][i]);
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
          body:progress?Center( child: CircularProgressIndicator(),):
          Column(
              children: [
                Expanded(
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollInfo) {
                      if (!pageLoading && scrollInfo.metrics.pixels ==
                          scrollInfo.metrics.maxScrollExtent) {
                        print(total);
                        print(purchase.length);
                        if(total>purchase.length){
                          PurchaseView();
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

                        itemCount:purchase.length,
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
                                  padding: new EdgeInsets.all(10.0),

                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,

                                        children: [

                                          CircleAvatar(
                                            radius: 40.0,
                                            backgroundColor: Colors.white,
                                            backgroundImage: AssetImage('Assets/green.png'),
                                          ),

                                          new Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: <Widget>[
                                              Text(purchase[index]['product']['productname'],style: TextStyle(fontSize: 15)),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(purchase[index]['deliveryaddress']['state']),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              //Text(purchase[index]['deliveryaddress']['city']




                                              // Row(
                                              //   children: [
                                              //     //Text("Mobile::",style: TextStyle(fontSize: 20)),
                                              //     //Text(purchase[index]['quantity'],style: TextStyle(fontSize: 15)
                                              //     //),
                                              //   ],
                                              // ),
                                              // SizedBox(
                                              //   height: 10,
                                              // ),
                                              // Row(
                                              //   children: [
                                              //     //Text("Mobile::",style: TextStyle(fontSize: 20)),
                                              //     Text(purchase[index]['deliveryaddress']['state']
                                              //     ),
                                              //   ],
                                              // ),
                                              // SizedBox(
                                              //   height: 10,
                                              // ),
                                              // Row(
                                              //   children: [
                                              //     //Text("Mobile::",style: TextStyle(fontSize: 20)),
                                              //     Text(purchase[index]['deliveryaddress']['city']
                                              //     ),
                                              //   ],
                                              // ),
                                              // SizedBox(
                                              //   height: 10,
                                              // ),
                                              // Row(
                                              //   children: [
                                              //     //Text("Mobile::",style: TextStyle(fontSize: 20)),
                                              //     Text(purchase[index]['deliveryaddress']['fulladdress']
                                              //     ),
                                              //   ],
                                              // ),


                                            ],
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

