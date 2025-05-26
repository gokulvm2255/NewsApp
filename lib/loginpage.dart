import 'package:flutter/material.dart';
import 'package:newsapp/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> _login() async{
    if(formkey.currentState!.validate()){
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setBool('isloggedin', true);
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Myapp()));
    }
  }


  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  void submitForm(){
    if(formkey.currentState!.validate()){}
  }
  String? validateEmail(value) {
    if (value!.isEmpty) {
      return 'Please enter Email';
    } else if (!value.contains('@')) {
      return 'Please Enter a Valid Email';
    } else {
      return null;
    }
  }
  String? validatePassword(String ? value) {
    if (value == null || value.isEmpty)
      return 'Enter a Valid Password';
      return null;
    
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 192, 212, 245),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.only(top: 140),
          child: Center(
            child: Form(
              key: formkey,
              child: Column(
                children: [
                  Text("Login",style: TextStyle(fontSize: 35,color: const Color.fromARGB(255, 48, 121, 157)),),
                  SizedBox(height: 5,),
                  Text('Welcome Back'),
                  SizedBox(height: 25,),
              
                  TextFormField(

                    autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator:validateEmail,
                    decoration: InputDecoration(
                      label: Text('Email'),
                      hintText: 'Enter Your Email',hintStyle: TextStyle(color: Colors.black),
                      prefixIcon: Icon(Icons.email),
                      border:OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
                  ),
                  SizedBox(height: 10,),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator:validatePassword,
                    decoration: InputDecoration(
                      label: Text('Password'),
                      hintText: 'Enter Your Password',hintStyle: TextStyle(color: Colors.black),
                      prefixIcon: Icon(Icons.password),
                      border:OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
                  ),
                  SizedBox(height: 40,),
              
                  InkWell(
                    onTap: (){
                      if(formkey.currentState!.validate()){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => Myapp()));}
                      else{
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please Correct Your Details'),));
                          
                          }
                    },
                    child: Container(
                      height: 50,
                      width: 160,
                      decoration: BoxDecoration(color: const Color.fromARGB(255, 0, 12, 21), borderRadius: BorderRadius.circular(25)),
                      child: Center(child: Text('Login',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),
                    ),
                  ),
                  SizedBox(height: 10,),
              
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Already Have An Account?'),
                      TextButton(onPressed: (){
                        _login();
                      }, child: Text('Login')),
                    ],
                  )
              
                ],
              ),
            ),
          ),
        ),
      )
    );
  }
}