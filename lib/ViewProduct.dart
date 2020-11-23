import 'dart:convert';

import 'package:freshcart_seller/NetworkUtils/Prefmanager.dart';
import 'package:freshcart_seller/ProductListView.dart';
import 'package:freshcart_seller/ViewCategory.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';



class ViewProduct extends StatefulWidget {
  final String id;
  ViewProduct(this.id);

  @override
  _ViewProduct createState() => new _ViewProduct();
}

//State is information of the application that can change over time or when some actions are taken.
class _ViewProduct extends State<ViewProduct>{


  @override
  void initState() {
    super.initState();
    ProductView();

  }
  bool progress=false;

  int len,total;
  int page=1,count=5;
  List product=[] ;
  void ProductView () async {
  setState(() {
  progress=true;
  });
  var url = Prefmanager.baseurl +'/product/all?category='+widget.id +'&count='+count.toString()+'&page='+page.toString();
  print("ghjkjklk");
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
  product.add(json.decode(response.body)['data'][i]);
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

  return  Scaffold(
  appBar: AppBar(
  title: Text("Product List",style: TextStyle(color: Colors.blue,fontSize: 20),),
  centerTitle: true,
  // iconTheme: IconThemeData(
  // color: Colors.black
  // ),
      elevation: 0.0,
      leading: new IconButton(
        icon: new Icon(Icons.arrow_back,color:Colors.black12),
        onPressed: () {
          Navigator.push(
              context, new MaterialPageRoute(
              builder: (context) => new ViewCategory()));
        }
      ),
  backgroundColor: Colors.white,
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
  print(product.length);
  if(total>product.length){
  ProductView();
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

  itemCount:product.length,
  itemBuilder:(BuildContext context,int index) {

  return
  Column(
  children: [


  Card(
  child: InkWell(

  child: new Container(

  padding: new EdgeInsets.all(10.0),

  child: Row(
  children: [
  // Container(
  // padding: EdgeInsets.all(20),
  // // alignment: Alignment.center,
  // child: ClipRRect(
  // borderRadius: BorderRadius.circular(55.0),
  // child: FadeInImage(
  //
  // //image: NetworkImage(Prefmanager.baseurl+"/document/get/"+product[index]["icon"]),
  // placeholder: AssetImage("Assets/sigup.png"),
  // fit: BoxFit.cover,
  // width:80,
  // height: 80,
  //
  // ),
  // ),
  // ),
    Container(
      padding: EdgeInsets.all(20),
      // alignment: Alignment.center,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(70.0),
        child: FadeInImage(

          image: NetworkImage(
              "https://scitechdaily.com/images/Twain-Betta-Fish.jpg"),
          placeholder: AssetImage(
              "Assets/sigup.png"),
          fit: BoxFit.cover,
          width: 50,
          height: 50,

        ),
      ),
    ),

  Expanded(
  flex: 1,
  child: new Column(
  children: <Widget>[

  Row(
  children: [
  Expanded(
  flex: 1,
  child: Text(product[index]['productname'],style: TextStyle(fontSize: 15),maxLines:2,overflow: TextOverflow.ellipsis,)),

  ],
  ),
    SizedBox(
      height: 10,
    ),

  SizedBox(
  height: 10,
  ),
  Row(
  children: [
  //Text("Mobile::",style: TextStyle(fontSize: 20)),
  Text(product[index]['unit'],style: TextStyle(fontSize: 15)
  ),
  ],
  ),
  SizedBox(
  height: 10,
  ),
  Row(
  children: [
  //Text("Mobile::",style: TextStyle(fontSize: 20)),
  //Text(product[index]['category']['name'],style: TextStyle(fontSize: 15)
  //),
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
  onTap: ()async{
  // bool pro= await
  // Navigator.push(
  // context, new MaterialPageRoute(
  // builder: (context) => ProductListView()));
  // print(pro);
  // print("Haiii");
  // if(pro){
  // ProductView();
  // }
  // else{}
  // print("Success");
  },

  ),
  ),
  ]
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
  );





  }

  }

