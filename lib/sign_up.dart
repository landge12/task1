import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../utils/utils.dart';
import 'log_in.dart';


class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool loading = false;
  final _formkey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  bool _obscureText = true;
  bool _obscureText1 = true;
  late TextEditingController passController;
  late TextEditingController passController1;

  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    passController1 = TextEditingController();
    passController = TextEditingController();
  }

  @override
  void dispose() {
    passController1 = TextEditingController();
    emailController.dispose();
    passController.dispose();
    super.dispose();
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
                  'Sign Up',
                  style: TextStyle(fontFamily: 'kanit', fontSize: 48, color: Colors.purple),
                ),
              ),
              const SizedBox(height: 40),
              SingleChildScrollView(
                child: TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    suffixIcon: Icon(Icons.account_circle,color: Colors.grey,),
                    hintText: 'Enter Name',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(color: Colors.purple, width: 1),
                    ),
                  ),
                  validator: (value){
                    if(value!.isEmpty){
                      return 'Please Enter Name';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: phoneController,
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.phone,color: Colors.grey,),
                  hintText: 'Enter Contact No.',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.purple, width: 1),
                  ),
                ),
                validator: (value){
                  if(value!.isEmpty){
                    return 'Please Enter Name';
                  }
                  if(value.length>10 || value.length<10){
                    return 'Please enter 10 digit number only';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 10),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
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
                    return 'Please Enter Email';
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
                  hintText: 'Create Password',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.purple, width: 1),
                  ),
                ),
                validator: (value){
                  if(value!.isEmpty){
                    return 'Please Enter Password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                obscureText: _obscureText1,
                controller: passController1,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(
                      color: Colors.grey,
                      _obscureText1 ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText1 = !_obscureText1;
                      });
                    },
                  ),
                  hintText: 'Confirm New Password',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.purple, width: 1),
                  ),
                ),
                validator: (value){
                  if(value != passController.text){
                    return 'Both password must be same';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {
                  if(_formkey.currentState!.validate()){
                    setState(() {
                      loading = true;
                    });
                    _auth.createUserWithEmailAndPassword(
                        email: emailController.text.toString(),
                        password: passController.text.toString()
                    ).then((value){
                      Utils().toastMessage('Successfully created account!');
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const LogIn()));
                      setState(() {
                        loading = false;
                      });
                    }).onError((error,stackTrace){
                      setState(() {
                        loading = false;
                      });
                      Utils().toastMessage(error.toString());
                    });

                  }
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.purple.shade600),
                ),
                child: loading ? const Center(child: CircularProgressIndicator(strokeWidth: 3,color: Colors.white,)): const Center(child: Text('Sign Up', style: TextStyle(color: Colors.white70))),
              ),

              const SizedBox(height: 10),
              RichText(
                text: TextSpan(
                  text: 'Already have an account? ',
                  style: const TextStyle(color: Colors.black, fontSize: 15),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Log In',
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>LogIn()));
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
