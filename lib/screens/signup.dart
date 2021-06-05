import 'package:flutter/material.dart';
import 'package:imemo_mobile/screens/signin.dart';
import 'package:imemo_mobile/screens/home.dart';

// Import Firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class SignUp extends StatefulWidget {
  @override 
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 40),
            margin: EdgeInsets.only(bottom: 40),

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
                        'Sign Up',
                        style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold, color: Color(0xff440888)),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 50),
                _SignUpForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SignUpForm extends StatefulWidget {
  @override 
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<_SignUpForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // TextFormField Controller
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
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

  // Create Account Function
  Future<void> _createAccount(String email, String username, String password) async {
    try {
      // create account in Firebase Authentication
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // create user data in Firestore
      CollectionReference users = FirebaseFirestore.instance.collection('Users');
      users.doc(email).set({
        'email': email,
        'username': username,
        'memos': {
          'all': [],
          'pinned': [],
        },
      })
      .then((value) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Welcome to iMemo!')),
        );
      })
      .catchError((err) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create account!')),
        );
      });
    } on FirebaseAuthException catch(err) {
      if (err.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Email already existed!')),
        );
      }
    } catch(err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(err.toString())),
      );
    }
  }

  // Sign In Function 
  Future<void> _signInWithEmailAndPassword() async {
    try {
      final User user = (await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text
      ))
      .user;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${user.email} signed in.')),
      );
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => Home(),
      ));
    } catch(err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to sign in!' + err.toString())),
      );
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

              style: TextStyle(fontSize: 22),
              decoration: const InputDecoration(
                hintText: 'Email address *',
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

            // Username Input
            TextFormField(
              controller: _usernameController,
              validator: (String value) {
                if (value.isEmpty) return 'Please enter an username!';
                return null;
              },

              style: TextStyle(fontSize: 22),
              decoration: const InputDecoration(
                hintText: 'Username *',
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

              style: TextStyle(fontSize: 22),
              decoration: InputDecoration(
                hintText: 'Password *',
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
                  onPressed: _toggleObscurePassword,
                ),
              ),
            ),

            SizedBox(height: 40),

            // Confirm Password Input
            TextFormField(
              controller: _confirmController,
              validator: (String value) {
                if (value.isEmpty) return 'Re-enter your password!';
                else if (value != _passwordController.text) {
                  return 'Password does not match!';
                }
                return null;
              },
              obscureText: _obscureConfirm,

              style: TextStyle(fontSize: 22),
              decoration: InputDecoration(
                hintText: 'Confirm password *',
                hintStyle: TextStyle(
                  fontWeight: FontWeight.bold, 
                  color: Color(0xffbababa)
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff440888)),
                ), 
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirm? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: _toggleObscureConfirm,
                ),
              ),
            ),

            SizedBox(height: 40),

            // Sign Up Button
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
                  'Sign Up',
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    await _createAccount(
                      _emailController.text.trim(),
                      _usernameController.text.trim(),
                      _passwordController.text,
                    );
                    await _signInWithEmailAndPassword();
                  }
                },
              ),
            ),

            // Sign in
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 20),
              //decoration: BoxDecoration(color: Colors.greenAccent),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: <Widget>[
                  Text(
                    'Already had an account? ',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  GestureDetector(
                    child: Text(
                      'Sign In',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff440888),
                      ),
                    ),
                    onTap: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) => SignIn(),
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