import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:new_task/home_page.dart';
import 'package:new_task/sign_up.dart';

import '../utils/utils.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});
  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  bool loading = false;
  final _formkey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  bool _obscureText = true;
  late TextEditingController passController;

  FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    passController = TextEditingController();
    emailController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  void login(){
    setState(() {
      loading = true;
    });
    _auth.signInWithEmailAndPassword(
      email: emailController.text.toString(),
      password: passController.text.toString(),
    ).then((value){
      setState(() {
        loading = false;
      });
      Utils().toastMessage('Logged in successfully!');
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const HomePage()));
    }).onError((error, stackTrace){
      setState(() {
        loading = false;
      });
      Utils().toastMessage(error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20),
        child: Form(
          key: _formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Center(
                child: Text(
                  'LogIn',
                  style: TextStyle(fontFamily: 'kanit', fontSize: 48, color: Colors.purple),
                ),
              ),
              const SizedBox(height: 40),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  suffixIcon: Icon(Icons.email,color: Colors.grey,),
                  hintText: 'Enter Email',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.purple, width: 1),
                  ),
                ),
                validator: (value){
                  if(value!.isEmpty){
                    return 'Please enter email id';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                obscureText: _obscureText,
                controller: passController,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(
                      color: Colors.grey,
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                  hintText: 'Enter Password',
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.purple, width: 1),
                  ),
                ),
                validator: (value){
                  if(value!.isEmpty){
                    return 'Please enter email id';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {
                  if(_formkey.currentState!.validate()){
                    login();
                  }
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.purple.shade600),
                ),
                child: loading ? const Center(child: CircularProgressIndicator(color: Colors.white,strokeWidth: 3,)) : const Center(child: Text('Log In', style: TextStyle(color: Colors.white70))),
              ),
              const SizedBox(height: 10),
              RichText(
                text: TextSpan(
                  text: 'Don\'t have an account?  ',
                  style: const TextStyle(color: Colors.black, fontSize: 15),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Sign up',
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>const SignIn()));
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
