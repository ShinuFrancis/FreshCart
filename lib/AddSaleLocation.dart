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
import 'package:multiselect_formfield/multiselect_formfield.dart';
class AddSaleLocation extends StatefulWidget {



  @override
  _AddSaleLocation createState() => _AddSaleLocation();
}


class _AddSaleLocation extends State< AddSaleLocation> {

  final _formKey = GlobalKey<FormState>();

  TextEditingController deliveryController = TextEditingController();
  var myselection;

  var  selectedState;
  var  selectedCity;



  List cityArray=[];


  @override
  void initState() {
    super.initState();
    stateList();
   // CityList();
  }
  bool progress=true;  bool cityProgress=true;

  var state=[];

  void  stateList() async {
    print("pro");
    var url = Prefmanager.baseurl + '/location/statelist';
    var token = await Prefmanager.getToken();
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'x-auth-token': token
    };
    var response = await http.get(url, headers: requestHeaders);
    print(json.decode(response.body));
    if (json.decode(response.body)['status']) {
      state = json.decode(response.body)['data'];
    //  for(int i=0; i<json.decode(response.body)['data'].length ; i++)
      //  state.add({"display" :json.decode(response.body)['data'][i]["state"].toString(), "value" :json.decode(response.body)['data'][i]["_id"].toString()});

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

    setState(() {});
    progress = false;
  }


var city=[];

  void  cityList( var id) async {
    setState(() => cityProgress = true);
    print("pro");
    var url = Prefmanager.baseurl + '/location/citylist?state='+id;
    var token = await Prefmanager.getToken();
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'x-auth-token': token
    };
    var response = await http.get(url, headers: requestHeaders);
    print(json.decode(response.body));
    if (json.decode(response.body)['status']) {
      for(int i=0; i<json.decode(response.body)['data'].length ; i++)
        city.add({"display" :json.decode(response.body)['data'][i]["city"].toString(), "value" :json.decode(response.body)['data'][i]["_id"].toString()});
     // city= json.decode(response.body)['data'];
     // print(city[0]['city']);
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
    //cityProgress = false;
    setState(() =>cityProgress = false);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title:Text("Add Sales Location",style: TextStyle(color: Colors.white,fontSize: 20),),
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
                Container(
                  padding: EdgeInsets.all(20),
                  child: DropdownButton(
                    autofocus: true,
                    isExpanded: true,
                    hint: new Text('State'),
                    items: state.map((item) {
                      return new DropdownMenuItem(
                        child: new Text(item['state']),
                        value: item['_id'].toString(),
                      );
                    }).toList(),
                    onChanged: (newVal) {
                      cityList(newVal);
                      setState(() {
                        myselection = newVal;
                        print(myselection);
                      });
                    },
                    value: myselection,

                  ),
                ),
                SizedBox(
                  height:10,
                ),
                cityProgress ?
                Center(child: CircularProgressIndicator(),):
                Container(
                  padding: EdgeInsets.all(20),
                  // child: DropdownButton(
                  //   autofocus: true,
                  //   isExpanded: true,
                  //   hint: new Text('City'),
                  //   items: city.map((item) {
                  //     return new DropdownMenuItem(
                  //       child: new Text(item['city']),
                  //       value: item['_id'].toString(),
                  //     );
                  //   }).toList(),
                  //   onChanged: (newVal) {
                  //     cityArray.add(newVal);
                  //     setState(() {
                  //       selectedCity= newVal;
                  //       print(selectedCity);
                  //     });
                  //   },
                  //   value:selectedCity,
                  //
                  // ),
                 child: MultiSelectFormField(
                      title: Text("City"),
                      autovalidate: false,

                      validator: (value) {
                        if (value == null) {
                          return 'Please select one or more option(s)';
                        }
                        else
                          return null;
                      },
                      errorText: 'Please select one or more option(s)',
                      dataSource :city,
                      textField: 'display',
                      valueField: 'value',
                      required: true,
                    //   onSaved: (newVal) {
                    //   cityArray.add(newVal);
                    //   setState(() {
                    //     selectedCity= newVal;
                    //     print(selectedCity);
                    //   });
                    // }
                     onSaved: (value) {
                       selectedCity="";
                       print('The value is $value');
                       print(value is List);
                       selectedCity = value;
                       // value.forEach((element) {_mySelection.add("$element"); });
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
                          sentData();
                        }
                      }
                    )),
                //
              ]
          ),
        ),
      ),
    );
  }
  Future <void> sentData() async {

var url = Prefmanager.baseurl+'/user/Edit';
var token = await Prefmanager.getToken();
    Map<String, dynamic> data = {

       "salelocations":selectedCity,
    };


print(data.toString());
var body =json.encode(data);
var response = await http.post(url, headers:{"Content-Type":"application/json", "x-auth-token":token}, body:body);
print(json.decode(response.body));
    if(json.decode(response.body)['status']) {
      Navigator.push(
          context, new MaterialPageRoute(
          builder: (context) => new AddProfile()));

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


