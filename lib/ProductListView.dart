import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'file:///C:/Users/User/AndroidStudioProjects/flutter_cloudgm/lib/NetworkUtils/Prefmanager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';


class ProductListView extends StatefulWidget
{

  @override
  _ProductListView createState() =>_ProductListView();


}

class _ProductListView extends State < ProductListView> {


  @override
  void initState() {
    super.initState();
    void initState() {
      super.initState();
      ProductListView();

    }
    bool progress=false;

    int len,total;
    int page=1,count=5;
    List product=[] ;
    void ProductListView () async {
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



  // Future<bool>OnWillPOp()async{
  //   Navigator.of(context).pop(true);
  //   return Future.value(false);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: progress?Center(child: CircularProgressIndicator(),):
      SafeArea(
        child: Card(
          child: Container(
            margin: const EdgeInsets.all(10.0),
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, Colors.white],
              ),
            ),

            child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    //Container(child: IconButton(icon: Icon(Icons.arrow_back),color: Colors.black,alignment:Alignment.topLeft,onPressed: ()async => {
                    //Navigator.of(context).pop(),
                    //})),
                    Stack(
                      children: [
                        Container(
                            height: 300,
                            child: Image(image:NetworkImage("https://thumbs.dreamstime.com/b/colorful-rainbow-holi-paint-color-powder-explosion-isolated-white-wide-panorama-background-colorful-rainbow-holi-paint-color-143749617.jpg"),fit: BoxFit.cover,width: double.infinity,
                              height: 200,)),
                        Positioned(
                          bottom: 0, left: 0,right: 0,
                          child: Center(
                            child: new ClipRRect(
                              borderRadius: BorderRadius.circular(55.0),
                              child: FadeInImage(
                                image: NetworkImage(Prefmanager.baseurl+"/document/get/"+viewService["icon"]),
                                placeholder: AssetImage("assets/fadein.jpg"),
                                fit: BoxFit.cover,
                                width:150,
                                height: 150,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),


                    // Container(
                    //     alignment: Alignment.center,
                    //     child: Text(title['name'],textAlign:TextAlign.center,style: TextStyle(fontSize: 25,color: Colors.blue,fontWeight: FontWeight.bold))),
                    Container(
                      margin: const EdgeInsets.all(10.0),
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Expanded(
                          //     flex: 1,
                          //     child: ReadMoreText(viewService['aboutBranch'],style: TextStyle(fontSize: 20),
                          //       trimLines: 2,
                          //       colorClickableText: Colors.blue,
                          //       trimMode: TrimMode.Line,
                          //       trimCollapsedText: '...Show more',
                          //       trimExpandedText: ' show less',)
                           ),

                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(10.0),
                      padding: const EdgeInsets.all(10.0),
                      child: Card(
                        child: Row(
                          children: [
                            Icon(
                              Icons.person,
                              color: Colors.black,
                              size: 36.0,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Expanded(
                                flex: 1,
                                //child: Text("Contact",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.blue))
                            ),

                          ],
                        ),
                      ),
                    ),

                    Container(
                      margin: const EdgeInsets.all(10.0),
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Expanded(
                              flex: 1,
                              child: Text("Contact Person:",style: TextStyle(fontSize: 20))),
                          Expanded(
                              flex: 1,
                              //child: Text(viewService['contactPerson'],style: TextStyle(fontSize: 20))
                          ),
                        ],
                      ),
                    ),


                    Container(
                      margin: const EdgeInsets.all(10.0),
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Expanded(
                              flex: 1,
                              child: Text("Contact Email:",style: TextStyle(fontSize: 20))),
                          Expanded(
                              flex: 1,
                              //child: Text(viewService['contactEmail'],style: TextStyle(fontSize: 20))
                          ),
                        ],
                      ),
                    ),

                    Container(
                      margin: const EdgeInsets.all(10.0),
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Expanded(
                              flex: 1,
                              child: Text("Mobile:",style: TextStyle(fontSize: 20))),
                          Expanded(
                              flex: 1,
                              //child: Text(viewService['mobile'],style: TextStyle(fontSize: 20))
                          ),
                        ],
                      ),
                    ),

                    Container(
                      margin: const EdgeInsets.all(10.0),
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Expanded(
                              flex: 1,
                              child: Text("landline:",style: TextStyle(fontSize: 20))),
                          Expanded(
                              flex: 1,
                              //child: Text(viewService['landline'],style: TextStyle(fontSize: 20))
                          ),
                        ],
                      ),
                    ),


