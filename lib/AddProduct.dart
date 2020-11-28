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
class AddProduct extends StatefulWidget {

  final String id;
  AddProduct(this.id);

  @override
  _AddProduct createState() => _AddProduct();
}


class _AddProduct extends State<AddProduct> {

  final _formKey = GlobalKey<FormState>();

  var name,description,unit;
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
  File _image;

  _imgFromCamera() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50
    );

    setState(() {
      _image = image;
    });
  }

  _imgFromGallery() async {
    File image = await  ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50
    );

    setState(() {
      _image = image;
    });
  }
  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(

            child: Container(
              child: new Wrap(
                children: <Widget>[

                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Gallery'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),

                ],
              ),
            ),

          );
        }

    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title:Text("Add Product",style: TextStyle(color: Colors.white,fontSize: 20),),
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
                TextFormField(
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: 'Product Name',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'name';
                    }

                    Pattern pattern = r'^[a-zA-Z]';
                    RegExp regex = new RegExp(pattern);
                    if (!regex.hasMatch(value))
                      return 'Invalid';
                    else
                      return null;
                  },

                  onSaved: (v) {
                    name = v;
                  },
                ),

                SizedBox(
                  height:20,
                ),
                TextFormField(
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: 'Product Dercription',
                  ),validator: (v){
                  if(v.isEmpty)
                    return "Cannot be empty";
                  else
                    return null;
                },
                  onSaved: (v) {
                    description = v;
                  },
                ),

                SizedBox(
                  height:20,
                ),
                // TextFormField(
                //   autofocus: true,
                //   decoration: InputDecoration(
                //     labelText: 'Product Count',
                //   ),
                //     //   validator: (v){
                // //   if(v.isEmpty)
                // //     return "Cannot be empty";
                // //   else
                // //     return null;
                // // },
                // //   onSaved: (v) {
                // //     unit = v;
                // //   },
                // ),
                new DropdownButton<String>(
                  hint: new Text('Unit'),
                  items: <String>['Count', 'Kg', 'gm', 'litre'].map((String value) {
                    return new DropdownMenuItem<String>(
                      value: value,
                      child: new Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedvalue = newValue;
                    });
                    print(selectedvalue);
                  },
                  value: selectedvalue,
                ),



    SizedBox(
                  height:10,
                ),
                Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Upload product Image',
                      style: TextStyle(fontSize: 18,color:Colors.black),

                    )

                ),
                GestureDetector(
                  onTap: () {
                    _showPicker(context);
                  },
                  child: Container(
                    height: 300,
                    color: Colors.grey,
                    alignment:Alignment.center,
                    padding: new EdgeInsets.all(30.0),
                    child:  _image!=null?
                    Image(image: FileImage(_image), fit: BoxFit.cover,):Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.collections,
                         size: 80,
                          color: Colors.white,
                        ),
                        Text("Click to add product image"),
                      ],
                    ), // icon is 48px widget.,
                  ),
                ),


                SizedBox(
                  height:40,
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
  var productid;
  void sentdata() async {
    var url = Prefmanager.baseurl +'/Product/Add';
    var token = await Prefmanager.getToken();
    Map data={
      "x-auth-token":token,
      "productname":name,
      "description":description,
      "category":widget.id,
      "unit":selectedvalue
    };
    print(token);
    print(data.toString());
    var body =json.encode(data);
    var response = await http.post(url, headers:{"Content-Type":"application/json", "x-auth-token":token}, body:body);
    print(json.decode(response.body));
      if(json.decode(response.body)['status']) {
        productid = await json.decode(response.body)['product']['_id'];
        if(_image!=null){
          addSinglePhoto();
        }
        else{
          Navigator.of(context).pop(true);
        }
        Navigator.push(
            context, new MaterialPageRoute(
            builder: (context) => new AddSaleLocation()));
        Fluttertoast.showToast(
            msg: json.decode(response.body)['msg'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 20.0
        );
        print("true");
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
  addSinglePhoto() async {

    print("Omgae funnkjhk");

    var request = http.MultipartRequest('POST', Uri.parse(Prefmanager.baseurl + '/category/UploadImagesingle'));
    String token = await Prefmanager.getToken();
    Map <String,String>data={"id":productid};

    request.headers.addAll({'Content-Type': 'application/form-data', 'x-auth-token': token});
    request.fields.addAll(data);

    if (_image != null) {
      request.files.add(http.MultipartFile.fromBytes(
          'image', _image.readAsBytesSync(),
          filename: _image.path.split('/').last));

    }
    try {
      http.Response response =
      await http.Response.fromStream(await request.send());
      if(json.decode(response.body)['status'])
        Navigator.push(
            context, new MaterialPageRoute(
            builder: (context) => new AddProfile()));

   ;} catch (e) {
      print(e);
      //return CustomResponse(500, '');
    }
  }


}

