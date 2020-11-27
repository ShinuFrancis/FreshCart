import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:freshcart_seller/AddSaleLocation.dart';
import 'package:freshcart_seller/Home.dart';
import 'package:freshcart_seller/NetworkUtils/Prefmanager.dart';
import 'package:freshcart_seller/ViewCategory.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';

class LoginSample extends StatefulWidget {
  final phone;
  LoginSample(this.phone);
  @override
  _LoginSample createState() => _LoginSample();
}

class _LoginSample extends State<LoginSample> {
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

  Position _currentPosition;
  var lat,lon,city,state,locationname;
  String _currentAddress;
  TextEditingController verificationController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var verify;
  var phone,otp;
  var verificationId;
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState(){
    super.initState();
    check();
    _getCurrentLocation();
    verifyPhone();

  }
  bool pro=false;
  var progress=true;
  bool isnew=false;
  void check()async{
    var url = Prefmanager.baseurl+'/user/check/phone';
    Map data = {
      "phone": widget.phone,
    };
    print(data.toString());
    var response = await http.post(url, body: data);
    print(json.decode(response.body));
    isnew=json.decode(response.body)['status'];
    setState(() {

    });
    progress=false;
    }



  signIn(BuildContext context) async {
    setState(() {
      pro=true;
    });
    try {

      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );
      final User user = (await _auth.signInWithCredential(credential)).user;
      print(user.getIdToken());
      var idToken = await user.getIdToken();
      print(idToken);
      if(idToken != null) {
        bool progress=true;
        var url = Prefmanager.baseurl+'/user/signupseller';
          Map data = {
            "token":idToken,
            "phone":widget.phone,
            "email":_emailController.text,
            "name":_nameController.text,
            "lat":lat.toString(),
            "lon":lon.toString(),
            "city":city,
            "state":state,
            "locationname":locationname
          };
          //print(data.toString());
          var response = await http.post(url, body: data);
          print(json.decode(response.body));
          if (json.decode(response.body)['status']) {
            print("Response");
            var userid=json.decode(response.body)['signindata']['id'];
             await Prefmanager.setToken(json.decode(response.body)['signindata']['token']);
             await Prefmanager.setuserid(json.decode(response.body)['signindata']['id']);
            print("Navigation");
            pro=false;
            ProductView();
            // Navigator.pushReplacement(context, MaterialPageRoute(builder: (
            //     context) =>ViewCategory()),
            // );
          }
          else
            Fluttertoast.showToast(
                msg: json.decode(response.body)['msg'],
                backgroundColor: Colors.grey,
                textColor: Colors.white,
                fontSize: 20.0
            );

          setState(() {

          });

      }
      else{
        print("Empty");
      }

    } catch (e) {
      FocusScope.of(context).requestFocus(new FocusNode());
      setState(() {
       // errorMessage = '${e.toString()}';
      });
      //handleError(e.toString());
    }
    setState(() {
      //buttonLoading = false;
    });
  }

  //var username,pass;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _scaffoldKey,

        appBar: AppBar(
          // iconTheme: IconThemeData(
          //     color: Colors.blue
          // ),
          backgroundColor: Colors.green,
          elevation: 0.0,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back, color: Colors.black12),
            onPressed: () => Navigator.of(context).pop(),
          ),
          //automaticallyImplyLeading: true,
        ),

        body:
        Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(
                children: <Widget>[
                  Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'Verify',
                        style: TextStyle(fontSize: 20),
                      )
                  ),
                  SizedBox(height:100,),
                 // Image(image: AssetImage('Assets/verification.jpg'),width:300,height: 300, fit:BoxFit.cover,),
                  isnew ? TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'name';
                      }
                      /*else if (!value.contains("@"))
                        return "Please enter valid email";
                      else
                        return null;*/

                      else
                        return null;
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
                        hintText: "Name"

                    ),
                    //keyboardType: TextInputType.number,
                    controller: _nameController,
                  ): SizedBox.shrink(),
                  SizedBox(height: 16,),
                  SizedBox(height: 16,),
                  isnew?TextFormField(
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
                    controller: _emailController,
                  ):SizedBox.shrink(),
                  SizedBox(height: 16,),
                  SizedBox(height: 16,),



                  SizedBox(height: 16,),


                  Container(
                      alignment: Alignment.centerLeft,
                      child: Text("Enter OTP:", style:TextStyle(fontWeight:FontWeight.bold, fontSize: 20, color: Colors.green))
                  ),
            OTPTextField(
              length: 6,
              width: MediaQuery.of(context).size.width,
              textFieldAlignment: MainAxisAlignment.spaceAround,
              keyboardType: TextInputType.number,
              fieldWidth: 50,
              fieldStyle: FieldStyle.underline,
              style: TextStyle(
                  fontSize: 17
              ),
              onCompleted: (pin) {
                print("Completed: " + pin);
                otp=pin;
                print(otp);
              }
              ),

                  // MaterialButton(
                  //   onPressed: ()=>signIn(context),
                  //   child: Text("submit"),
                  //   minWidth: 500,
                  // ),
                  SizedBox(height: 16,),
                  SizedBox(height: 16,),
                  pro?Center(child: CircularProgressIndicator(),):
                  Container(
                    color: Colors.green,
                    width: double.infinity,
                    child: FlatButton(
                      child: Text("Submit"),
                      textColor: Colors.white,
                      padding: EdgeInsets.all(16),
                      onPressed: (){
                        if (_formKey.currentState.validate())
                          {
                        _formKey.currentState.save();
                            signIn(context);
                               }
                            }
                          )
                    ),

                ]
            ),
          ),
        ),
      ),
    );
  }
  Future<void> verifyPhone() async {
    print(widget.phone);
    setState(() {
      // startTimer();
      // textEditingController.clear();
    });

    PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      this.verificationId = verificationId;
    };

    // PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
    //     (String verificationId) {
    //   _verificationId = verificationId;
    // };

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: "+91 "+widget.phone,
        timeout: const Duration(seconds: 112),
        verificationCompleted: (AuthCredential phoneAuthCredential) async{},
        verificationFailed:   (FirebaseAuthException e){
          print("${e.message}");
        },
        codeSent: codeSent,
        codeAutoRetrievalTimeout:  (String verId) {
          this.verificationId = verId;
        },);
    } catch (e) {
      FocusScope.of(context).requestFocus(new FocusNode());
      setState(() {
        //errorMessage = '${e.toString()}';
      });

      // handleError(e);
    }


  }
  _getCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        lat=_currentPosition.latitude;
        lon=_currentPosition.longitude;
        print(lat);
        print(lon);
      });

      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress =
        "${place.name}, ${place.administrativeArea}, ${place.locality}";
           city=place.locality;
           state=place.administrativeArea;
        locationname=place.locality;
      });
      print(city);
      print(state);
      print(locationname);
    } catch (e) {
      print(e);
    }
  }
  List product=[] ;
  void ProductView () async {
    setState(() {
      progress = true;
    });
    var url = Prefmanager.baseurl + '/product/myproducts';
    print("ghjkjklk");
    var token = await Prefmanager.getToken();
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'x-auth-token': token
    };
    var response = await http.get(url, headers: requestHeaders);
    print(json.decode(response.body));
    if (json.decode(response.body)['status']) {
      Navigator.pushReplacement(
                      context, new MaterialPageRoute(
                      builder: (context) => new AddProfile()));
    }
    else{
      Navigator.pushReplacement(
                      context, new MaterialPageRoute(
                      builder: (context) => new ViewCategory()));
    }

  }

}
