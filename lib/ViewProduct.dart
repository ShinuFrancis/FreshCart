import 'dart:convert';
import 'package:freshcart_seller/DetailProductView.dart';
import 'package:freshcart_seller/FilterList.dart';
import 'package:freshcart_seller/NetworkUtils/Prefmanager.dart';
import 'package:freshcart_seller/ViewCategory.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';



class ViewProduct extends StatefulWidget {
  // final String id;
  // ViewProduct(this.id);

  @override
  _ViewProduct createState() => new _ViewProduct();
}

//State is information of the application that can change over time or when some actions are taken.
class _ViewProduct extends State<ViewProduct>{


  @override
  void initState() {
    super.initState();
    ProductView();
    category();

  }
  bool prog=true;
  var myselection;
  var listcat=[];
  void  category() async {
    print("pro");
    var url =  Prefmanager.baseurl+'/category/getlist';
    var token = await Prefmanager.getToken();
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'x-auth-token':token
    };
    var response = await http.get(url,headers:requestHeaders);
    print(json.decode(response.body));
    if (json.decode(response.body)['status']) {
      listcat = json.decode(response.body)['data'];
      print(listcat[0]['name']);
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
    prog=false;
  }
  bool progress=false;

  int len,total;
  int page=1,count=10;
  List product=[] ;
  void ProductView () async {
  setState(() {
  progress=true;
  });
  var url = Prefmanager.baseurl +'/product/myproducts';
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

  return  WillPopScope(
    onWillPop: ()async=>false,
    child: Scaffold(
    appBar: AppBar(
    title: Text("Product List",style: TextStyle(color: Colors.white,fontSize: 20),),
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
    Card(
      elevation: 4.0,
    child: InkWell(
    onTap: ()async{
      bool pro=await

      Navigator.push(
          context, new MaterialPageRoute(
          builder: (context) => DetailProductView(product[index]['_id'])));
      product.clear();
      page =1;
      ProductView();

    },

    child: new Container(

    padding: new EdgeInsets.all(10.0),

    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [

      Container(
        padding: EdgeInsets.all(20),
        // alignment: Alignment.center,
        // child: ClipRRect(
        //   borderRadius: BorderRadius.circular(70.0),
        //   child: FadeInImage(
        //
        //     image: NetworkImage(
        //         "https://scitechdaily.com/images/Twain-Betta-Fish.jpg"),
        //     placeholder: AssetImage(
        //         "Assets/sigup.png"),
        //     fit: BoxFit.cover,
        //     width: 50,
        //     height: 50,
        //
        //   ),
        // ),

       child: CircleAvatar(
          radius: 40.0,
          backgroundColor: Colors.white,
          backgroundImage: AssetImage('Assets/product.jpg'),
        ),
      ),

    Expanded(
    flex: 1,
    child: new Column(
    children: <Widget>[

    Row(
    children: [
      Text("Product Name:"),
    Text(product[index]['productname'],style: TextStyle(fontSize: 15),maxLines:2,overflow: TextOverflow.ellipsis,),

    ],
    ),
      SizedBox(
        height: 10,
      ),


    Row(
    children: [
    Text("Description:"),
    Text(product[index]['description']??" ",style: TextStyle(fontSize: 15)
    ),
    ],
    ),
    SizedBox(
    height: 10,
    ),
      Row(
        children: [
          Text("Category:"),
          Text(product[index]['category']['name'],style: TextStyle(fontSize: 15)
         ),
        ],
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

