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
class UpdateSaleLocation extends StatefulWidget {
  final String _id;
  UpdateSaleLocation(this._id);
  @override
  _UpdateSaleLocation createState() => _UpdateSaleLocation();
}


class _UpdateSaleLocation extends State< UpdateSaleLocation> {

  final _formKey = GlobalKey<FormState>();

  TextEditingController deliveryController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  var myselection;

  var  selectedState;
  var  selectedCity;



  List cityArray=[];


  @override
  void initState() {
    super.initState();

    //stateList();
    viewprofile();
    cityList('5fb620738b64e20aa84a0717');

  }
  var city=[];
  bool prog=true;

  void  cityList( var id) async {

    print("pro");
    var url = Prefmanager.baseurl + '/location/citylist?state='+'5fb620738b64e20aa84a0717';
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
    prog=false;
    //cityProgress = false;


  }
  var profile,nam,emi;

  var InitialCity=[];
  var pro;
  bool progress=true;
  void  viewprofile() async {
    print("pro");
    var url =  Prefmanager.baseurl+'/user/getsalelocations';
    var token = await Prefmanager.getToken();
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'x-auth-token':token
    };
    var response = await http.get(url,headers:requestHeaders);
   // print(json.decode(response.body)["data"]["seller"]);
    if (json.decode(response.body)['status']) {
      profile = json.decode(response.body)['data'];
      for(int i=0;i<profile['salelocations'].length;i++)
       InitialCity.add(profile['salelocations'][i]["_id"]);
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
        title:Text("Sales Location",style: TextStyle(color: Colors.white,fontSize: 20),),
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

                SizedBox(
                  height: 10,
                ),
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.all(20),

                  child:Text("Update Sales Location", style: TextStyle(fontSize: 18,color:Colors.black,fontWeight: FontWeight.bold)),
                ),
                Container(
                  height: 200.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                          'https://www.disruptivestatic.com/wp-content/uploads/2018/01/geo-targeting-blog-1.jpg'),
                      fit: BoxFit.fill,
                    ),
                    //shape: BoxShape.circle,
                  ),
                ),
                SizedBox(
                  height:10,
                ),



                Container(
                  padding: EdgeInsets.all(20),

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
                      initialValue:InitialCity,
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

    var url = Prefmanager.baseurl+'/Product/Updatesalelocation';
    var token = await Prefmanager.getToken();
    Map<String, dynamic> data = {
      "category":widget._id,
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