                    Container(
                      margin: const EdgeInsets.all(10.0),
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Expanded(
                              flex: 1,
                              child: Text("Whatsapp:",style: TextStyle(fontSize: 20))),
                          Expanded(
                              flex: 1,
                              //child: Text(viewService['socialmedialinks']['whatsapp'],style: TextStyle(fontSize: 20))
                          ),
                        ],
                      ),
                    ),


                    Container(
                      margin: const EdgeInsets.all(10.0),
                      padding: const EdgeInsets.all(10.0),
                      child: Card(
                        child: Row(
                          children: [
                            Icon(
                              Icons.home,
                              color: Colors.black,
                              size: 36.0,
                            ),
                            Expanded(
                                flex: 1,
                                //child: Text("Address",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.blue))
                            ),

                          ],
                        ),
                      ),
                    ),

                    Container(
                      margin: const EdgeInsets.all(10.0),
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Expanded(
                              flex: 1,child:Text("Building Name:",style: TextStyle(fontSize: 20))),
                          Expanded(
                              //flex: 1,child:Text(viewService['buildingName'],style: TextStyle(fontSize: 20))
                          ),
                        ],
                      ),
                    ),

                    Container(
                      margin: const EdgeInsets.all(10.0),
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Expanded(
                              flex: 1,
                              //child: Text("place:",style: TextStyle(fontSize: 20))
                        ),
                          Expanded(
                              flex: 1,
                             // child: Text(viewService['place'],style: TextStyle(fontSize: 20))
                          ),
                        ],
                      ),
                    ),



                    Container(
                      margin: const EdgeInsets.all(10.0),
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Expanded(
                              flex: 1,
                              //child: Text("City:",style: TextStyle(fontSize: 20))
                          ),
                          Expanded(
                              flex: 1,
                              //child: Text(viewService['city'],style: TextStyle(fontSize: 20))
                          ),
                        ],
                      ),
                    ),


                    Container(
                      margin: const EdgeInsets.all(10.0),
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Expanded(
                              flex: 1,
                              //child: Text("Area:",style: TextStyle(fontSize: 20))
                          ),
                          Expanded(
                              flex: 1,
                             // child: Text(viewService['area'],style: TextStyle(fontSize: 20))
                          ),
                        ],
                      ),
                    ),


                    Container(
                      margin: const EdgeInsets.all(10.0),
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Expanded(
                              flex: 1,
                              //child:Text("Street:",style: TextStyle(fontSize: 20))
                          ),
                          Expanded(
                              //flex: 1,child:Text(viewService['street'],style: TextStyle(fontSize: 20))
                          ),
                        ],
                      ),
                    ),


                    Container(
                      margin: const EdgeInsets.all(10.0),
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Expanded(
                              //flex: 1,child:Text("Landmark:",style: TextStyle(fontSize: 20))
                          ),
                          Expanded(
                              //flex: 1,child:Text(viewService['landmark'],style: TextStyle(fontSize: 20))
                          ),
                        ],
                      ),
                    ),



                    Container(
                      margin: const EdgeInsets.all(10.0),
                      padding: const EdgeInsets.all(10.0),
                      child: Card(
                        child: Row(
                          children: [

                    SizedBox(height: 30.0,),






                    Container(
                      margin: const EdgeInsets.all(10.0),
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("My Products",style: new TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold,color: Colors.blue)),

                          ]
                      ),
                    ),
                    Card(
                      child: InkWell(

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
                                          borderRadius: BorderRadius.circular(
                                              55.0),
                                          child: FadeInImage(

                                            image: NetworkImage(
                                                Prefmanager.baseurl +
                                                    "/document/get/" +
                                                    myRate["pro_pic"]),
                                            placeholder: AssetImage(
                                                "assets/fadein.jpg"),
                                            fit: BoxFit.cover,
                                            width: 50,
                                            height: 50,

                                          ),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Expanded(
                                            flex: 2,
                                            child: Text(
                                              myRate["firstname"]+" "+myRate["lastname"],
                                              style: TextStyle(
                                                  fontSize: 15),
                                              maxLines: 2,
                                              overflow: TextOverflow
                                                  .ellipsis,)),
                                        IconButton(
                                            icon: Icon(
                                              Icons.delete,color: Colors.black,
                                              size: 30,
                                            ),
                                            tooltip:"Review",
                                            onPressed:(){
                                              //DeleteProduct();


                                            }
                                        ),

                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),

                                    SizedBox(
                                      height: 10,
                                    ),


                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(
                                            myRate['review'],
                                            style: TextStyle(
                                                fontSize: 15)),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        FlatButton(
                                            textColor: Colors.blue,
                                            color: Colors.white,
                                            child: Text('Edit Your product',style: TextStyle(
                                                fontSize: 15,fontWeight: FontWeight.bold)),
                                            onPressed: () async {

                                              // Navigator.push(
                                              //     context, new MaterialPageRoute(
                                              //     builder: (context) => RatingPage(widget._id,double.parse(myRate['rate']),myRate['review'])));
                                              // if(pro){
                                              //   serviceList();
                                              // }
                                              // else{}
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
                    ),

                                                    SizedBox(
                                                      height: 10,
                                                    ),


                                                  ],
                                                ),
                                              ),
                                                ),
                                            ],
                                          ),

                                        ),


                                      ),
                                    ),
    ),
    );

  }

  //bool progress=true;


  // void DeleteProduct() async {
  //   //var url = Prefmanager.baseurl +'/product/delete'+widget._id;
  //   var token = await Prefmanager.getToken();
  //   Map<String, String> requestHeaders = {
  //     'Content-type': 'application/json',
  //     'Accept': 'application/json',
  //     'x-auth-token':token
  //   };
  //   var response = await http.get(url,headers:requestHeaders);
  //   print(json.decode(response.body));
  //   if (json.decode(response.body)['status']) {
  //     Fluttertoast.showToast(
  //         msg: json.decode(response.body)['msg'],
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.CENTER,
  //         backgroundColor: Colors.grey,
  //         textColor: Colors.white,
  //         fontSize: 20.0
  //     );
  //     ProductList();
  //   }
  //   else
  //     Fluttertoast.showToast(
  //         msg: json.decode(response.body)['message'],
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.CENTER,
  //         backgroundColor: Colors.grey,
  //         textColor: Colors.white,
  //         fontSize: 20.0
  //     );
  //   progress=false;
  //
  // }

}


