import 'dart:convert';
import 'package:freshcart_seller/NetworkUtils/Prefmanager.dart';
import 'package:freshcart_seller/RequestMap.dart';
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
  int page=1,count=6;
  List purchase=[] ;
  void PurchaseView () async {
    setState(() {
      progress=true;
    });
    var url = Prefmanager.baseurl+'/Purchase/pending?count='+count.toString()+'&page='+page.toString();
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
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,

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
          purchase.length==0?
          Container(
            height: 200,
            width: double.infinity,
            //color: Colors.grey,
            alignment: Alignment.bottomCenter,
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.all(30),
            child: Text("No Purchase Requst Found",
                style: TextStyle(fontSize: 20)),
          )

          //Text("No Purchase Request Found",style: TextStyle(fontWeight:FontWeight.bold,fontSize: 18),)
              :Column(
              children: [
                Expanded(
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollInfo) {
                      if (!pageLoading && scrollInfo.metrics.pixels ==
                          scrollInfo.metrics.maxScrollExtent) {
                        print(total);
                        print(purchase.length);
                        if(purchase.length>total){
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
                                                        Text(purchase[index]['product']['productname'],
                                                          style: TextStyle(
                                                              fontSize: 18,fontWeight: FontWeight.bold)),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text("Quantity:"+purchase[index]['quantity'].toString()+purchase[index]['product']['unit'],
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
                                                          purchase[index]['customer']['name'],style: TextStyle(color:Colors.black,fontSize:14),),
                                                        Text(
                                                          purchase[index]['customer']['phone'],style: TextStyle(color:Colors.black,fontSize:14),),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),

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
                                                        Text("Delivery Address",style: TextStyle(color:Colors.indigo,fontSize:15,fontWeight: FontWeight.bold),),
                                                        SizedBox(
                                                            height:10
                                                        ),

                                                        Expanded(
                                                          flex:0,
                                                          child: Text(
                                                            purchase[index]['deliveryaddress']['fulladdress'],style: TextStyle(color:Colors.black,fontSize:14),),
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

                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                MaterialButton(
                                                    textColor: Colors.red,
                                                    color: Colors.white,
                                                    child: Text('View in Map',style: TextStyle(
                                                        fontSize: 15,fontWeight: FontWeight.bold)),
                                                    onPressed: ()  {

                                                      Navigator.push(
                                                          context, new MaterialPageRoute(
                                                          builder: (context) => RequestMap(purchase[index])));

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

