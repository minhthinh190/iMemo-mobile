import 'package:flutter/material.dart';
import 'package:imemo_mobile/screens/signup.dart';
import 'package:imemo_mobile/screens/reset_password.dart';
import 'package:imemo_mobile/screens/home.dart';

import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class SignIn extends StatefulWidget {
  @override 
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 40),

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
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Image.asset(
                            'assets/images/app_logo_full.jpg',
                            height: 32,
                          )
                        ],
                      ),
                      SizedBox(height: 70),
                      Text(
                        'Sign In',
                        style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold, color: Color(0xff440888)),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 80),
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

  bool _obscurePassword = true;

  _toggleObscurePassword() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  // Sign In Function
  Future<void> _signInWithEmailAndPassword() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${userCredential.user.email} logged in.')),
      );
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => Home(),
      ));
    } on FirebaseAuthException catch(err) {
      switch(err.code) {
        case 'user-not-found':
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('No user found for that email!'),
              backgroundColor: Colors.redAccent,
            ),
          );
          break;
        case 'wrong-password':
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Wrong password!'),
              backgroundColor: Colors.redAccent,
            ),
          );
          break;
        default: 
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('An undefined error happened!'),
              backgroundColor: Colors.redAccent,
            ),
          );
      }
    }
  }

  @override 
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,

      child: Container(
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

            SizedBox(height: 40),

            // Password Input
            TextFormField(
              controller: _passwordController,
              validator: (String value) {
                if (value.isEmpty) return 'Please enter your password!';
                else if (value.length < 6) return 'Password must have at least 6 characters!';
                return null;
              },
              obscureText: _obscurePassword,
              
              style: TextStyle(fontSize: 22, color: Color(0xff440888)),
              decoration: InputDecoration(
                hintText: 'Password',
                hintStyle: TextStyle(
                  fontWeight: FontWeight.bold, 
                  color: Color(0xffbababa)
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff440888)),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword? Icons.visibility_off : Icons.visibility,
                  ),
                  focusColor: Color(0xff440888),
                  onPressed: _toggleObscurePassword,
                ),
              ),
            ),

            SizedBox(height: 60),

            // Sign In Button
            Container(
              width: double.infinity,

              child: ElevatedButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    EdgeInsets.symmetric(horizontal: 100, vertical: 14),
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
                  'Sign In',
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    await _signInWithEmailAndPassword();
                  }
                },
              ),
            ),

            // Sign Up, Forgot Password
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 15),
              //decoration: BoxDecoration(color: Colors.greenAccent),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: <Widget>[
                  GestureDetector(
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 15, 
                        fontWeight: FontWeight.bold,
                        color: Color(0xff440888)
                      ),
                    ),
                    onTap: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) => SignUp(),
                      ));
                    },
                  ),
                  GestureDetector(
                    child: Text(
                      'Forgot password?',
                      style: TextStyle(
                        fontSize: 15, 
                        fontWeight: FontWeight.bold,
                        color: Color(0xff440888)
                      ),
                    ),
                    onTap: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) => ResetPassword(),
                      ));
                    },
                  ),
                ],
              ),
            ),

            // Sign Up with Google
            /*Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 20),
              //decoration: BoxDecoration(color: Colors.greenAccent),

              child: Column(
                children: <Widget>[
                  Text(
                    'OR',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 30),

                  // Google Sign Up Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(12),
                      primary: Colors.white,
                    ),
                    child: Image.asset(
                      'assets/images/google_logo.png',
                      height: 50,
                    ),
                    onPressed: () {},
                  ),
                ],
              )
            )*/
          ],
        ),
      ),
    );
  }
}