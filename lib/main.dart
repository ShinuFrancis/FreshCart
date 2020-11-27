import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:freshcart_seller/Home.dart';
import 'package:freshcart_seller/NetworkUtils/Prefmanager.dart';
import 'package:freshcart_seller/first.dart';
import 'package:firebase_auth/firebase_auth.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FRESH CART',
      theme: ThemeData(

        primarySwatch: Colors.green,

        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'FRESH CART'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);


  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), ()=>redirect(),
    );
  }
  var t;
  void redirect() async{
    t = await Prefmanager.getToken();
    if(t != null )
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder:
              (context) =>
              AddProfile()
          )
      );
    else
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder:
              (context) =>
                  SecondScreen()
          )
      );
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      //child:FlutterLogo(size:MediaQuery.of(context).size.height)
      child:Image(image: AssetImage('Assets/spl.png'),width:50,height: 50,),
    );
  }
}
class SecondScreen extends StatelessWidget {
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var email,phone;
  Future<bool>_willpopCallback()async{
    exit(0);
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop:_willpopCallback,
      child: Scaffold(
          key: _scaffoldKey,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(32),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 50,),
                    Text("SignUp", style: TextStyle(color: Colors.green, fontSize: 36, fontWeight: FontWeight.w500),),

                    SizedBox(height:100,),
                    //Image(image: AssetImage('Assets/sigup.png'),width:300,height: 300, fit:BoxFit.cover,),

                    TextFormField(
                      validator: (value) {
                        Pattern pattern =r'(^(?:[+0]9)?[0-9]{10,12}$)';
                        RegExp regex = new RegExp(pattern);
                        if (value.isEmpty) {
                          return 'ph';
                        }

                        else if (!regex.hasMatch(value))
                          return 'Invalid phone number';
                        else
                          return null;

                      },
                      onSaved:(v){
                        phone=v;

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
                          hintText: "Phone Number"
                      ),

                      keyboardType: TextInputType.number,
                      controller: _phoneController,
                    ),

                    SizedBox(height: 16,),

                    SizedBox(height: 16,),
                    SizedBox(height: 16,),

                    Container(
                      color: Colors.green,
                      width: double.infinity,
                      child: FlatButton(
                        child: Text("Get OTP"),
                        textColor: Colors.white,
                        padding: EdgeInsets.all(16),
                        onPressed: (){
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            Navigator.push(context, MaterialPageRoute(builder: (
                                context) => LoginSample(_phoneController.text)),
                            );
                          }

                          //code for sign in
                         // Place B
                         //  final phone = _phoneController.text.trim();
                         //
                         //  loginUser(phone, context);
                        },
                        color: Colors.green,
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
      ),
    );
  }

 }