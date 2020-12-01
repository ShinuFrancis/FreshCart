import 'dart:convert';
import 'package:freshcart_seller/EditProduct.dart';
import 'package:freshcart_seller/NetworkUtils/Prefmanager.dart';
import 'package:freshcart_seller/ViewProduct.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
class DetailProductView extends StatefulWidget {
  final String _id;
  DetailProductView(this._id);

  @override
  _DetailProductView createState() => new _DetailProductView();
}

//State is information of the application that can change over time or when some actions are taken.
class _DetailProductView extends State<DetailProductView>{

  @override
  void initState() {
    super.initState();
    Productview();


  }
  bool progress=false;
  var product;
  void Productview () async {
    setState(() {
      progress=true;
    });
    var url = Prefmanager.baseurl +'/product/info?id='+widget._id;

    var token = await Prefmanager.getToken();
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'x-auth-token':token
    };
    var response = await http.get(url,headers:requestHeaders);
    print(json.decode(response.body));
    if (json.decode(response.body)['status']) {
      product=json.decode(response.body)['data'];
      print("Updated");
    }
    else
      Fluttertoast.showToast(
        msg: json.decode(response.body)['msg'],
        backgroundColor: Colors.grey,
        textColor: Colors.black,
      );
    progress=false;
    setState(() {

    });

  }


  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: ()async=>false,
      child: Scaffold(

        appBar: AppBar(

            title: Text("Product View"),
            centerTitle: true,

            //leading: Icon(Icons.arrow_back),
            leading: new IconButton(
              icon: new Icon(Icons.arrow_back,color:Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
            backgroundColor: Colors.green,
            actions: <Widget>[




              // Here we take the value from the MyHomePage object that was created by
              // the App.build method, and use it to set our appbar title.
              //title: Text(widget.title),
            ]
        ),
        body: progress ? Center(child:  CircularProgressIndicator(),):

        SafeArea(
          child: Card(
            child: Container(
              //IconButton(icon: Icon(Icons.arrow_back),color: Colors.black, onPressed: () => { }),
              margin: const EdgeInsets.all(10.0),
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(

                gradient: LinearGradient(
                  colors: [Colors.white, Colors.white],
                ),
              ),

              child: SingleChildScrollView(

                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      //Container(child: IconButton(icon: Icon(Icons.arrow_back),color: Colors.black,alignment:Alignment.topLeft,onPressed: () => {Navigator.of(context).pop(), })),
                      Stack(
                        children: [

                          Center(
                            child: FadeInImage(
                              //image:AssetImage(Assets/login.jpg),
                              image: NetworkImage("https://ik.imagekit.io/dunzo/dunzo-catalog-prod/tr:w-300,h-300,cm-pad_resize_store_thumbnail/stores/NXB1a2RQU0FrVUxVcmtiUUQ1ZUJjQT09-1598000173793-store_image.jpg"),

                              placeholder: AssetImage("assets/fadein.jpg"),
                              fit: BoxFit.cover,
                              width:double.infinity,
                              height: 300,
                            ),
                          ),
                        ],
                      ),


                      Container(
                        alignment: Alignment.center,
                        //child: Text("Fringescale sardinella",style: TextStyle(fontSize: 25,color: Colors.blue,fontWeight: FontWeight.bold)),
                        child:Text(product['productname'],textAlign:TextAlign.center,style: TextStyle(fontSize: 25,color: Colors.black,fontWeight: FontWeight.bold))
                      ),

                      Container(
                        margin: const EdgeInsets.all(10.0),
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Expanded(
                              flex:1,
                                child: Text("Product Description")),
                            Expanded(
                              flex: 1,
                              child: Text(product['description']),
                            )


                          ],
                        ),
                      ),



                      Container(
                        margin: const EdgeInsets.all(10.0),
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Expanded(
                                flex: 1,child:Text("Category")),
                             Expanded(
                               flex:1,
                               child:Text(product['category']['name']),
                             ),
                          ],
                        ),
                      ),


                      SizedBox(height: 30.0,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MaterialButton(
                            minWidth:150,
                            height: 50.0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            textColor: Colors.white,
                            color: Colors.green,
                            child: Text('Update'),
                            onPressed: () async{
                              bool pro=await
                              Navigator.push(context, new MaterialPageRoute(builder: (context) =>ProfileEdit(widget._id)));
                              if(pro){
                                print("pro");
                                Productview();
                              }
                              else{}
                            },
                          ),
                          MaterialButton(
                            minWidth:150,
                            height: 50.0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            textColor: Colors.white,
                            color: Colors.green,
                            child: Text('Delete'),
                            onPressed: () {
                              // Navigator.push(context, new MaterialPageRoute(builder: (context) =>EditFish()));
                              showAlertDialog(context);
                              DeleteProduct();
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),



                      SizedBox(height: 30.0,),


                    ]
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  CategoryListing(BuildContext context)
  {
    List<Widget> item=[];
     for(int i=0;i<product['category'].length;i++)
    item.add(
      Row(

        children: [
          Padding(padding:EdgeInsets.only(left:50)),

          Expanded(
              flex: 1,child:Text(product['category'][i]['name'],style: TextStyle(fontSize: 20))
          ),

        ],
      ),

    );
    Divider(
      color: Colors.black,
    );
    return item;
  }
  void DeleteProduct() async {
    var url = Prefmanager.baseurl +'/product/delete?id='+widget._id;
    var token = await Prefmanager.getToken();
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'x-auth-token':token
    };
    var response = await http.get(url,headers:requestHeaders);
    print(json.decode(response.body));
    if (json.decode(response.body)['status']) {
      Fluttertoast.showToast(
          msg: json.decode(response.body)['msg'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 20.0
      );
      Navigator.push(
          context, new MaterialPageRoute(
          builder: (context) => new ViewProduct()));
    }
    else
      Fluttertoast.showToast(
          msg: json.decode(response.body)['message'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 20.0
      );
    progress=false;

  }

  void showAlertDialog(BuildContext context) {
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }



}