import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:freshcart_seller/Home.dart';
import 'package:freshcart_seller/NetworkUtils/Prefmanager.dart';
import 'package:http/http.dart' as http;
class PurchaseRejected extends StatefulWidget {
  final _id,approved;
  PurchaseRejected(this._id,this.approved);

  @override
  _PurchaseRejected createState() => _PurchaseRejected();
}

class _PurchaseRejected extends State< PurchaseRejected> {
  var rejectreason;
  final _formKey = GlobalKey<FormState>();
  var rejectController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Purchase ReJected",
            style: TextStyle(color: Colors.white, fontSize: 20),),
          centerTitle: true,
          // iconTheme: IconThemeData(
          // color: Colors.black
          // ),
          elevation: 0.0,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(true),
          ),
          backgroundColor: Colors.green,
          //elevation: 0.0,
          actions: <Widget>[
          ]

      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Column(
              children: <Widget>[
                TextFormField(
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: 'Reject Reason',
                  ), validator: (v) {
                  if (v.isEmpty)
                    return "Cannot be empty";
                  else
                    return null;
                },
                  onSaved: (v) {
                    rejectreason = v;
                  },
                ),
                SizedBox(
                  height: 40,
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
                      child: Text('Post'),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          SendData();
                        }
                      },
                    )),
              ]
          ),
        ),
      ),

    );
  }
  void SendData() async {
    var url = Prefmanager.baseurl +'/Purchase/Approve';
    var token = await Prefmanager.getToken();
    Map data = {
      "x-auth-token": token,
      "id": widget._id,
      "approve":widget.approved,
      "rejectreason": rejectreason
    };
    print(token);
    print(data.toString());
    var body = json.encode(data);
    var response = await http.post(url,
        headers: {"Content-Type": "application/json", "x-auth-token": token},
        body: body);
    print(json.decode(response.body));
    if (json.decode(response.body)['status']) {
      Navigator.push(
          context, new MaterialPageRoute(
          builder: (context) => new AddProfile()));
    }
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

