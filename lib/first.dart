import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginSample extends StatefulWidget {
  final phone;
  LoginSample(this.phone);
  @override
  _LoginSample createState() => _LoginSample();
}

class _LoginSample extends State<LoginSample> {
  TextEditingController verificationController = TextEditingController();
  TextEditingController codeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var verify;
  var verificationId;
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState(){
    super.initState();
    verifyPhone();
  }


  signIn(BuildContext context) async {


    try {

      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: codeController.text,
      );
      final User user = (await _auth.signInWithCredential(credential)).user;
      print(user.getIdToken());

      var idToken = await user.getIdToken();
      print(idToken);



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
    return Scaffold(
      key: _scaffoldKey,

      appBar: AppBar(
        // iconTheme: IconThemeData(
        //     color: Colors.blue
        // ),
        backgroundColor: Colors.blue,
        elevation: 0.0,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.black12),
          onPressed: () => Navigator.of(context).pop(),
        ),
        //automaticallyImplyLeading: true,
      ),

      body: Form(
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

                Container(
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'number';
                      }
                      /*else if (!value.contains("@"))
                        return "Please enter valid email";
                      else
                        return null;*/


                      else
                        return null;
                    },

                    onSaved: (v) {
                      verify = v;
                    },
                    keyboardType: TextInputType.number,
                    controller: codeController,
                    decoration: InputDecoration(
                      //border: OutlineInputBorder(),
                      labelText: 'OTP',
                    ),
                  ),
                ),
                SizedBox(
                  width: 30,
                  height: 30,
                ),

                MaterialButton(
                  onPressed: ()=>signIn(context),
                  child: Text("submit"),
                  minWidth: 500,
                ),
              ]
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

}
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
//
// class HomeScreen extends StatelessWidget {
//
//   final FirebaseUser user;
//
//   HomeScreen({this.user});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         padding: EdgeInsets.all(32),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Text("You are Logged in succesfully", style: TextStyle(color: Colors.lightBlue, fontSize: 32),),
//             SizedBox(height: 16,),
//             Text("${user.phoneNumber}", style: TextStyle(color: Colors.grey, ),),
//           ],
//         ),
//       ),
//     );
//   }
// }