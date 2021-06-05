import 'package:flutter/material.dart';
import 'package:imemo_mobile/screens/signup.dart';
import 'package:imemo_mobile/screens/signin.dart';

class FirstScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // App Logo
              Container(
                width: double.infinity,
                height: 270,
                alignment: Alignment.bottomCenter,
                //decoration: BoxDecoration(color: Colors.greenAccent),

                child: Image.asset(
                  'assets/images/app_logo_full.jpg',
                  height: 90,
                ),
              ),

              SizedBox(height: 100),

              Container(
                child: Text(
                  'Welcome!',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff2b184c),
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Introduction
              Container(
                width: double.infinity,
                alignment: Alignment.center,
                //decoration: BoxDecoration(color: Colors.red),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: Text(
                        'iMemo helps you to take notes,',
                        style: TextStyle(
                          fontSize: 22,
                          color: Color(0xffA197AD),
                        ),
                      ),
                    ),
                    Container(
                      child: Text(
                        'easily and quickly.',
                        style: TextStyle(
                          fontSize: 22,
                          color: Color(0xffA197AD),
                        ),
                      ),
                    )
                  ]
                )
              ),

              SizedBox(height: 70),

              // Get Started Button
              Container(
                child: ElevatedButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      EdgeInsets.symmetric(horizontal: 40, vertical: 14),
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
                    'GET STARTED',
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context) => SignUp(),
                    ));
                  },
                ),
              ),

              SizedBox(height: 114),

              // Sign In
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
            ],
          ),
        ),
      ),
    );
  }
}