import 'dart:convert';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:freshcart_seller/NetworkUtils/Prefmanager.dart';
import 'package:freshcart_seller/ViewProfile.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';



class ProfileEdit extends StatefulWidget {
  @override
  _ProfileEdit createState() => _ProfileEdit();
}

class _ProfileEdit extends State<ProfileEdit> {

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
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var name,email;
  void initState(){
    super.initState();
    viewprofile();

  }
  var profile,nam,emi;
  var pro;
  bool progress=true;
  void  viewprofile() async {
    print("pro");
    var url =  Prefmanager.baseurl+'/user/profile';
    var token = await Prefmanager.getToken();
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'x-auth-token':token
    };
    var response = await http.get(url,headers:requestHeaders);
    print(json.decode(response.body));
    if (json.decode(response.body)['status']) {
      profile = json.decode(response.body)['data'];
      nameController.text=profile['name'];
      emailController.text=profile['email'];
      print(profile);
      print(profile['photo']);
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

    //progress?Center(child:CircularProgressIndicator(),):
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          // iconTheme: IconThemeData(
          //   color: Colors.black12, //change your color here
          // ),

          backgroundColor: Colors.blue,
          elevation:0.0,
          leading: new IconButton(
              icon: new Icon(Icons.arrow_back),
              color:Colors.black,
              onPressed: () {
                //Navigator.of(context).pop(),

                Navigator.push(
                    context, new MaterialPageRoute(
                    builder: (context) => new Viewprofile()));
              }
          ),
          title: Text(
            'Edit Profile',
            style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color:Colors.black),
          ),
          centerTitle: true,
        ),
        body:progress?Center(child:CircularProgressIndicator(),):
        Form(
            key: _formKey,
            child: Padding(
                padding: EdgeInsets.symmetric(vertical:30,horizontal: 30),
                child: ListView(
                  children: <Widget>[
                    Container(
                      alignment:Alignment.topCenter,
                      padding: new EdgeInsets.all(30.0),
                      //padding:EdgeInsets.fromLTRB(20, 0, 20, 0),


                      child:Stack(
                        children: [

                          CircleAvatar(

                            radius: 80,
                            backgroundColor: Color(0xFFE3F2FD),

                            backgroundImage: _image!=null?
                            FileImage(_image):profile['photo']!=null?
                            NetworkImage(Prefmanager.baseurl+"/u/"+profile['photo']):
                            AssetImage("Assets/sigup.png" ),

                            //_image,
                            // width: 120,
                            // height: 120,
                            // fit: BoxFit.contain,
                          ),
                          new Positioned(
                              bottom: 0,
                              right:0,
                              child:ClipOval(
                                child:Container(
                                  color:Colors.blue,
                                  child: IconButton(
                                    icon:Icon(Icons.camera_alt,color:Colors.white),
                                    onPressed: (){
                                      _showPicker(context);
                                    },
                                  ),
                                ),
                              )
                          )
                        ],
                      ) ,
                    ),

                    TextFormField(

                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide(color: Colors.grey[200])
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide(color: Colors.grey[300])
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                          hintText: "Name"

                      ),
                      //keyboardType: TextInputType.number,
                      controller: nameController,
                    ),
                    SizedBox(height: 16,),
                    SizedBox(height: 16,),
                    TextFormField(
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'email';
                        }
                        /*else if (!value.contains("@"))
                      return "Please enter valid email";
                    else
                      return null;*/
                        Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                        RegExp regex = new RegExp(pattern);
                        if (!regex.hasMatch(value))
                          return 'Invalid Email';
                        else
                          return null;
                      },
                      onSaved:(v) {
                        email = v;
                      },
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide(color: Colors.grey[200])
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide(color: Colors.grey[300])
                          ),

                          filled: true,
                          fillColor: Colors.grey[100],
                          hintText: "Email"

                      ),

                      //keyboardType: TextInputType.number,
                      controller: emailController,
                    ),


                    SizedBox(
                      height:30,
                      width:50,

                    ),
                    Container(
                        height: 50,
                        width:80,
                        padding:EdgeInsets.symmetric(vertical:2,horizontal: 2),
                        //padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: RaisedButton(
                          // shape: RoundedRectangleBorder(
                          //     borderRadius: BorderRadius.circular(10.0)),
                          textColor: Colors.white,
                          color: Colors.blue,
                          child: Text('Update'),
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              senddata();

                              //_scaffoldKey.currentState.showSnackBar(new SnackBar(
                              //content: new Text("Your email: $_email and Password: $_password"),

                            }


                          },
                        )),
                  ],
                ) )));

  }
  void senddata() async {

      var url = Prefmanager.baseurl +'/user/Edit';
      var token = await Prefmanager.getToken();
      Map data={
        "x-auth-token":token,
        "name":nameController.text,
        "email":emailController.text,
      };
      print(token);
      print(data.toString());
      var body =json.encode(data);
      var response = await http.post(url, headers:{"Content-Type":"application/json", "x-auth-token":token}, body:body);
      print("yyu"+response.statusCode.toString());
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        if(json.decode(response.body)['status'])
        {
           if(_image!=null){
             addSinglePhoto();
           }
           else{
             Navigator.of(context).pop(true);
           }
        }
        else{

          print(json.decode(response.body)['msg']);
          Fluttertoast.showToast(
            //msg: "This is Toast messaget",

            msg:json.decode(response.body)['msg'],

            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,

          );
        }
      }
      else {
        print('Request failed with status: ${response.statusCode}.');
      }
    }
  addSinglePhoto() async {

    var request = http.MultipartRequest('POST', Uri.parse(Prefmanager.baseurl + '/user/photo'));
    String token = await Prefmanager.getToken();

    request.headers.addAll({'Content-Type': 'application/form-data', 'x-auth-token': token});
    //request.fields.addAll(data);

    if (_image != null) {
      request.files.add(http.MultipartFile.fromBytes(
          'photo', _image.readAsBytesSync(),
          filename: _image.path.split('/').last));

    }
    try {
      http.Response response =
      await http.Response.fromStream(await request.send());
      if(json.decode(response.body)['status'])
        print("dfgghlljg");
      Navigator.of(context).pop(true);
    } catch (e) {
      print(e);
      //return CustomResponse(500, '');
    }
  }

}
