import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
class EditProduct extends StatefulWidget {

  @override
  _EditProduct createState() => _EditProduct();

}

class _EditProduct extends State<EditProduct> {
  File _image;
  bool progress=false;

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
                      title: new Text('Photo Library'),
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
  TextEditingController descriptionController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController unitController = TextEditingController();

  //TextEditingController _mySelectionController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String dercription,name,unit;
  var _mySelection;


  @override
  void initState() {
    super.initState();


  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Edit Fish Information",style: TextStyle(color: Colors.blue,fontSize: 25),),
        centerTitle: true,
        elevation: 0.0,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back,color:Colors.black12),
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
                  padding: EdgeInsets.all(10),
                  alignment: Alignment.bottomCenter,
                  child: Stack(
                      children:[


                        CircleAvatar(
                          radius: 80.0,
                          backgroundColor: Colors.white,
                          backgroundImage:_image == null ?NetworkImage("https://scitechdaily.com/images/Twain-Betta-Fish.jpg"):
                          //backgroundImage:_image == null ?AssetImage('Assets/login.jpg'):
                          //_image == null ?NetworkImage(Prefmanager.baseurl+"/file/get/"+profile[ "pro_pic"]):
                          FileImage(_image),


                        ),

                        new Positioned(

                          bottom: 0, right: 0,left: 100, //give the values according to your requirement
                          child:IconButton(
                            icon:Icon(Icons.camera_alt,
                            ),
                            iconSize: 40,
                            color: Colors.blue,
                            onPressed: (){
                              _showPicker(context);

                            },
                          ),

                        ),


                      ]

                  ),

                ),

               SizedBox(
                  height:10,
                ),
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
                TextFormField(
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: 'Product Count',
                  ),validator: (v){
                  if(v.isEmpty)
                    return "Cannot be empty";
                  else
                    return null;
                },
                  onSaved: (v) {
                    unit = v;
                  },
                ),
                SizedBox(
                  height:10,
                ),
                DropdownButton(
                  autofocus: true,
                  isExpanded: true,
                  hint: new Text('Category'),
                  items: listcat.map((item) {
                    return new DropdownMenuItem(
                      child: new Text(item['cname']),
                      value: item['_id'].toString(),
                    );
                  }).toList(),
                  onChanged: (newVal) {
                    setState(() {
                      _mySelection = newVal;
                      print(_mySelection);
                    });
                  },
                  value: _mySelection,

                ),




                SizedBox(
                  height: 40,
                  width: 40,
                ),


                Container(
                    height: 50,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    width: double.infinity,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      textColor: Colors.white,
                      color: Colors.blue,
                      child: Text('Save'),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();

                          //sentData();
                        }


                      },
                    )),
                //
              ]
          ),
        ),
      ),
    );
  }
// _getCurrentLocation() {
//   final Geolocator geolocator = Geolocator()
//     ..forceAndroidLocationManager;
//
//   geolocator
//       .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
//       .then((Position position) {
//     setState(() {
//       _currentPosition = position;
//       lat= _currentPosition.latitude;
//       lon= _currentPosition.longitude;
//       print("latitude $lat");
//       print("longitude $lon");
//     });
//   }).catchError((e) {
//     print(e);
//   });
// }
// Position _currentPosition;
//
//
// var lat,lon;
//
// void sentData() async {
//   var url = 'http://13.234.186.200/edit/branch/initial';
//   var token = await Prefmanager.getToken();
//   Map<String, dynamic> data = {
//     "to": token,
//     "branchid":widget.branchId,
//     "aboutBranch":aboutBranchController.text,
//     "contactPerson":contactPersonController.text,
//     "contactEmail":contactEmailController.text,
//     "mobile":mobileController.text,
//     "landline":landlineController.text,
//     "whatsapp":whatsappController.text,
//     "buildingName":buildingNameController.text,
//     "place":placeController.text,
//     "city":cityController.text,
//     "street":streetController.text,
//     "area":areaController.text,
//     "pincode":pincodeController.text,
//     "landmark":landmarkController.text,
//     "lat":lat.toString(),
//     "lon":lon.toString(),
//     "subcategory":_mySelection,
//   };
//   // data.addAll({"subcategory":_mySelection});
//   print(data.toString());
//   //print(_mySelection);
//   _mySelection.forEach((element) {print(element);});
//   var body = json.encode(data);
//   var response = await http.post(url,headers: {"Content-Type":"application/json"}, body: body);
//   print(json.decode(response.body));
//   // Await the http get response, then decode the json-formatted response.
//   //var response = await http.get(url);
//   print(json.decode(response.body));
//   if (json.decode(response.body)['status']) {
//     Fluttertoast.showToast(
//         msg:json.decode(response.body)['msg'],
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.CENTER,
//         backgroundColor: Colors.grey,
//         textColor: Colors.white,
//         fontSize: 20.0
//     );
//     //Prefmanager.getToken(json.decode(response.body)['token']);
//     Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) =>BranchView(widget.branchId)));
//   }
//
//   else {
//     print(json.decode(response.body)['msg']);
//     Fluttertoast.showToast(
//         gravity: ToastGravity.CENTER,
//         backgroundColor: Colors.white,
//
//         textColor: Colors.black,
//         msg: json.decode(response.body)['msg'],
//         fontSize: 20.0
//     );
//   }
//
//
// }
}

