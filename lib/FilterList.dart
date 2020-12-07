import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:freshcart_seller/AddSaleLocation.dart';
import 'package:freshcart_seller/Home.dart';
import 'package:freshcart_seller/NetworkUtils/Prefmanager.dart';
import 'package:freshcart_seller/ViewProduct.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
class FilterList extends StatefulWidget {


  @override
  _FilterList createState() => _FilterList();
}


class _FilterList extends State<FilterList> {

  final _formKey = GlobalKey<FormState>();


  var myselection;

  var  selectedvalue;


  @override
  void initState() {
    super.initState();
    category();

  }
  bool progress=true;
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
    progress=false;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title:Text("Product List",style: TextStyle(color: Colors.white,fontSize: 20),),
        centerTitle: true,
        elevation: 0.0,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back,color:Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),

      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(20),
                  child: DropdownButton(
                    autofocus: true,
                    isExpanded: true,
                    hint: new Text('Category'),
                    items: listcat.map((item) {
                      return new DropdownMenuItem(
                        child: new Text(item['name']),
                        value: item['_id'].toString(),
                      );
                    }).toList(),
                    onChanged: (newVal) {
                      setState(() {
                        myselection = newVal;
                        print(myselection);
                      });
                    },
                    value: myselection,

                  ),
                ),
                SizedBox(
                  height:40,
                ),


                //
              ]
          ),
        ),
      ),
    );
  }



}

