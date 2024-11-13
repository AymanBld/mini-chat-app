// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:chat/back_circl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    late String email;
    late String password;
    late String username;
    late String phone;

    return Scaffold(
      backgroundColor: Colors.grey[400],
      body: Stack(
        fit: StackFit.expand,
        children: [
          PartOfBack(
            begin: Colors.white,
            end: Colors.grey[600]!,
            radius: 600,
            isTop: false,
          ),
          PartOfBack(
            begin: Colors.blueGrey[700]!,
            end: Colors.indigo[500]!,
            radius: 350,
            isTop: false,
          ),
          SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: size.height * 0.15),
                Text(
                  'Create \nAccount',
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 30),
                TextField(
                  onChanged: (value) {
                    username = value;
                  },
                  style: TextStyle(color: Colors.indigo),
                  decoration: InputDecoration(
                    prefixIconColor: Colors.black,
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                    prefixIcon: Icon(Icons.person_outline),
                    labelText: 'Username',
                  ),
                ),
                TextField(
                  onChanged: (value) {
                    phone = value;
                  },
                  style: TextStyle(color: Colors.indigo),
                  decoration: InputDecoration(
                    prefixIconColor: Colors.black,
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                    prefixIcon: Icon(Icons.phone_android),
                    labelText: 'Phone number',
                  ),
                ),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    email = value;
                  },
                  style: TextStyle(color: Colors.indigo),
                  decoration: InputDecoration(
                    prefixIconColor: Colors.black,
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                    prefixIcon: Icon(Icons.email_outlined),
                    labelText: 'Email',
                  ),
                ),
                TextField(
                  obscureText: true,
                  onChanged: (value) {
                    password = value;
                  },
                  style: TextStyle(color: Colors.indigo),
                  decoration: InputDecoration(
                    prefixIconColor: Colors.black,
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                    prefixIcon: Icon(Icons.password),
                    labelText: 'Password',
                  ),
                ),
                SizedBox(height: 40),
                MaterialButton(
                  minWidth: double.infinity,
                  height: 50,
                  color: Colors.deepPurple[900],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  onPressed: () async {
                    try {
                      await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                        email: email,
                        password: password,
                      );
                      await FirebaseAuth.instance.currentUser!
                          .sendEmailVerification();
                      await FirebaseFirestore.instance
                          .collection('profiles')
                          .add(
                        {
                          'email': email,
                          'username': username,
                          'phone': '$phone',
                          'photo': 'none'
                        },
                      );
                      Navigator.of(context).pushReplacementNamed('login');
                    } on FirebaseAuthException catch (e) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Error'),
                          content: Text(e.message!),
                        ),
                      );
                    }
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account ?',
                      style: TextStyle(color: Colors.white),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed('login');
                      },
                      child: Text(
                        'Sign in',
                        style: TextStyle(color: Colors.indigo[300]),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
