import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
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
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var email,phone;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  Text("SignUp", style: TextStyle(color: Colors.lightBlue, fontSize: 36, fontWeight: FontWeight.w500),),

                  SizedBox(height:100,),

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
                  // TextFormField(
                  //
                  //   decoration: InputDecoration(
                  //       enabledBorder: OutlineInputBorder(
                  //           borderRadius: BorderRadius.all(Radius.circular(8)),
                  //           borderSide: BorderSide(color: Colors.grey[200])
                  //       ),
                  //       focusedBorder: OutlineInputBorder(
                  //           borderRadius: BorderRadius.all(Radius.circular(8)),
                  //           borderSide: BorderSide(color: Colors.grey[300])
                  //       ),
                  //       filled: true,
                  //       fillColor: Colors.grey[100],
                  //       hintText: "Name"
                  //
                  //   ),
                  //   //keyboardType: TextInputType.number,
                  //   controller: _nameController,
                  // ),
                  // SizedBox(height: 16,),
                  // TextFormField(
                  //   validator: (value) {
                  //     if (value.isEmpty) {
                  //       return 'email';
                  //     }
                  //     /*else if (!value.contains("@"))
                  //       return "Please enter valid email";
                  //     else
                  //       return null;*/
                  //     Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                  //     RegExp regex = new RegExp(pattern);
                  //     if (!regex.hasMatch(value))
                  //       return 'Invalid Email';
                  //     else
                  //       return null;
                  //     },
                  //       onSaved:(v) {
                  //         email = v;
                  //       },
                  //       decoration: InputDecoration(
                  //       enabledBorder: OutlineInputBorder(
                  //           borderRadius: BorderRadius.all(Radius.circular(8)),
                  //           borderSide: BorderSide(color: Colors.grey[200])
                  //       ),
                  //       focusedBorder: OutlineInputBorder(
                  //           borderRadius: BorderRadius.all(Radius.circular(8)),
                  //           borderSide: BorderSide(color: Colors.grey[300])
                  //       ),
                  //
                  //       filled: true,
                  //       fillColor: Colors.grey[100],
                  //       hintText: "Email"
                  //
                  //   ),
                  //
                  //   //keyboardType: TextInputType.number,
                  //   controller: _emailController,
                  // ),



                  SizedBox(height: 16,),
                  SizedBox(height: 16,),

                  Container(
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
                      color: Colors.blue,
                    ),
                  )
                ],
              ),
            ),
          ),
        )
    );
  }

 }