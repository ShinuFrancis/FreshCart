import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:freshcart_seller/Home.dart';
import 'package:freshcart_seller/NetworkUtils/Prefmanager.dart';
import 'package:freshcart_seller/ViewProduct.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
class SetDeliveryDate extends StatefulWidget {
  final String name,deliveryDate;
  SetDeliveryDate(this.name,this.deliveryDate);


  @override
  _SetDeliveryDate createState() => _SetDeliveryDate();
}


class _SetDeliveryDate extends State< SetDeliveryDate> {

  final _formKey = GlobalKey<FormState>();

  TextEditingController deliveryController = TextEditingController();
  TextEditingController categoryController = TextEditingController();

  var myselection,deliverydate,cat;

  var  selectedvalue;


  @override
  var formattedDate = new DateFormat('dd-MM-yyyy');
  void initState() {
    super.initState();
    print(widget.name);
    print(widget.deliveryDate);
    DeliveryDate();
    //category();


  }
  bool pro=true;
  var date=[];
  void  DeliveryDate() async {
    print("pro");
    var url =  Prefmanager.baseurl+'/user/getmycategories';
    var token = await Prefmanager.getToken();
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'x-auth-token':token
    };
    var response = await http.get(url,headers:requestHeaders);
    print(json.decode(response.body));
    if (json.decode(response.body)['status']) {
      date = json.decode(response.body)['data'];
      categoryController.text=widget.name;
      deliveryController.text=formattedDate.format(DateTime.parse(widget.deliveryDate));
      print(categoryController.text);
      print(deliveryController.text);

      //print(date[0]['deliveryDate']);
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
    pro=false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title:Text("Add Delivery Date",style: TextStyle(color: Colors.white,fontSize: 20),),
        centerTitle: true,
        elevation: 0.0,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back,color:Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Column(
              children: <Widget>[
                // Container(
                //   padding: EdgeInsets.all(20),
                //   child: DropdownButton(
                //     autofocus: true,
                //     isExpanded: true,
                //     hint: new Text('Category'),
                //     items: .map((item) {
                //       return new DropdownMenuItem(
                //         child: new Text(item['name']),
                //         value: item['_id'].toString(),
                //       );
                //     }).toList(),
                //     onChanged: (newVal) {
                //       setState(() {
                //         myselection = newVal;
                //         print(myselection);
                //       });
                //     },
                //     value: myselection,
                //
                //   ),
                // ),
                Container(
                  padding: EdgeInsets.all(20),
                  child: TextFormField(
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: 'Category',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'category';
                      }


                      else
                        return null;
                    },

                    controller: categoryController,

                  ),
                ),
                SizedBox(
                  height:10,
                ),

                Container(
                  padding: EdgeInsets.all(20),
                  child: TextFormField(
                      autofocus: true,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Delivery date';
                        }

                        else
                          return null;

                      },



                      controller: deliveryController,
                      decoration: InputDecoration(
                        //border: OutlineInputBorder(),
                        labelText: 'Delivery Date',


                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.calendar_today,
                            color: Colors.blue,
                          ),



                        ),
                      ),
                      onTap: ()async{

                        final DateTime date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2101),
                          builder: (BuildContext context, Widget child) {
                            return Theme(
                              data: ThemeData.light().copyWith(
                                //primarySwatch: buttonTextColor,//OK/Cancel button text color
                                  primaryColor: const Color(0xFF4A5BF6),//Head background
                                  accentColor: const Color(0xFF4A5BF6)//selection color
                                //dialogBackgroundColor: Colors.white,//Background color
                              ),
                              child: child,
                            );
                          },
                        );





                        deliveryController.text=new DateFormat('yyyy/MM/dd').format(date.toLocal()) ;



                      }


                  ),
                ),
                SizedBox(
                  height:10,
                ),
                SizedBox(
                  height:20,
                ),
                Container(
                    height: 50,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    width: double.infinity,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      textColor: Colors.white,
                      color: Colors.green,
                      child: Text('Save'),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          sentdata();
                          // Navigator.push(context, MaterialPageRoute(builder: (
                          //     context) => Fishdp()),
                          // );

                        }
                        // print(nameController.text);
                        // print(regController.text);

                      },
                    )),
                //
              ]
          ),
        ),
      ),
    );
  }

  void sentdata() async {
    var url = Prefmanager.baseurl +'/Product/Adddeliverydate';
    var token = await Prefmanager.getToken();
    Map data={
     // "x-auth-token":token,
      "category":categoryController.text,
      "deliverydate":deliveryController.text

    };
    print(token);
    print(data.toString());
    var body =json.encode(data);
    var response = await http.post(url, headers:{"Content-Type":"application/json","x-auth-token":token}, body:body);
    print(json.decode(response.body));
    if(json.decode(response.body)['status']) {
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
          builder: (context) => new AddProfile()));

    }
    else {
      Fluttertoast.showToast(
          msg: json.decode(response.body)['msg'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 20.0
      );
    }

  }

  }


