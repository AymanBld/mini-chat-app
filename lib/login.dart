import 'package:chat/back_circl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login extends StatefulWidget {
  const Login({super.key});
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    bool isloading = false;
    final Size size = MediaQuery.of(context).size;
    final TextEditingController rstpass = TextEditingController();
    // final TextEditingController _email = TextEditingController();
    late String email;
    late String password;

    Future signInWithGoogle() async {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      final UserCredential user = await FirebaseAuth.instance.signInWithCredential(credential);

      if (user.additionalUserInfo!.isNewUser) {
        await FirebaseFirestore.instance.collection('profiles').add({
          'phone': user.user!.phoneNumber,
          'email': user.user!.email,
          'photo': user.user!.photoURL,
          'username': user.user!.displayName,
        });
      }

      await Navigator.of(context).pushReplacementNamed('home');
    }

    return Scaffold(
      backgroundColor: Colors.grey[400],
      body: isloading == true
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              fit: StackFit.expand,
              children: [
                PartOfBack(
                  begin: Colors.black,
                  end: Colors.grey[600]!,
                  radius: 700,
                  isTop: true,
                ),
                const PartOfBack(
                  begin: Colors.red,
                  end: Colors.pink,
                  radius: 350,
                  isTop: true,
                ),
                SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: size.height * 0.15),
                      const Text(
                        'Welcom \nback',
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 30),
                      TextField(
                        // controller: _email,
                        onChanged: (value) {
                          email = value;
                        },
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(color: Colors.indigo),
                        decoration: const InputDecoration(
                          prefixIconColor: Colors.white,
                          labelStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                          prefixIcon: Icon(Icons.email_outlined),
                          labelText: 'Email',
                        ),
                      ),
                      TextField(
                        // controller: _password,
                        onChanged: (value) {
                          password = value;
                        },
                        obscureText: true,
                        style: const TextStyle(color: Colors.indigo),
                        decoration: const InputDecoration(
                          prefixIconColor: Colors.white,
                          labelStyle: TextStyle(color: Colors.white),
                          prefixIcon: Icon(Icons.password),
                          labelText: 'Password',
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          child: const Text(
                            'Forgot password ?',
                            style: TextStyle(
                              color: Colors.pink,
                            ),
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Reset password'),
                                content: SizedBox(
                                  height: 150,
                                  child: Column(
                                    children: [
                                      TextField(
                                        controller: rstpass,
                                      ),
                                      const Text(
                                        'entr your email her to send the link of reset password',
                                      ),
                                      FilledButton(
                                        onPressed: () {
                                          FirebaseAuth.instance
                                              .sendPasswordResetEmail(email: rstpass.text);
                                        },
                                        child: const Text('send'),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      MaterialButton(
                        minWidth: double.infinity,
                        height: 50,
                        color: Colors.pink,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'login',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        onPressed: () async {
                          try {
                            // print(
                            //     '======================${email} =========$password');
                            setState(() {
                              isloading = true;
                            });
                            await FirebaseAuth.instance.signInWithEmailAndPassword(
                              email: email,
                              password: password,
                            );
                            setState(() {
                              isloading = false;
                            });

                            if (FirebaseAuth.instance.currentUser!.emailVerified) {
                              Navigator.of(context).pushNamed('home');
                            } else {
                              FirebaseAuth.instance.signOut();
                              showDialog(
                                context: context,
                                builder: (context) => const AlertDialog(
                                  title: Text('Email not verified'),
                                  content: Text('please verifi your email first from the link'),
                                ),
                              );
                            }
                          } on FirebaseAuthException catch (e) {
                            setState(() {
                              isloading = false;
                            });
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Error'),
                                content: Text(e.message!),
                              ),
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 10),
                      MaterialButton(
                        minWidth: double.infinity,
                        height: 50,
                        color: Colors.blueGrey[900],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'login with Google',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        onPressed: () async {
                          await signInWithGoogle();
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Don\'t have an account ?',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          TextButton(
                            // style: const ButtonStyle(),
                            onPressed: () {
                              Navigator.of(context).pushReplacementNamed('register');
                            },
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(
                                color: Colors.pink,
                              ),
                            ),
                          )
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
