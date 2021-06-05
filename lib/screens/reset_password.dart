import 'package:flutter/material.dart';
import 'package:imemo_mobile/screens/signin.dart';

import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class ResetPassword extends StatefulWidget {
  @override 
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                SizedBox(height: 30),
                Container(
                  width: double.infinity,
                  //decoration: BoxDecoration(color: Colors.greenAccent),
                  
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(left: 24),
                            
                            child: IconButton(
                              icon: Icon(Icons.arrow_back, size: 25, color: Color(0xff440888)),
                              onPressed: () {
                                Navigator.pushReplacement(context, MaterialPageRoute(
                                  builder: (context) => SignIn(),
                                ));
                              },
                            )
                          ),
                        ],
                      ),
                      SizedBox(height: 70),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        child: Text(
                          'Reset password',
                          style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: Color(0xff440888)),
                        )
                      ),
                      SizedBox(height: 7),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        child: Text(
                          'Enter the email you use to sign in to.',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xff808080)),
                        )
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 120),
                _SignInForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SignInForm extends StatefulWidget {
  @override 
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<_SignInForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  _toggleObscurePassword() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  _toggleObscureConfirm() {
    setState(() {
      _obscureConfirm = !_obscureConfirm;
    });
  }

  @override 
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,

      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 40),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: <Widget>[
            // Email Input
            TextFormField(
              controller: _emailController,
              validator: (String value) {
                RegExp re = RegExp(
                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))',
                );

                if (value.isEmpty) return 'Please enter your email!';
                else if (!re.hasMatch(value)) return 'Please enter a vaild email!';
                return null;
              },

              style: TextStyle(fontSize: 22, color: Color(0xff440888)),
              decoration: const InputDecoration(
                hintText: 'Email address',
                hintStyle: TextStyle(
                  fontWeight: FontWeight.bold, 
                  color: Color(0xffbababa)
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff440888)),
                ),  
              ),
            ),

            SizedBox(height: 60),

            // Reset Password Button
            Container(
              width: double.infinity,

              child: ElevatedButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    EdgeInsets.symmetric(vertical: 14),
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7)
                    )
                  ),
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Color(0xff440888)
                  ),
                ),
                child: Text(
                  'Send My Password',
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {}
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}